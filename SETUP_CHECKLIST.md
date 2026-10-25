# BloxFront – Release-Anleitung

Stand 2026-10-26. Alles, was im Code ging, ist erledigt: Redesign, Rebranding, Lizenz-Credits, Snicks Server und Secret entfernt, Produkt-IDs auf 0, eigene Owner-ID. Übrig sind nur Sachen, die du mit deinem Roblox- bzw. GitHub-Account machen musst.

Die fertige Datei zum Veröffentlichen ist **`BloxFront_release.rbxlx`**. Sie ist ohne Dev-Werkzeuge gebaut, neu bauen kannst du sie mit:

```
~/.local/bin/rojo.exe build release.project.json -o BloxFront_release.rbxlx
```

---

## 1. Quellcode öffentlich (⚠️ Pflicht, AGPL §13)
- [ ] GitHub-Repo `bloxfront` **öffentlich** anlegen und diesen Ordner pushen, mit der kompletten git-Historie.
  - Die Historie ist bereinigt, Snicks Lobby-Secret steckt in keinem Commit mehr.
  - `.secrets/` und die `*.rbxlx`-Dateien sind in `.gitignore`.
- [ ] `src/client/UI/HelpOverlay.luau`: `HelpOverlay.SOURCE_REPO = "YOUR-GITHUB/bloxfront"` auf deinen Repo-Namen setzen und danach den Release-Build neu bauen.
- [ ] Bei jedem Update erst pushen, dann publishen.

## 2. Experience anlegen
- [ ] `BloxFront_release.rbxlx` in Studio öffnen → File → Publish to Roblox As → neue Experience „BloxFront“ (dein Account oder deine Gruppe).
- [ ] Game Settings → Security:
  - **Enable Studio Access to API Services**: an (DataStores für Sterne, Käufe, Locker)
  - **Mesh / Image APIs** (EditableImage/EditableMesh): an, sonst werden die Gebiete nicht eingefärbt
  - **Allow HTTP Requests**: aus lassen, das Spiel braucht kein HTTP mehr
- [ ] Game Settings → Basic: Genre Strategy, Geräte PC, Handy und Tablet (das UI ist für alle gebaut).
- [ ] Teleports zwischen Servern derselben Experience gehen ohne weitere Einstellung.

## 3. Robux-Produkte
- [ ] Alle Produkte anlegen. Die Liste mit Namen und Preisen steht in **[PRODUCTS.md](PRODUCTS.md)**: 13 Haupt-Produkte, 30 Flaggen und 1 Bundle.
- [ ] Die IDs eintragen in `src/shared/Data/Products.luau` (`id`) und in `src/shared/Assets/ShopFlags.luau` (`product`, `sets.halloween.product`).
- **Gamepasses brauchst du keine**, das Spiel nutzt nur Developer Products.
- Solange eine ID `0` ist, ist das Angebot versteckt bzw. nicht kaufbar. Das Spiel läuft trotzdem.

## 4. Sounds & Musik (empfohlen)
- Alle Sounds und die Musik sind Uploads von Snicks Account. In deinem Spiel bleiben sie stumm („not authorized“). Das Spiel läuft ohne Ton, aber mit ist es besser.
- [ ] Die Musik (Rodrigo Flores, CC BY 4.0) und die Effekte selbst hochladen, dann die IDs in `src/shared/Assets/Soundtrack.luau`, `Audio.luau`, `AudioExtra.luau` und `AudioUI.luau` ersetzen.
  - Das Skript `tools/assets/upload_audio.py` macht das mit deinem Open-Cloud-API-Key in `.secrets/roblox_api_key`.
  - Die Quelldateien liegen nicht im Repo, die musst du dir besorgen (Rodrigo Flores' „Orchestral Ambients“).
- Bilder (Flaggen, Icons) laden in Studio zum großen Teil. Wenn im Live-Spiel Bilder fehlen, mit `tools/assets/*` neu hochladen.

## 5. Icon, Thumbnails, Beschreibung
- [ ] Icon 512×512: z.B. `exports/ui/Branding/BloxFrontLogo.png` oder ein neues aus der Figma-Datei „BloxFront UI“.
- [ ] Logo im Spiel: Die ID in `src/shared/Assets/Branding.luau` und `UiIcons.luau` (`app_icon`) ist noch Snicks Emblem. Ersetzen, sobald dein Logo hochgeladen ist.
- [ ] Thumbnails 1920×1080: Screenshots aus einem Match. Die Figma-Screens eignen sich als Vorlage.
- [ ] Beschreibung, mit dieser Zeile am Ende:

  > BloxFront is a modified version of RoWorld (Snick Co.), itself based on OpenFront. Licensed under the GNU AGPL v3. Source code: github.com/YOUR-GITHUB/bloxfront. Maps, flags and unit art from OpenFront (CC BY-SA 4.0). Music by Rodrigo Flores (CC BY 4.0). Not affiliated with OpenFront or Snick Co.

## 6. Nie entfernen (⚠️ Lizenz)
- Footer auf dem Titelscreen „© OpenFront and Contributors …“
- How to play → „Credits & licence“ mit der ganzen Kette OpenFront → Snick Co. → du
- `LICENSE`, `README.md`, `assets/openfront/LICENSE.md`

## 7. Vor dem Live-Schalten testen
- [ ] In der veröffentlichten Experience (nicht in Studio) einmal Solo spielen, einem Public Match beitreten (dafür 2 Accounts oder einen Freund) und einen Testkauf machen.
- [ ] Prüfen, dass die Gebiete eingefärbt sind (Punkt 2, Mesh/Image APIs).

---

### Was schon erledigt und getestet ist
- Titel, Solo-Setup, Arsenal, Locker, Flaggen-Shop, Einstellungen/Menü, Hilfe, Solo-Match mit HUD und Spielende: in Studio durchgespielt, keine Skriptfehler.
- Lobbys laufen über MemoryStore, kein externer Server.
- Owner-ID: 3352325475 (Main.OWNER_USER_ID). Admin ist automatisch der Ersteller der Experience bzw. der Gruppen-Owner.
