# BloxFront – Checkliste vor dem Veröffentlichen

Erst wenn alles abgehakt ist, publishen. Die Punkte mit ⚠️ sind Pflicht wegen Lizenz bzw. damit nichts kaputt ist.

## 1. Quellcode öffentlich (⚠️ AGPL §13)
- [ ] GitHub-Account/Repo `bloxfront` öffentlich anlegen, diesen Ordner pushen (inkl. LICENSE, README, git-Historie)
- [ ] `src/client/UI/HelpOverlay.luau` → `HelpOverlay.SOURCE_REPO = "YOUR-GITHUB/bloxfront"` auf deinen echten Repo-Namen setzen
- [ ] Bei jedem Update: erst pushen, dann publishen (der Code im Repo = der Code im Spiel)

## 2. Eigenes Branding (⚠️ keine Verwechslung mit RoWorld)
- [ ] Neues Logo machen (512×512) → hochladen → ID in `src/shared/Assets/Branding.luau` und `UiIcons.luau` (`app_icon`) eintragen. Aktuell steht da noch Snicks Logo-ID!
- [ ] Neues Experience-Icon + Thumbnails (nicht `assets/branding/*` von RoWorld)
- [ ] Spielbeschreibung auf Roblox: eigene Worte + Zeile „Based on RoWorld/OpenFront, AGPL-3.0, source: github.com/…"

## 3. Assets selbst hochladen
- Die ~349 `rbxassetid://` in `src/shared/Assets/*.luau` sind Uploads von Snicks Account.
- [ ] Audio (Soundtrack, Sounds) **muss** neu hoch, fremdes Audio spielt in deinem Spiel meist nicht
- [ ] Bilder (Flaggen, Icons, Map-Sprites) besser auch neu hoch, Quelldateien liegen in `assets/`
- Die Upload-Skripte liegen in `tools/assets/` (brauchen einen eigenen Open-Cloud-API-Key, den trägst du selbst ein)

## 4. Robux-Produkte
- [ ] Alle Produkt-IDs stehen jetzt auf `0` (Angebote sind versteckt). Eigene Developer Products im Creator Dashboard anlegen und IDs in `src/shared/Data/Products.luau` + `src/shared/Assets/ShopFlags.luau` eintragen
- [ ] Staging optional: `src/shared/Data/Staging.luau`, `tools/publish.staging.json`

## 5. Credits bleiben drin (⚠️ AGPL §7b, CC BY-SA)
- Titelbildschirm-Footer „© OpenFront and Contributors …“ und „How to play › Credits & Licence“ niemals löschen oder verstecken.

## 6. Testen in Studio
- [ ] Mit Rojo `default.project.json` syncen, Playtest: Titel, Solo-Start, HUD, Arsenal, Locker, How to play
- [ ] Game Settings › Security › „Mesh / Image APIs“ an (sonst keine Gebietsfarben)
