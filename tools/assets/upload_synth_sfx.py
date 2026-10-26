"""BloxFront: uploads the synthesised sound effects (exports/audio/sfx, tools/assets/synth_sfx.py) to the
experience's group and writes the new ids into src/shared/Assets/Audio*.luau.

The Open Cloud key is read from .secrets/roblox_api_key and only sent in the x-api-key header (never
printed). Uploads are cached in exports/audio/sfx/uploaded.json, so a run that stops (quota, network)
resumes where it left off.

    python tools/assets/upload_synth_sfx.py --group 818671112            # upload + write manifests
    python tools/assets/upload_synth_sfx.py --group 818671112 --write    # only rewrite manifests
"""
import argparse
import json
import os
import re
import time
import urllib.error
import urllib.request
import uuid

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SFX = os.path.join(ROOT, "exports", "audio", "sfx")
CACHE = os.path.join(SFX, "uploaded.json")
API = "https://apis.roblox.com/assets/v1"


class ApiError(Exception):
    pass


def key():
    return open(os.path.join(ROOT, ".secrets", "roblox_api_key"), encoding="utf-8").read().strip()


def req(method, url, body=None, headers=None, timeout=120):
    h = {"x-api-key": key()}
    h.update(headers or {})
    tries = 5 if method == "GET" else 1
    for attempt in range(tries):
        r = urllib.request.Request(url, data=body, method=method, headers=h)
        try:
            with urllib.request.urlopen(r, timeout=timeout) as resp:
                return json.loads(resp.read() or b"{}")
        except urllib.error.HTTPError as e:
            raise ApiError(f"{method} {url.split('?')[0]} -> HTTP {e.code}: {e.read().decode('utf-8', 'replace')[:500]}") from None
        except (urllib.error.URLError, TimeoutError, ConnectionError, OSError) as e:
            if attempt + 1 >= tries:
                raise ApiError(f"{method} {url.split('?')[0]} -> network error: {e}") from None
            time.sleep(2.0 * (attempt + 1))


def upload(path, name, group):
    boundary = "----bloxfront" + uuid.uuid4().hex
    meta = {"assetType": "Audio", "displayName": name[:50], "description": "BloxFront sound effect",
            "creationContext": {"creator": {"groupId": str(group)}}}
    body = b"".join([
        f'--{boundary}\r\nContent-Disposition: form-data; name="request"\r\nContent-Type: application/json\r\n\r\n'.encode(),
        json.dumps(meta).encode(), b"\r\n",
        f'--{boundary}\r\nContent-Disposition: form-data; name="fileContent"; filename="{os.path.basename(path)}"\r\n'
        f"Content-Type: audio/wav\r\n\r\n".encode(), open(path, "rb").read(), b"\r\n",
        f"--{boundary}--\r\n".encode(),
    ])
    op = req("POST", API + "/assets", body, {"Content-Type": f"multipart/form-data; boundary={boundary}"}, timeout=600)
    op_id = op.get("operationId") or op.get("path", "").split("/")[-1]
    delay = 1.0
    for _ in range(90):
        if op.get("done"):
            break
        time.sleep(delay)
        delay = min(delay * 1.5, 8.0)
        op = req("GET", f"{API}/operations/{op_id}")
    if not op.get("done"):
        raise ApiError(f"{name}: operation {op_id} not done")
    if "error" in op:
        raise ApiError(f"{name}: {json.dumps(op['error'])[:400]}")
    resp = op.get("response", {})
    return str(resp.get("assetId") or resp.get("path", "").split("/")[-1])


def write_manifests(index, cache):
    by_manifest = {}
    for fname, meta in index.items():
        if fname in cache:
            by_manifest.setdefault(meta["manifest"], {})[meta["key"]] = cache[fname]
    for manifest, ids in by_manifest.items():
        path = os.path.join(ROOT, "src", "shared", "Assets", manifest)
        text = open(path, encoding="utf-8").read()
        head, sep, sfx = text.partition("sfx = {")
        n = 0
        for k, new in ids.items():
            sfx, c = re.subn(rf'(^\s*{k}\s*=\s*\{{\s*id = ")rbxassetid://\d+(")', rf"\g<1>rbxassetid://{new}\g<2>", sfx, flags=re.M)
            n += c
        open(path, "w", encoding="utf-8", newline="").write(head + sep + sfx)
        print(f"{manifest}: {n} ids written")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--group", required=True)
    ap.add_argument("--write", action="store_true", help="only rewrite the manifests from the cache")
    args = ap.parse_args()
    index = json.load(open(os.path.join(SFX, "index.json"), encoding="utf-8"))
    cache = json.load(open(CACHE, encoding="utf-8")) if os.path.exists(CACHE) else {}
    if not args.write:
        for i, fname in enumerate(sorted(index)):
            if fname in cache:
                continue
            name = "BloxFront " + fname[:-4]
            try:
                cache[fname] = upload(os.path.join(SFX, fname), name, args.group)
                print(f"[{i + 1}/{len(index)}] {fname} -> {cache[fname]}")
            except ApiError as e:
                print(f"[{i + 1}/{len(index)}] {fname} FAILED: {e}")
                json.dump(cache, open(CACHE, "w", encoding="utf-8"), indent=1)
                if "HTTP 4" in str(e) and ("quota" in str(e).lower() or "429" in str(e) or "limit" in str(e).lower()):
                    print("stopping: quota / rate limit")
                    break
                continue
            json.dump(cache, open(CACHE, "w", encoding="utf-8"), indent=1)
    print(f"{len(cache)}/{len(index)} uploaded")
    write_manifests(index, cache)


if __name__ == "__main__":
    main()
