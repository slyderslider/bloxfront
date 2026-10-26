"""BloxFront: uploads PNG images to the experience's group through Open Cloud (key in
.secrets/roblox_api_key, never printed) and prints {file: asset id} as JSON.

    python tools/assets/upload_images.py --group 818671112 build/crate/rays.png exports/ui/Store/BloxFrontIcon.png
"""
import argparse
import json
import os
import time
import uuid

import upload_synth_sfx as u


def upload_image(path, name, group):
    boundary = "----bloxfront" + uuid.uuid4().hex
    meta = {"assetType": "Image", "displayName": name[:50], "description": "BloxFront image",
            "creationContext": {"creator": {"groupId": str(group)}}}
    body = b"".join([
        f'--{boundary}\r\nContent-Disposition: form-data; name="request"\r\nContent-Type: application/json\r\n\r\n'.encode(),
        json.dumps(meta).encode(), b"\r\n",
        f'--{boundary}\r\nContent-Disposition: form-data; name="fileContent"; filename="{os.path.basename(path)}"\r\n'
        f"Content-Type: image/png\r\n\r\n".encode(), open(path, "rb").read(), b"\r\n",
        f"--{boundary}--\r\n".encode(),
    ])
    op = u.req("POST", u.API + "/assets", body, {"Content-Type": f"multipart/form-data; boundary={boundary}"}, timeout=600)
    op_id = op.get("operationId") or op.get("path", "").split("/")[-1]
    delay = 1.0
    for _ in range(90):
        if op.get("done"):
            break
        time.sleep(delay)
        delay = min(delay * 1.5, 8.0)
        op = u.req("GET", f"{u.API}/operations/{op_id}")
    if "error" in op or not op.get("done"):
        raise u.ApiError(f"{name}: {json.dumps(op)[:400]}")
    resp = op.get("response", {})
    return str(resp.get("assetId") or resp.get("path", "").split("/")[-1])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--group", required=True)
    ap.add_argument("files", nargs="+")
    args = ap.parse_args()
    out = {}
    for f in args.files:
        name = "BloxFront " + os.path.splitext(os.path.basename(f))[0]
        try:
            out[f] = upload_image(f, name, args.group)
        except u.ApiError as e:
            out[f] = "FAILED " + str(e)[:200]
    print(json.dumps(out, indent=1))


if __name__ == "__main__":
    main()
