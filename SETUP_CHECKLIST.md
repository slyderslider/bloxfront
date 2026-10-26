# BloxFront – Release-Stand (2026-10-26)

## Erledigt (im Code und im Studio-Place „Bloxfront“, placeId 84941307016043)
- Redesign (Slate/Indigo), Rebranding, Lizenz-Credits, Snicks Lobby-Server und Secret entfernt
- 69 eigene Soundeffekte hochgeladen (Gruppe 818671112) und eingetragen
- 44 Developer Products mit Icons und Preisen angelegt und eingetragen (keine Gamepasses nötig)
- Alle gesperrten Bilder neu für die Gruppe hochgeladen: Logo, Karten-Effekte, Länderflaggen, Flaggen-Shop, Kisten-Effekte, Skin- und Arsenal-Vorschau. Im Test laden alle Bilder des Spiels.
- Dev-Ordner und `AF_DIAG` aus dem Place entfernt; der Place entspricht `BloxFront_release.rbxlx`
- Store-Icon und Thumbnails: `exports/ui/Store/`

## Nur du kannst das
1. **Game Settings → Security**, sonst ist die Karte ein Schachbrett und es wird nichts gespeichert:
   - „Allow Mesh / Image APIs“ → an (die Karte wird mit EditableImage gezeichnet)
   - „Enable Studio Access to API Services“ → an (Speichern von Sternen, Käufen und Einstellungen in Studio; live speichert es immer)
2. **Musik**: schicken oder hochladen. Die Menü- und Match-Musik sind noch Snicks IDs (`Soundtrack.luau`, `Audio.luau` music) und bleiben stumm.
3. **Veröffentlichen**: in Studio File → Publish to Roblox (Alt+P).
4. **Creator Dashboard**: Icon und Thumbnails setzen, die Beschreibung mit der Credit-Zeile (siehe unten), Genre, Geräte.
5. ✅ Öffentliches GitHub-Repo: https://github.com/slyderslider/bloxfront (bei jedem Update: erst pushen, dann publishen). `.secrets/` ist ignoriert.

Beschreibung, letzte Zeile:
> BloxFront is a modified version of RoWorld (Snick Co.), itself based on OpenFront. Licensed under the GNU AGPL v3. Source code: github.com/slyderslider/bloxfront. Maps, flags and unit art from OpenFront (CC BY-SA 4.0). Music by Rodrigo Flores (CC BY 4.0). Not affiliated with OpenFront or Snick Co.

## Nie entfernen (Lizenz)
Footer „© OpenFront and Contributors …“, How to play → Credits & licence, `LICENSE`, `README.md`, `assets/openfront/LICENSE.md`.
