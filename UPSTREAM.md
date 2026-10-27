# Upstream-Sync (RoWorld → BloxFront)

Upstream: https://github.com/lukechatton/roworld (Remote `upstream`).

**Zuletzt übernommen:** `2053193` (26.10.2026)

## Ablauf (wenn Roman fragt „ist bei ihm was neu?“)
1. `git fetch upstream` und `git log --oneline <zuletzt>..upstream/main`. Wenn nichts neu ist, ist hier Schluss.
2. Branch `upstream-sync` anlegen, dann `git diff --binary <zuletzt> upstream/main | git apply --3way` und Konflikte lösen.
3. **Nie übernehmen:**
   - Snicks Lobby-Server/Secret (`LobbyHttp` bleibt aus)
   - Asset-IDs und Produkt-IDs von Snick
   - Gruppe 421623341
   - Text „RoWorld“ im sichtbaren UI
4. Geänderte Grafik-Manifeste (`src/shared/Assets/*.luau`) neu rendern und in Gruppe 818671112 hochladen. Runner: `tools/assets/*` mit Upload-Shim (Open Cloud, Key in `.secrets`).
5. Neue Produkte mit `tools/assets/create_products.py --universe 10773073437` anlegen.
6. Ins Studio syncen, testen, committen, mergen und pushen. Die Zeile „Zuletzt übernommen“ hier aktualisieren.
