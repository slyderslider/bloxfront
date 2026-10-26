# BloxFront Bild-Batch 26.10.2026

Fertig: 6 Halloween-Flaggen (1536x1024), 14 Produkt-Icons (1024x1024).

- [ ] Atlas aus incoming/flags und incoming/icons bauen.
- [ ] Atlanten/Bilder hochladen.
- [ ] Produkt-Icons ersetzen und neue Asset-IDs zuordnen.

Diese Schritte uebernimmt Roman bzw. sein nachgelagerter Workflow. Bisher keine Uploads oder Spielaenderungen. crate_first: Bandabzeichen ohne Zahl.

## Alle exportierten Assets

- [ ] BloxFrontLogo — exports/ui/Branding/BloxFrontLogo.png
- [ ] Thumbnail1_Strike — exports/ui/Store/Thumbnail1_Strike.png
- [ ] Thumbnail2_Takeover — exports/ui/Store/Thumbnail2_Takeover.png
- [ ] SfxPack — exports/audio/sfx/*.wav
- [ ] Incoming_flags_pumpkin_king — incoming/flags/pumpkin_king.png
- [ ] Incoming_flags_bat_moon — incoming/flags/bat_moon.png
- [ ] Incoming_flags_grinning_skull — incoming/flags/grinning_skull.png
- [ ] Incoming_flags_cauldron — incoming/flags/cauldron.png
- [ ] Incoming_flags_phantom — incoming/flags/phantom.png
- [ ] Incoming_flags_spider_web — incoming/flags/spider_web.png
- [ ] Incoming_icons_takeover — incoming/icons/takeover.png
- [ ] Incoming_icons_crate — incoming/icons/crate.png
- [ ] Incoming_icons_crate_first — incoming/icons/crate_first.png
- [ ] Incoming_icons_crate3 — incoming/icons/crate3.png
- [ ] Incoming_icons_unlock_mega — incoming/icons/unlock_mega.png
- [ ] Incoming_icons_unlock_scatter — incoming/icons/unlock_scatter.png
- [ ] Incoming_icons_unlock_reinforce — incoming/icons/unlock_reinforce.png
- [ ] Incoming_icons_unlock_artillery — incoming/icons/unlock_artillery.png
- [ ] Incoming_icons_unlock_airfield — incoming/icons/unlock_airfield.png
- [ ] Incoming_icons_unlock_railgun — incoming/icons/unlock_railgun.png
- [ ] Incoming_icons_unlock_stars2x — incoming/icons/unlock_stars2x.png
- [ ] Incoming_icons_unlock_reload2x — incoming/icons/unlock_reload2x.png
- [ ] Incoming_icons_starter_pack — incoming/icons/starter_pack.png
- [ ] Incoming_icons_bundle_halloween — incoming/icons/bundle_halloween.png

---
Bisherige Checkliste:

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

