"""BloxFront: builds the store art (icon + thumbnails) as one HTML file for html_to_figma.

Original BloxFront compositions: a pixel-grid world (the game's own tile look), indigo / coral / amber
nations, capital markers, and the BloxFront title. The map is generated here (seeded noise), so the
art contains nothing from other games.

    python design/make_marketing.py  ->  design/bloxfront_marketing.html
"""
import math
import os
import random

HERE = os.path.dirname(os.path.abspath(__file__))
SEA = ("#1f5f86", "#2a6f97")
PLAINS, HIGH, PEAK = "#9fcf8a", "#d9c79c", "#eef1f4"
NATIONS = {
    "indigo": ("#7f78ff", "#4a42d6"),
    "coral": ("#ff7a6b", "#c9413a"),
    "amber": ("#ffc46b", "#c98a22"),
    "teal": ("#5fd4c4", "#1f8f80"),
}


def field(w, h, seed, scale):
    rnd = random.Random(seed)
    pts = [(rnd.uniform(0, w), rnd.uniform(0, h), rnd.uniform(-1, 1)) for _ in range(int(w * h / scale))]

    def f(x, y):
        s = 0.0
        for px, py, v in pts:
            d = (x - px) ** 2 + (y - py) ** 2
            s += v * math.exp(-d / (scale * 1.2))
        return s

    return f


def world(w, h, seed, land_bias):
    """Grid of terrain kinds: 0 sea, 1 plains, 2 highland, 3 peak."""
    f = field(w, h, seed, 9.0)
    g = field(w, h, seed + 1, 5.0)
    grid = []
    for y in range(h):
        row = []
        for x in range(w):
            v = f(x, y) + land_bias(x / w, y / h)
            if v < 0:
                row.append(0)
            else:
                e = g(x, y) + v
                row.append(3 if e > 1.35 else 2 if e > 0.75 else 1)
        grid.append(row)
    return grid


def nations_of(grid, seeds):
    """Grows each nation from its seed cell over land, up to its size (BFS by rings)."""
    h, w = len(grid), len(grid[0])
    owner = [[None] * w for _ in range(h)]
    fronts = []
    for name, (sx, sy, size) in seeds.items():
        fronts.append([name, [(sx, sy)], size])
        owner[sy][sx] = name
    # random frontier growth (each step claims one random border cell): organic, blobby borders
    rnd = random.Random(len(seeds) * 97 + w)
    grew = True
    while grew:
        grew = False
        for item in fronts:
            name, front, left = item
            if left <= 0 or not front:
                continue
            for _ in range(6):
                if not front or item[2] <= 0:
                    break
                i = rnd.randrange(len(front))
                x, y = front[i]
                opts = [(x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))
                        if 0 <= x + dx < w and 0 <= y + dy < h and owner[y + dy][x + dx] is None and grid[y + dy][x + dx] > 0]
                if not opts:
                    front.pop(i)
                    continue
                nx, ny = rnd.choice(opts)
                owner[ny][nx] = name
                item[2] -= 1
                front.append((nx, ny))
                grew = True
    return owner


def svg_map(grid, owner, cell, extra=""):
    h, w = len(grid), len(grid[0])
    out = [f'<svg xmlns="http://www.w3.org/2000/svg" width="{w * cell}" height="{h * cell}" viewBox="0 0 {w * cell} {h * cell}" shape-rendering="crispEdges">']
    out.append(f'<rect width="100%" height="100%" fill="{SEA[0]}"/>')
    for y in range(h):
        for x in range(w):
            k = grid[y][x]
            o = owner[y][x]
            if k == 0:
                if (x * 7 + y * 3) % 11 == 0:
                    out.append(f'<rect x="{x * cell}" y="{y * cell}" width="{cell}" height="{cell}" fill="{SEA[1]}"/>')
                continue
            if o is not None:
                fill, edge = NATIONS[o]
                border = any(
                    not (0 <= x + dx < w and 0 <= y + dy < h) or owner[y + dy][x + dx] != o
                    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))
                )
                color = edge if border else fill
            else:
                color = (PLAINS, HIGH, PEAK)[k - 1]
            out.append(f'<rect x="{x * cell}" y="{y * cell}" width="{cell}" height="{cell}" fill="{color}"/>')
    out.append(extra)
    out.append("</svg>")
    return "".join(out)


def capital(cx, cy, r, color):
    return (
        f'<circle cx="{cx}" cy="{cy}" r="{r + 6}" fill="#ffffff" opacity="0.9"/>'
        f'<circle cx="{cx}" cy="{cy}" r="{r}" fill="{color}"/>'
        f'<path d="M{cx - r * 0.45} {cy + r * 0.35} L{cx - r * 0.45} {cy - r * 0.1} L{cx - r * 0.15} {cy - r * 0.35} '
        f'L{cx + r * 0.15} {cy - r * 0.1} L{cx + r * 0.45} {cy - r * 0.35} L{cx + r * 0.45} {cy + r * 0.35} Z" fill="#ffffff"/>'
    )


def icon():
    w = h = 32
    grid = world(w, h, 11, lambda u, v: 1.1 - 2.2 * ((u - 0.5) ** 2 + (v - 0.55) ** 2) ** 0.5)
    owner = nations_of(grid, {"indigo": (13, 15, 230), "coral": (25, 6, 70), "amber": (6, 27, 40)})
    cell = 16
    flag = (
        '<rect x="238" y="150" width="12" height="210" rx="5" fill="#ffffff"/>'
        '<path d="M250 158 L380 190 L250 236 Z" fill="#ffffff"/>'
        '<path d="M250 168 L352 192 L250 226 Z" fill="#6c63ff"/>'
        '<ellipse cx="244" cy="364" rx="46" ry="12" fill="#0e1116" opacity="0.35"/>'
    )
    return f'<div class="art" data-name="Icon 512" style="width:512px;height:512px;border-radius:0;overflow:hidden">{svg_map(grid, owner, cell, flag)}</div>'


def thumb(seed, name, title_side, nations, tagline, extra_fn):
    w, h, cell = 96, 54, 20
    grid = world(w, h, seed, lambda u, v: 0.9 - 1.9 * abs(v - 0.55) - 1.2 * abs(u - 0.55) ** 1.5)
    owner = nations_of(grid, nations)
    extra = extra_fn(cell)
    title_pos = "left:80px" if title_side == "left" else "right:80px;text-align:right"
    return f"""<div class="art" data-name="{name}" style="width:1920px;height:1080px;position:relative;overflow:hidden">
 {svg_map(grid, owner, cell, extra)}
 <div style="position:absolute;inset:0;background:linear-gradient(180deg,rgba(8,10,16,.55) 0%,rgba(8,10,16,0) 32%,rgba(8,10,16,0) 70%,rgba(8,10,16,.45) 100%)"></div>
 <div style="position:absolute;top:70px;{title_pos}">
  <div style="font:900 150px/1 Rubik,Inter,sans-serif;color:#fff;letter-spacing:4px;text-shadow:0 10px 0 #4a42d6,0 18px 40px rgba(0,0,0,.45)">BLOXFRONT</div>
  <div style="margin-top:22px;font:800 38px/1 Rubik,Inter,sans-serif;color:#fff;letter-spacing:10px;opacity:.95">{tagline}</div>
 </div>
</div>"""


def strike(cell):
    # indigo capital launches a strike arc at the coral capital: trail, blast rings
    ax, ay, bx, by = 30 * cell, 32 * cell, 66 * cell, 26 * cell
    mx, my = (ax + bx) / 2, min(ay, by) - 14 * cell
    return (
        f'<path d="M{ax} {ay} Q{mx} {my} {bx} {by}" fill="none" stroke="#ffffff" stroke-width="14" stroke-dasharray="4 26" stroke-linecap="round" opacity="0.95"/>'
        f'<circle cx="{bx}" cy="{by}" r="150" fill="#ffe0a3" opacity="0.35"/>'
        f'<circle cx="{bx}" cy="{by}" r="96" fill="#ffd27a" opacity="0.6"/>'
        f'<circle cx="{bx}" cy="{by}" r="52" fill="#fff4d6"/>'
        f'<circle cx="{bx}" cy="{by}" r="200" fill="none" stroke="#ffffff" stroke-width="8" opacity="0.5"/>'
        + capital(ax, ay, 30, "#6c63ff")
    )


def takeover(cell):
    pts = [(34, 30, "#6c63ff"), (58, 22, "#6c63ff"), (70, 36, "#6c63ff"), (22, 40, "#ff7a6b")]
    bar = (
        '<rect x="560" y="930" width="800" height="34" rx="17" fill="#0e1116" opacity="0.8"/>'
        '<rect x="566" y="936" width="610" height="22" rx="11" fill="#6c63ff"/>'
        '<rect x="1196" y="922" width="6" height="50" rx="3" fill="#ffd666"/>'
        '<text x="1380" y="960" font-family="Rubik,Inter,sans-serif" font-weight="900" font-size="44" fill="#ffffff" stroke="#0e1116" stroke-width="6" paint-order="stroke">78%</text>'
    )
    return "".join(capital(x * cell, y * cell, 26, c) for x, y, c in pts) + bar


def main():
    html = [
        "<!doctype html><html><head><meta charset='utf-8'><style>",
        "*{margin:0;padding:0;box-sizing:border-box}body{background:#05070a;padding:40px;width:2000px}",
        ".art{margin-bottom:60px} .art svg{display:block}",
        "</style></head><body>",
        icon(),
        thumb(21, "Thumbnail 1 - Strike", "right",
              {"indigo": (30, 32, 520), "coral": (66, 26, 430), "amber": (50, 44, 260), "teal": (78, 40, 220)},
              "CLAIM THE WHOLE MAP", strike),
        thumb(33, "Thumbnail 2 - Takeover", "left",
              {"indigo": (50, 28, 1500), "coral": (22, 40, 180), "amber": (84, 44, 120)},
              "OUTGROW EVERY NATION", takeover),
        "</body></html>",
    ]
    path = os.path.join(HERE, "bloxfront_marketing.html")
    open(path, "w", encoding="utf-8").write("\n".join(html))
    print("wrote", path, os.path.getsize(path) // 1024, "KB")


if __name__ == "__main__":
    main()
