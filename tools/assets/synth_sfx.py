"""BloxFront: synthesises every sound effect from scratch (no samples), so the game ships its own audio.

Writes 16-bit mono WAVs to exports/audio/sfx/<manifest>_<key>.wav and exports/audio/sfx/index.json
(file -> manifest + key + length), one per entry of src/shared/Assets/Audio*.luau. Lengths follow
the manifests so playback timing in the game stays the same.

    python tools/assets/synth_sfx.py
"""
import json
import os
import re
import wave

import numpy as np

SR = 44100
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
OUT = os.path.join(ROOT, "exports", "audio", "sfx")
RNG = np.random.default_rng(7)

# --- building blocks --------------------------------------------------------------------------


def t_of(dur):
    return np.arange(int(SR * dur)) / SR


def env(n, a=0.005, d=None, curve=4.0):
    """Attack then exponential decay over n samples."""
    x = np.ones(n)
    na = max(1, int(SR * a))
    x[:na] = np.linspace(0, 1, na)
    rest = n - na
    if rest > 0:
        x[na:] = np.exp(-curve * np.linspace(0, 1, rest)) if d is None else np.exp(-np.arange(rest) / (SR * d))
    return x


def tone(freq, dur, kind="sine", vib=0.0):
    t = t_of(dur)
    f = np.full_like(t, freq) if np.isscalar(freq) else freq
    if vib:
        f = f * (1 + vib * np.sin(2 * np.pi * 5.5 * t))
    ph = 2 * np.pi * np.cumsum(f) / SR
    if kind == "sine":
        return np.sin(ph)
    if kind == "tri":
        return 2 / np.pi * np.arcsin(np.sin(ph))
    if kind == "square":
        return np.sign(np.sin(ph)) * 0.6
    if kind == "saw":
        return 2 * ((ph / (2 * np.pi)) % 1) - 1
    raise ValueError(kind)


def sweep(f0, f1, dur, kind="sine", exp=True):
    t = t_of(dur)
    k = t / max(dur, 1e-6)
    f = f0 * (f1 / f0) ** k if exp else f0 + (f1 - f0) * k
    return tone(f, dur, kind)


def noise(dur):
    return RNG.uniform(-1, 1, int(SR * dur))


def lowpass(x, cutoff):
    """One-pole low-pass; cutoff may be a scalar or a per-sample array."""
    c = np.broadcast_to(np.asarray(cutoff, dtype=float), x.shape)
    a = np.exp(-2 * np.pi * c / SR)
    y = np.empty_like(x)
    prev = 0.0
    for i in range(len(x)):
        prev = (1 - a[i]) * x[i] + a[i] * prev
        y[i] = prev
    return y


def highpass(x, cutoff):
    return x - lowpass(x, cutoff)


def fit(x, dur):
    n = int(SR * dur)
    if len(x) >= n:
        return x[:n]
    return np.concatenate([x, np.zeros(n - len(x))])


def mix(dur, *parts):
    """parts: (signal, start_seconds, gain)."""
    out = np.zeros(int(SR * dur))
    for sig, start, gain in parts:
        s = int(SR * start)
        if s >= len(out):
            continue
        e = min(len(out), s + len(sig))
        out[s:e] += sig[: e - s] * gain
    return out


def note(freq, dur, kind="tri", a=0.005, decay=4.0):
    x = tone(freq, dur, kind)
    return x * env(len(x), a, curve=decay)


def chord(freqs, dur, kind="tri", a=0.01, decay=3.0):
    return sum(note(f, dur, kind, a, decay) for f in freqs) / len(freqs)


def arp(freqs, step, dur_each, kind="tri", decay=5.0):
    total = step * (len(freqs) - 1) + dur_each
    return mix(total, *[(note(f, dur_each, kind, decay=decay), i * step, 1.0) for i, f in enumerate(freqs)])


def boom(dur, start_cut=1800, end_cut=60, body=48):
    n = noise(dur)
    cut = np.geomspace(start_cut, end_cut, len(n))
    x = lowpass(n, cut) * env(len(n), 0.004, curve=3.2)
    sub = sweep(body * 1.6, body * 0.6, dur) * env(len(n), 0.002, curve=5)
    return x * 1.4 + sub * 0.8


def whoosh(dur, f0=300, f1=3000, rise=True):
    n = noise(dur)
    cut = np.geomspace(f0, f1, len(n)) if rise else np.geomspace(f1, f0, len(n))
    shape = np.sin(np.pi * np.linspace(0, 1, len(n))) ** 1.5
    return lowpass(n, cut) * shape


def finish(x, peak=0.89, fade=0.012):
    x = np.asarray(x, dtype=float)
    nf = min(len(x) // 4, int(SR * fade))
    if nf > 0:
        x[-nf:] *= np.linspace(1, 0, nf)
        x[:8] *= np.linspace(0, 1, 8)
    m = np.max(np.abs(x)) or 1.0
    return x / m * peak


def hz(n):
    """MIDI note number -> Hz."""
    return 440.0 * 2 ** ((n - 69) / 12)


C4, D4, E4, F4, G4, A4, B4, C5, D5, E5, G5, A5, C6 = (hz(n) for n in (60, 62, 64, 65, 67, 69, 71, 72, 74, 76, 79, 81, 84))

# --- recipes (key -> function(length) -> signal) ----------------------------------------------


def ui_click(L):
    return mix(L, (note(1650, 0.05, "sine", 0.001, 9), 0, 1), (note(820, 0.04, "tri", 0.001, 10), 0.004, 0.5))


def ui_hover(L):
    return note(2300, min(L, 0.06), "sine", 0.002, 8) * 0.5


def ui_open(L):
    return mix(L, (sweep(500, 1400, min(L, 0.18), "tri") * env(int(SR * min(L, 0.18)), 0.004, curve=3), 0, 0.8),
               (whoosh(min(L, 0.5), 800, 5000) * 0.35, 0, 1))


def ui_back(L):
    return sweep(1300, 600, L, "tri") * env(int(SR * L), 0.003, curve=5)


def ui_tab(L):
    return note(1200, L, "square", 0.001, 9) * 0.6


def ui_locked(L):
    return mix(L, (note(220, L, "square", 0.001, 6), 0, 0.6), (note(233, L, "square", 0.001, 6), 0, 0.5))


def ui_error(L):
    return mix(L, (note(330, L / 2, "square", 0.002, 4), 0, 0.7), (note(247, L / 2, "square", 0.002, 4), L / 2, 0.7))


def ui_confirm(L):
    return arp([C5, E5, G5], 0.07, max(0.2, L - 0.14), "tri", 4)


def countdown_tick(L):
    return note(1900, L, "sine", 0.001, 12)


def countdown_n(pitch):
    def f(L):
        return mix(L, (note(pitch, 0.5, "tri", 0.003, 5), 0, 1), (note(pitch * 2, 0.4, "sine", 0.003, 6), 0, 0.3))
    return f


def countdown_gamestart(L):
    return mix(L, (chord([C4, E4, G4, C5], L, "saw", 0.01, 2.2) * 0.6, 0, 1), (boom(1.2, 900, 50, 55), 0, 0.6))


def game_start(L):
    a = arp([G4, C5, E5, G5], 0.16, 1.0, "tri", 3)
    return mix(L, (a, 0, 0.9), (chord([C5, E5, G5, C6], L - 0.7, "saw", 0.05, 2.0) * 0.5, 0.7, 1),
               (boom(1.6, 700, 40, 50), 0.65, 0.5))


def queue_start(L):
    return arp([E4, A4, E5], 0.12, L - 0.24, "tri", 4)


def spawn_confirm(L):
    if L < 0.3:
        return note(990, L, "sine", 0.001, 6)
    return mix(L, (arp([C5, G5, C6], 0.09, 0.8, "sine", 4), 0, 1), (whoosh(L, 400, 2500) * 0.25, 0, 1))


def spectate_switch(L):
    return sweep(700, 1600, L, "sine") * env(int(SR * L), 0.002, curve=4)


def order_ack(L):
    return mix(L, (note(880, L, "sine", 0.001, 7), 0, 1), (note(1320, L, "sine", 0.001, 9), 0.03, 0.5))


def expand(L):
    return mix(L, (whoosh(L, 200, 1800) * 0.7, 0, 1), (note(520, L, "tri", 0.005, 6) * 0.4, 0, 1))


def expand_pop(L):
    return sweep(900, 1800, L, "sine") * env(int(SR * L), 0.001, curve=7)


def attack_launch(L):
    drums = sum((boom(0.35, 500, 60, 70), ) * 1)
    return mix(L, (drums, 0, 0.8), (drums, 0.22, 0.6), (whoosh(L - 0.3, 300, 2600) * 0.8, 0.3, 1),
               (chord([D4, A4, D5], 0.9, "saw", 0.02, 3) * 0.4, 0.2, 1))


def boat_launch(L):
    water = lowpass(noise(L), 900) * np.sin(np.pi * np.linspace(0, 1, int(SR * L)))
    horn = note(110, 1.2, "saw", 0.08, 2) * 0.6
    return mix(L, (water, 0, 0.7), (lowpass(horn, 700), 0.2, 1))


def warship(L):
    horn = lowpass(note(82, L * 0.7, "saw", 0.12, 1.6), 500)
    water = lowpass(noise(L), 700) * np.sin(np.pi * np.linspace(0, 1, int(SR * L)))
    return mix(L, (horn, 0, 1), (horn, 0.02, 0.4), (water, 0, 0.5))


def build(L):
    knock = lambda: highpass(note(180, 0.12, "square", 0.001, 14), 120)
    return mix(L, (knock(), 0, 1), (knock(), 0.22, 0.9), (knock(), 0.44, 0.9), (note(C5, 0.9, "tri", 0.005, 4), 0.75, 0.6),
               (note(G5, 0.8, "tri", 0.005, 4), 0.85, 0.4))


def shell_fire(L):
    return boom(L, 2400, 200, 90)


def shell_hit(L):
    return mix(L, (boom(L, 1600, 90, 60), 0, 1), (highpass(noise(0.08), 2000) * env(int(SR * 0.08), 0.001, curve=8), 0, 0.5))


def shell_splash(L):
    n = noise(L)
    return lowpass(highpass(n, 400), np.geomspace(5000, 600, len(n))) * env(len(n), 0.002, curve=4)


def ship_sink(L):
    bubbles = mix(L, *[(note(RNG.uniform(250, 700), 0.08, "sine", 0.001, 8), RNG.uniform(0, L - 0.1), 0.4) for _ in range(24)])
    groan = lowpass(sweep(160, 60, L, "saw"), 400) * env(int(SR * L), 0.05, curve=1.5)
    return mix(L, (boom(1.2, 800, 40, 45), 0, 0.8), (groan, 0.1, 0.6), (bubbles, 0.3, 1))


def nuke_launch(L):
    rumble = lowpass(noise(L), np.geomspace(200, 2500, int(SR * L))) * np.minimum(1, np.linspace(0, 3, int(SR * L)))
    return mix(L, (rumble, 0, 1), (sweep(60, 240, L, "saw") * 0.3, 0, 1))


def nuke_alarm(L):
    t = t_of(L)
    f = 700 + 250 * np.sin(2 * np.pi * 1.4 * t)
    return lowpass(tone(f, L, "square"), 3000) * 0.8


def nuke_explosion(L):
    return mix(L, (boom(L, 3500, 30, 38), 0, 1), (whoosh(L * 0.6, 3000, 200, rise=False), 0.05, 0.5))


def sam_launch(L):
    return mix(L, (whoosh(L, 600, 6000), 0, 1), (boom(0.25, 1500, 100, 80), 0, 0.6))


def sam_intercept(L):
    return mix(L, (boom(L, 4000, 120, 70), 0, 1), (note(1800, 0.3, "sine", 0.001, 6), 0, 0.3))


def under_attack(L):
    return mix(L, (note(A4, 0.25, "square", 0.002, 3), 0, 0.6), (note(A4, 0.25, "square", 0.002, 3), 0.32, 0.6),
               (note(F4, 0.5, "square", 0.002, 3), 0.64, 0.7))


def ally_request(L):
    return arp([E5, G5], 0.12, L - 0.12, "sine", 4)


def alliance(L):
    return mix(L, (arp([C5, E5, G5, C6], 0.12, 1.4, "tri", 3), 0, 1), (chord([C4, G4, C5], L - 0.5, "sine", 0.1, 2), 0.45, 0.6))


def betrayal(L):
    return mix(L, (chord([C4, hz(63), hz(66)], L, "saw", 0.02, 2) * 0.6, 0, 1), (sweep(400, 90, L, "saw") * 0.3, 0, 1))


def conquer(L):
    return mix(L, (boom(0.8, 900, 50, 55), 0, 0.7), (arp([G4, C5, E5], 0.1, 1.4, "saw", 3) * 0.6, 0.1, 1),
               (chord([C5, E5, G5], L - 0.6, "tri", 0.02, 2.5), 0.4, 0.8))


def eliminate(L):
    return mix(L, (boom(L, 1200, 60, 50), 0, 0.8), (sweep(600, 150, L, "saw") * env(int(SR * L), 0.002, curve=3) * 0.4, 0, 1))


def victory(L):
    prog = [([C4, E4, G4], 0), ([F4, A4, C5], 1.4), ([G4, B4, D5], 2.8), ([C5, E5, G5, C6], 4.2)]
    parts = [(chord(c, 2.0 if i < 3 else L - 4.2, "saw", 0.04, 2.2) * 0.5, s, 1) for i, (c, s) in enumerate(prog)]
    parts += [(arp([C5, E5, G5, C6, E5, G5, C6], 0.11, 0.5, "tri", 4), 4.2, 0.6), (boom(2.0, 800, 40, 45), 4.2, 0.6)]
    return mix(L, *parts)


def defeat(L):
    prog = [([A4, C5, E5], 0), ([F4, A4, C5], 1.8), ([D4, F4, A4], 3.6), ([A4 / 2, E4, A4], 5.4)]
    return mix(L, *[(chord(c, 2.4, "tri", 0.1, 1.8) * 0.6, s, 1) for c, s in prog])


def buy_spend(L):
    coins = mix(L, *[(note(f, 0.25, "sine", 0.001, 6), i * 0.07, 0.6) for i, f in enumerate([E5 * 2, G5 * 2, C6 * 2, E5 * 2])])
    return mix(L, (coins, 0, 1), (note(C6, 0.9, "tri", 0.005, 3), 0.35, 0.5))


def star_tick(L):
    return note(2600, L, "sine", 0.001, 10)


def star_get(L):
    return mix(L, (arp([C6, E5 * 2, G5 * 2], 0.08, 1.0, "sine", 3), 0, 1), (highpass(noise(L), 6000) * env(int(SR * L), 0.01, curve=3) * 0.3, 0, 1))


def unlock(L):
    return mix(L, (whoosh(1.2, 300, 6000) * 0.6, 0, 1), (arp([C5, E5, G5, C6], 0.14, 1.6, "tri", 2.5), 0.6, 1),
               (chord([C5, G5, C6], L - 1.4, "saw", 0.05, 1.8) * 0.4, 1.3, 1))


def card_flip(L):
    return highpass(noise(L), 1500) * env(int(SR * L), 0.001, curve=9)


def card_whoosh(L):
    return whoosh(L, 500, 5000)


def crate_drop(L):
    return mix(L, (whoosh(L - 0.4, 2000, 300, rise=False), 0, 0.8), (boom(0.4, 900, 60, 70), L - 0.4, 1))


def crate_land(L):
    return mix(L, (boom(L, 700, 60, 65), 0, 1), (highpass(note(140, 0.2, "square", 0.001, 10), 100), 0, 0.6))


def crate_rattle(L):
    return mix(L, *[(highpass(note(RNG.uniform(160, 260), 0.06, "square", 0.001, 12), 120), i * 0.085, 0.8) for i in range(8)])


def crate_open(L):
    return mix(L, (highpass(note(120, 0.3, "saw", 0.001, 6), 80), 0, 0.7), (whoosh(L - 0.2, 400, 7000), 0.1, 0.8),
               (chord([C5, G5, C6], L - 0.4, "sine", 0.02, 3), 0.35, 0.6))


def crate_shimmer(L):
    notes = [C6, G5 * 2, E5 * 2, C6 * 2]
    parts = [(note(notes[i % 4], 0.6, "sine", 0.002, 5), i * 0.18, 0.35) for i in range(int((L - 0.6) / 0.18))]
    return mix(L, *parts)


RARITY = {"common": [C5, E5, G5], "rare": [D5, hz(78), A5], "epic": [E5, hz(80), B4 * 2], "legendary": [G5, B4 * 2, D5 * 2, G5 * 2]}


def crate_preview(rarity):
    def f(L):
        c = RARITY[rarity]
        return mix(L, (whoosh(0.8, 300, 4000) * 0.5, 0, 1), (chord(c, L - 0.4, "tri", 0.05, 2.5), 0.3, 1))
    return f


def reveal(rarity):
    def f(L):
        c = RARITY[rarity]
        parts = [(arp(c, 0.09, 1.0, "tri", 3), 0, 1), (chord(c, L - 0.4, "saw" if rarity == "legendary" else "sine", 0.03, 2), 0.3, 0.7)]
        if rarity in ("epic", "legendary"):
            parts.append((boom(1.0, 900, 40, 50), 0, 0.5))
        return mix(L, *parts)
    return f


RECIPES = {
    "ui_click": ui_click, "ui_hover": ui_hover, "ui_open": ui_open, "ui_back": ui_back, "ui_tab": ui_tab,
    "ui_locked": ui_locked, "ui_error": ui_error, "ui_confirm": ui_confirm,
    "countdown_tick": countdown_tick, "countdown_gamestart": countdown_gamestart,
    "countdown_tick_1": countdown_n(C5), "countdown_tick_2": countdown_n(B4), "countdown_tick_3": countdown_n(A4),
    "countdown_tick_4": countdown_n(G4), "countdown_tick_5": countdown_n(F4),
    "game_start": game_start, "queue_start": queue_start, "spawn_confirm": spawn_confirm, "spectate_switch": spectate_switch,
    "order_ack": order_ack, "expand": expand, "expand_pop": expand_pop, "attack_launch": attack_launch,
    "boat_launch": boat_launch, "warship": warship, "build": build, "shell_fire": shell_fire, "shell_hit": shell_hit,
    "shell_splash": shell_splash, "ship_sink": ship_sink, "nuke_launch": nuke_launch, "nuke_alarm": nuke_alarm,
    "nuke_explosion": nuke_explosion, "sam_launch": sam_launch, "sam_intercept": sam_intercept,
    "under_attack": under_attack, "ally_request": ally_request, "alliance": alliance, "betrayal": betrayal,
    "conquer": conquer, "eliminate": eliminate, "victory": victory, "defeat": defeat, "buy_spend": buy_spend,
    "star_tick": star_tick, "star_get": star_get, "unlock": unlock, "card_flip": card_flip, "card_whoosh": card_whoosh,
    "crate_drop": crate_drop, "crate_land": crate_land, "crate_rattle": crate_rattle, "crate_open": crate_open,
    "crate_shimmer": crate_shimmer,
    **{f"crate_preview_{r}": crate_preview(r) for r in RARITY},
    **{f"reveal_{r}": reveal(r) for r in RARITY},
}

MANIFESTS = {"sfx": "Audio.luau", "x": "AudioExtra.luau", "ui": "AudioUI.luau"}


def read_manifest(name):
    path = os.path.join(ROOT, "src", "shared", "Assets", name)
    text = open(path, encoding="utf-8").read()
    sfx = text[text.index("sfx = {"):]
    return re.findall(r"^\s*(\w+)\s*=\s*\{\s*id = \"[^\"]*\", length = ([\d.]+)", sfx, re.M)


def write_wav(path, x):
    pcm = (np.clip(x, -1, 1) * 32767).astype("<i2")
    with wave.open(path, "wb") as w:
        w.setnchannels(1)
        w.setsampwidth(2)
        w.setframerate(SR)
        w.writeframes(pcm.tobytes())


def main():
    os.makedirs(OUT, exist_ok=True)
    index, missing = {}, []
    for prefix, manifest in MANIFESTS.items():
        for key, length in read_manifest(manifest):
            L = float(length)
            fn = RECIPES.get(key)
            if fn is None:
                missing.append(f"{manifest}:{key}")
                continue
            x = finish(fit(fn(L), L), peak=0.6 if key.startswith("ui_") or "tick" in key else 0.89)
            name = f"{prefix}_{key}.wav"
            write_wav(os.path.join(OUT, name), x)
            index[name] = {"manifest": manifest, "key": key, "length": L}
    json.dump(index, open(os.path.join(OUT, "index.json"), "w", encoding="utf-8"), indent=1)
    print(f"{len(index)} sounds written to {OUT}")
    if missing:
        print("no recipe:", ", ".join(missing))


if __name__ == "__main__":
    main()
