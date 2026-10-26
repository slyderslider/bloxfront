# Import-Checkliste BloxFront

## 1. Sounds (69 Stück) → Creator Hub oder Studio: View → Asset Manager → Bulk Import (Audio)
- [ ] Alle Dateien aus `exports/audio/sfx/*.wav` hochladen (ohne `index.json`)
- [ ] Danach sagst du mir „Sounds hochgeladen“. Ich lese die IDs im Studio-Fenster aus und trage sie in `Audio.luau`, `AudioExtra.luau` und `AudioUI.luau` ein. Welche Datei zu welchem Sound gehört, steht in `exports/audio/sfx/index.json`.
- Dateinamen: `sfx_*` = Audio.luau, `x_*` = AudioExtra.luau, `ui_*` = AudioUI.luau

## 2. Musik
- [ ] Deine Musik raussuchen und hochladen. Die IDs kommen in `src/shared/Assets/Soundtrack.luau` bzw. `Audio.luau` (`music.menu`, `music.war`). Gib mir die IDs, dann trage ich sie ein.
- Wenn du andere Musik als die von Rodrigo Flores nimmst, passe ich auch die Credit-Zeile an.

## 3. Store-Bilder → Creator Dashboard (nicht Studio)
- [ ] Icon: `exports/ui/Store/BloxFrontIcon.png` → Experience → Places → Icon
- [ ] Thumbnails: `exports/ui/Store/Thumbnail1_Strike.png` und `Thumbnail2_Takeover.png` → Experience → Places → Thumbnails

## 4. Logo im Spiel (optional)
- [ ] `exports/ui/Store/BloxFrontIcon.png` zusätzlich über den Asset Manager hochladen → Asset-ID an mich. Damit ersetze ich Snicks Emblem auf dem Titelscreen.
