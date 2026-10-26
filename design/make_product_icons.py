"""BloxFront: original 512x512 icons for every Robux developer product (Data/Products + the flag bundle).

Flat white glyphs on a rounded gradient tile, colour by category (crates, nukes, army, boosts, offers).
Writes design/bloxfront_product_icons.html for html_to_figma (one .pi frame per product).

    python design/make_product_icons.py
"""
import os

HERE = os.path.dirname(os.path.abspath(__file__))
W = "#ffffff"
TILES = {
    "crate": ("#ffb44d", "#c2701c"),
    "nuke": ("#ff7a6b", "#b8322d"),
    "army": ("#8f88ff", "#4a42d6"),
    "boost": ("#5fd4c4", "#1d8a7c"),
    "offer": ("#b89eff", "#6a3fd1"),
}


def chest(x, y, s):
    return (
        f'<rect x="{x}" y="{y + s * 0.28}" width="{s}" height="{s * 0.62}" rx="{s * 0.08}" fill="{W}"/>'
        f'<path d="M{x} {y + s * 0.34} Q{x + s / 2} {y - s * 0.12} {x + s} {y + s * 0.34} Z" fill="{W}"/>'
        f'<rect x="{x}" y="{y + s * 0.36}" width="{s}" height="{s * 0.07}" fill="#000" opacity="0.22"/>'
        f'<rect x="{x + s * 0.42}" y="{y + s * 0.3}" width="{s * 0.16}" height="{s * 0.24}" rx="{s * 0.03}" fill="#000" opacity="0.3"/>'
    )


def missile(cx, cy, s, rot=0):
    return (
        f'<g transform="rotate({rot} {cx} {cy})">'
        f'<path d="M{cx} {cy - s * 0.5} Q{cx + s * 0.16} {cy - s * 0.3} {cx + s * 0.14} {cy + s * 0.2} L{cx - s * 0.14} {cy + s * 0.2} '
        f'Q{cx - s * 0.16} {cy - s * 0.3} {cx} {cy - s * 0.5} Z" fill="{W}"/>'
        f'<path d="M{cx - s * 0.14} {cy + s * 0.05} L{cx - s * 0.3} {cy + s * 0.32} L{cx - s * 0.14} {cy + s * 0.26} Z" fill="{W}"/>'
        f'<path d="M{cx + s * 0.14} {cy + s * 0.05} L{cx + s * 0.3} {cy + s * 0.32} L{cx + s * 0.14} {cy + s * 0.26} Z" fill="{W}"/>'
        f'<circle cx="{cx}" cy="{cy - s * 0.18}" r="{s * 0.06}" fill="#000" opacity="0.25"/>'
        f'<path d="M{cx - s * 0.08} {cy + s * 0.24} L{cx} {cy + s * 0.48} L{cx + s * 0.08} {cy + s * 0.24} Z" fill="#ffd666"/>'
        f'</g>'
    )


def star(cx, cy, r, fill=W):
    import math
    pts = []
    for i in range(10):
        a = -math.pi / 2 + i * math.pi / 5
        rr = r if i % 2 == 0 else r * 0.45
        pts.append(f"{cx + rr * math.cos(a):.1f},{cy + rr * math.sin(a):.1f}")
    return f'<polygon points="{" ".join(pts)}" fill="{fill}"/>'


def soldier(cx, cy, s):
    return (
        f'<circle cx="{cx}" cy="{cy - s * 0.32}" r="{s * 0.2}" fill="{W}"/>'
        f'<path d="M{cx - s * 0.36} {cy + s * 0.4} Q{cx - s * 0.36} {cy - s * 0.08} {cx} {cy - s * 0.08} '
        f'Q{cx + s * 0.36} {cy - s * 0.08} {cx + s * 0.36} {cy + s * 0.4} Z" fill="{W}"/>'
        f'<rect x="{cx - s * 0.24}" y="{cy - s * 0.52}" width="{s * 0.48}" height="{s * 0.12}" rx="{s * 0.05}" fill="{W}"/>'
    )


def text(x, y, t, size, anchor="middle"):
    return (f'<text x="{x}" y="{y}" text-anchor="{anchor}" font-family="Rubik,Inter,sans-serif" font-weight="900" '
            f'font-size="{size}" fill="{W}" stroke="#000" stroke-opacity="0.25" stroke-width="8" paint-order="stroke">{t}</text>')


GLYPHS = {
    "takeover": ("offer", lambda: (
        '<path d="M126 330 L146 170 L206 240 L256 150 L306 240 L366 170 L386 330 Z" fill="#fff"/>'
        '<rect x="126" y="346" width="260" height="40" rx="12" fill="#fff"/>'
        '<circle cx="256" cy="282" r="22" fill="#000" opacity="0.22"/>')),
    "crate": ("crate", lambda: chest(136, 150, 240)),
    "crate_first": ("crate", lambda: chest(136, 170, 240) + text(392, 150, "1ST", 64)),
    "crate3": ("crate", lambda: chest(86, 210, 160) + chest(266, 210, 160) + chest(176, 110, 160)),
    "unlock_mega": ("nuke", lambda: missile(256, 256, 300) + '<circle cx="256" cy="256" r="196" fill="none" stroke="#fff" stroke-width="14" opacity="0.4"/>'),
    "unlock_scatter": ("nuke", lambda: missile(256, 270, 200) + missile(150, 230, 150, -28) + missile(362, 230, 150, 28)),
    "unlock_reinforce": ("army", lambda: soldier(150, 300, 150) + soldier(362, 300, 150) + soldier(256, 270, 190)),
    "unlock_artillery": ("army", lambda: (
        '<rect x="200" y="200" width="230" height="56" rx="20" fill="#fff" transform="rotate(-22 200 228)"/>'
        '<rect x="120" y="250" width="200" height="90" rx="26" fill="#fff"/>'
        '<circle cx="160" cy="356" r="44" fill="#fff"/><circle cx="160" cy="356" r="16" fill="#000" opacity="0.25"/>'
        '<circle cx="290" cy="356" r="44" fill="#fff"/><circle cx="290" cy="356" r="16" fill="#000" opacity="0.25"/>')),
    "unlock_airfield": ("army", lambda: (
        '<path d="M256 96 Q276 96 276 140 L276 220 L420 290 L420 330 L276 296 L276 380 L322 412 L322 440 L256 420 L190 440 '
        'L190 412 L236 380 L236 296 L92 330 L92 290 L236 220 L236 140 Q236 96 256 96 Z" fill="#fff"/>')),
    "unlock_railgun": ("army", lambda: (
        '<rect x="96" y="330" width="200" height="70" rx="20" fill="#fff"/>'
        '<circle cx="196" cy="320" r="62" fill="#fff"/>'
        '<rect x="196" y="270" width="230" height="40" rx="14" fill="#fff" transform="rotate(-30 196 290)"/>'
        '<path d="M380 150 L430 120" stroke="#ffd666" stroke-width="16" stroke-linecap="round"/>'
        '<path d="M392 182 L452 168" stroke="#ffd666" stroke-width="12" stroke-linecap="round" opacity="0.7"/>')),
    "unlock_stars2x": ("boost", lambda: star(220, 250, 150) + text(380, 400, "2×", 120)),
    "unlock_reload2x": ("boost", lambda: (
        '<path d="M256 120 A136 136 0 1 1 132 200" fill="none" stroke="#fff" stroke-width="46" stroke-linecap="round"/>'
        '<path d="M86 150 L172 140 L150 236 Z" fill="#fff"/>' + text(256, 300, "2×", 96))),
    "starter_pack": ("offer", lambda: (
        '<rect x="116" y="220" width="280" height="190" rx="22" fill="#fff"/>'
        '<rect x="96" y="170" width="320" height="70" rx="18" fill="#fff"/>'
        '<rect x="236" y="170" width="40" height="240" fill="#000" opacity="0.22"/>'
        '<path d="M256 170 Q196 90 166 140 Q156 170 256 170 Q356 170 346 140 Q316 90 256 170 Z" fill="#fff"/>')),
    "bundle_halloween": ("offer", lambda: (
        ''.join(f'<g transform="translate({dx} {dy})"><rect x="130" y="130" width="14" height="260" rx="6" fill="#fff"/>'
                f'<path d="M144 140 L330 140 L300 200 L330 260 L144 260 Z" fill="#fff"/></g>'
                for dx, dy in ((40, 30), (0, 0)))
        + text(380, 420, "×6", 96))),
}


def icon(key, cat, glyph):
    top, bottom = TILES[cat]
    return (
        f'<div class="pi" data-name="Product {key}" style="width:512px;height:512px">'
        f'<svg xmlns="http://www.w3.org/2000/svg" width="512" height="512" viewBox="0 0 512 512">'
        f'<defs><linearGradient id="g_{key}" x1="0" y1="0" x2="0" y2="1"><stop offset="0" stop-color="{top}"/>'
        f'<stop offset="1" stop-color="{bottom}"/></linearGradient></defs>'
        f'<rect width="512" height="512" rx="96" fill="url(#g_{key})"/>'
        f'<rect x="16" y="16" width="480" height="480" rx="84" fill="none" stroke="#fff" stroke-opacity="0.22" stroke-width="6"/>'
        f'<circle cx="256" cy="256" r="200" fill="#fff" opacity="0.08"/>'
        f'{glyph()}</svg></div>'
    )


def main():
    parts = ["<!doctype html><html><head><meta charset='utf-8'><style>*{margin:0;padding:0}body{background:#05070a;padding:40px;width:2400px;display:flex;flex-wrap:wrap;gap:40px}.pi{flex:0 0 512px}</style></head><body>"]
    parts += [icon(k, c, g) for k, (c, g) in GLYPHS.items()]
    parts.append("</body></html>")
    path = os.path.join(HERE, "bloxfront_product_icons.html")
    open(path, "w", encoding="utf-8").write("\n".join(parts))
    print("wrote", path, len(GLYPHS), "icons")


if __name__ == "__main__":
    main()
