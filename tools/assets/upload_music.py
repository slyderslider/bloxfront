"""BloxFront: uploads the music (exports/audio/music/*.ogg, loudness-normalised to about -23 LUFS) to the
experience's group and prints {file: asset id}. The key is read from .secrets/roblox_api_key.

    python tools/assets/upload_music.py --group 818671112
"""
import argparse
import json
import os
import time
import uuid

import upload_synth_sfx as u

MUSIC = os.path.join(u.ROOT, "exports", "audio", "music")


def upload(path, name, group):
    boundary = "----bloxfront" + uuid.uuid4().hex
    meta = {"assetType": "Audio", "displayName": name[:50], "description": "BloxFront music",
            "creationContext": {"creator": {"groupId": str(group)}}}
    body = b"".join([
        f'--{boundary}\r\nContent-Disposition: form-data; name="request"\r\nContent-Type: application/json\r\n\r\n'.encode(),
        json.dumps(meta).encode(), b"\r\n",
        f'--{boundary}\r\nContent-Disposition: form-data; name="fileContent"; filename="{os.path.basename(path)}"\r\n'
        f"Content-Type: audio/ogg\r\n\r\n".encode(), open(path, "rb").read(), b"\r\n",
        f"--{boundary}--\r\n".encode(),
    ])
    op = u.req("POST", u.API + "/assets", body, {"Content-Type": f"multipart/form-data; boundary={boundary}"}, timeout=900)
    op_id = op.get("operationId") or op.get("path", "").split("/")[-1]
    delay = 2.0
    for _ in range(120):
        if op.get("done"):
            break
        time.sleep(delay)
        delay = min(delay * 1.5, 10.0)
        op = u.req("GET", f"{u.API}/operations/{op_id}")
    if "error" in op or not op.get("done"):
        raise u.ApiError(f"{name}: {json.dumps(op)[:400]}")
    resp = op.get("response", {})
    return str(resp.get("assetId") or resp.get("path", "").split("/")[-1])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--group", required=True)
    args = ap.parse_args()
    out = {}
    for f in sorted(os.listdir(MUSIC)):
        if f.endswith(".ogg"):
            out[f] = upload(os.path.join(MUSIC, f), "BloxFront music " + f[:-4], args.group)
            print(f, "->", out[f])
    json.dump(out, open(os.path.join(MUSIC, "uploaded.json"), "w", encoding="utf-8"), indent=1)


if __name__ == "__main__":
    main()
