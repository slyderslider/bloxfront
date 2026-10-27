"""BloxFront: creates every Robux developer product of the experience (with its icon) through Open Cloud
and writes the ids into src/shared/Data/Products.luau and src/shared/Assets/ShopFlags.luau.

Products that already exist (same name) are reused, never duplicated, so a run can be repeated. The key
is read from .secrets/roblox_api_key and only sent in the x-api-key header (never printed).

    python tools/assets/create_products.py --universe 10773073437
"""
import argparse
import json
import os
import re
import urllib.error
import urllib.request
import uuid

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
API = "https://apis.roblox.com/developer-products/v2/universes"
PRODUCTS = os.path.join(ROOT, "src", "shared", "Data", "Products.luau")
SHOPFLAGS = os.path.join(ROOT, "src", "shared", "Assets", "ShopFlags.luau")
ICONS = os.path.join(ROOT, "exports", "ui", "Products")
FLAG_ART = os.path.join(ROOT, "assets", "shop_flags", "art")
FLAG_PRICE = {"rare": 49, "epic": 99, "legendary": 149}

MAIN = {
    "takeover": ("Take Over", "Take over the nation that knocked you out and keep playing."),
    "crate": ("Cosmetic Crate", "One cosmetic crate: a territory skin or flag you don't own yet."),
    "crate_first": ("First Crate", "Your first cosmetic crate at a discount."),
    "crate3": ("3 Cosmetic Crates", "Three cosmetic crates at once, cheaper than one by one."),
    "crate10": ("10 Cosmetic Crates", "Ten cosmetic crates at once, the best price per crate."),
    "unlock_mega": ("Unlock Mega Nuke", "Four times the blast of an Atom Bomb. Yours for good."),
    "unlock_scatter": ("Unlock Scattershot", "One nuke that splits into several warheads. Yours for good."),
    "unlock_reinforce": ("Unlock Reinforcements", "Call in extra troops when you need them. Yours for good."),
    "unlock_artillery": ("Unlock Artillery", "Shell enemy land from your own. Yours for good."),
    "unlock_airfield": ("Unlock Air Strike", "Strike from the air anywhere in range. Yours for good."),
    "unlock_railgun": ("Unlock Railgun", "Hit any building anywhere on the map. Yours for good."),
    "unlock_stars2x": ("Unlock 2x Stars", "Earn twice the stars from every match. Yours for good."),
    "unlock_reload2x": ("Unlock Rapid Reload", "Your silos reload twice as fast. Yours for good."),
    "starter_pack": ("Starter Pack", "Mega Nuke, Scattershot and 2x Stars in one pack, once."),
}


def key():
    return open(os.path.join(ROOT, ".secrets", "roblox_api_key"), encoding="utf-8").read().strip()


def call(method, url, fields=None, image=None):
    headers = {"x-api-key": key()}
    body = None
    if fields is not None or image is not None:
        boundary = "----bloxfront" + uuid.uuid4().hex
        parts = [f'--{boundary}\r\nContent-Disposition: form-data; name="{k}"\r\n\r\n{v}\r\n'.encode() for k, v in (fields or {}).items()]
        if image is not None:
            parts.append(f'--{boundary}\r\nContent-Disposition: form-data; name="imageFile"; filename="icon.png"\r\n'
                         f"Content-Type: image/png\r\n\r\n".encode() + open(image, "rb").read() + b"\r\n")
        parts.append(f"--{boundary}--\r\n".encode())
        body = b"".join(parts)
        headers["Content-Type"] = f"multipart/form-data; boundary={boundary}"
    r = urllib.request.Request(url, data=body, method=method, headers=headers)
    try:
        with urllib.request.urlopen(r, timeout=90) as resp:
            return resp.status, resp.read().decode("utf-8", "replace")
    except urllib.error.HTTPError as e:
        return e.code, e.read().decode("utf-8", "replace")


def existing(universe):
    out, token = {}, ""
    for _ in range(20):
        status, text = call("GET", f"{API}/{universe}/developer-products/creator?pageSize=100" + (f"&pageToken={token}" if token else ""))
        if status >= 300:
            raise SystemExit(f"listing products failed: HTTP {status} {text[:200]}")
        d = json.loads(text)
        for p in d.get("developerProducts", []):
            out[p.get("name")] = p.get("productId") or p.get("id")
        token = d.get("nextPageToken") or ""
        if not token:
            break
    return out


def catalogue():
    items = []
    prod = open(PRODUCTS, encoding="utf-8").read()
    for k, robux in re.findall(r"^\s*(\w+)\s*=\s*\{\s*id = \d+, robux = (\d+)", prod, re.M):
        name, desc = MAIN[k]
        items.append({"kind": "main", "key": k, "name": name, "desc": desc, "price": int(robux), "icon": os.path.join(ICONS, k + ".png")})
    fl = open(SHOPFLAGS, encoding="utf-8").read()
    for k, n, rarity in re.findall(r'\{ key = "(\w+)", name = "([^"]+)",[^\n]*?rarity = "(\w+)"', fl):
        items.append({"kind": "flag", "key": k, "name": n + " Flag", "price": FLAG_PRICE[rarity],
                      "desc": f"A {rarity} flag for your nation, by your name on the map and the leaderboard. Yours for good.",
                      "icon": os.path.join(FLAG_ART, k + ".png")})
    items.append({"kind": "set", "key": "halloween", "name": "Halloween Flag Bundle", "price": 299,
                  "desc": "All 6 Halloween flags at once. Yours for good.", "icon": os.path.join(ICONS, "bundle_halloween.png")})
    return items


def write_ids(ids):
    prod = open(PRODUCTS, encoding="utf-8").read()
    fl = open(SHOPFLAGS, encoding="utf-8").read()
    for it, pid in ids:
        if it["kind"] == "main":
            prod, n = re.subn(rf"(^\s*{it['key']}\s*=\s*\{{\s*)id = \d+", rf"\g<1>id = {pid}", prod, flags=re.M)
        elif it["kind"] == "flag":
            fl, n = re.subn(rf'(\{{ key = "{it["key"]}",[^\n]*?)product = \d+', rf"\g<1>product = {pid}", fl)
        else:
            fl, n = re.subn(rf"({it['key']} = \{{ )product = \d+", rf"\g<1>product = {pid}", fl)
        assert n == 1, (it["key"], n)
    open(PRODUCTS, "w", encoding="utf-8", newline="").write(prod)
    open(SHOPFLAGS, "w", encoding="utf-8", newline="").write(fl)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--universe", required=True)
    args = ap.parse_args()
    items = catalogue()
    have = existing(args.universe)
    ids = []
    for i, it in enumerate(items):
        pid = have.get(it["name"])
        if pid is None:
            fields = {"name": it["name"], "description": it["desc"], "price": str(it["price"]), "isForSale": "true"}
            icon = it["icon"] if os.path.exists(it["icon"]) else None
            status, text = call("POST", f"{API}/{args.universe}/developer-products", fields, icon)
            if status >= 300:
                print(f"[{i + 1}/{len(items)}] {it['name']} FAILED: HTTP {status} {text[:300]}")
                continue
            d = json.loads(text)
            pid = d.get("productId") or d.get("id")
            print(f"[{i + 1}/{len(items)}] {it['name']} ({it['price']} R$) -> {pid}" + ("" if icon else " (no icon)"))
        else:
            print(f"[{i + 1}/{len(items)}] {it['name']} exists -> {pid}")
        ids.append((it, int(pid)))
    write_ids(ids)
    print(f"{len(ids)}/{len(items)} products, ids written to Products.luau / ShopFlags.luau")


if __name__ == "__main__":
    main()
