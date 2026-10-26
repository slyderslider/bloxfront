$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
function Save-Icon([string]$src,[string]$dest) {
$im = [System.Drawing.Image]::FromFile($src)
$bm = [System.Drawing.Bitmap]::new(1024,1024,[System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
$g = [System.Drawing.Graphics]::FromImage($bm)
$g.CompositingMode = [System.Drawing.Drawing2D.CompositingMode]::SourceCopy
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
$g.DrawImage($im,[System.Drawing.Rectangle]::new(0,0,1024,1024))
$bm.Save($dest,[System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bm.Dispose()
$im.Dispose()
}
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags/pumpkin_king.png') { throw 'Destination already exists: pumpkin_king' }
Copy-Item -LiteralPath 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-ff21c598-12f5-4873-8c32-21f7e3e0dbbe.png' -Destination 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags/pumpkin_king.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags/bat_moon.png') { throw 'Destination already exists: bat_moon' }
Copy-Item -LiteralPath 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-6064cc79-392e-4555-b544-2a55d56b3553.png' -Destination 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags/bat_moon.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags/grinning_skull.png') { throw 'Destination already exists: grinning_skull' }
Copy-Item -LiteralPath 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-e3a4ce1b-0018-408d-892f-567af55a9bc3.png' -Destination 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags/grinning_skull.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags/cauldron.png') { throw 'Destination already exists: cauldron' }
Copy-Item -LiteralPath 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-f82e1b2b-ba5c-4ecb-9e99-331a5cbe77f4.png' -Destination 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags/cauldron.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags/phantom.png') { throw 'Destination already exists: phantom' }
Copy-Item -LiteralPath 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-8553b593-35f5-404e-b1d9-425b31c71c7e.png' -Destination 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags/phantom.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags/spider_web.png') { throw 'Destination already exists: spider_web' }
Copy-Item -LiteralPath 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-c4b1eba8-5994-43f2-b77f-f9667abef1f9.png' -Destination 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags/spider_web.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/takeover.png') { throw 'Destination already exists: takeover' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-c550a20f-ea14-4158-8dc0-8bdcde043d7c.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/takeover.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/crate.png') { throw 'Destination already exists: crate' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-1bc308e1-01e4-4d26-88e5-bc6a19f2cf79.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/crate.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/crate_first.png') { throw 'Destination already exists: crate_first' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-fda77fe6-7e15-4e52-ba04-60dc30799b02.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/crate_first.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/crate3.png') { throw 'Destination already exists: crate3' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-a8f15783-4888-4d14-89dd-0740a50bc011.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/crate3.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_mega.png') { throw 'Destination already exists: unlock_mega' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-2798d377-7efa-4c81-bb8c-37968de79fd0.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_mega.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_scatter.png') { throw 'Destination already exists: unlock_scatter' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-94bef49e-bccd-48e0-97bc-00b5b00e1d81.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_scatter.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_reinforce.png') { throw 'Destination already exists: unlock_reinforce' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-c778b093-9609-4ee7-b88d-24e18c0b5134.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_reinforce.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_artillery.png') { throw 'Destination already exists: unlock_artillery' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-3aca333d-ad96-4fab-a883-3c075788e421.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_artillery.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_airfield.png') { throw 'Destination already exists: unlock_airfield' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-00868809-c3bb-4a02-a61d-a5a2a857dcec.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_airfield.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_railgun.png') { throw 'Destination already exists: unlock_railgun' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-ad22885c-8c53-4e4f-a9b4-ea3071176383.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_railgun.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_stars2x.png') { throw 'Destination already exists: unlock_stars2x' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-825bd230-b31d-4e15-9876-b9f02b14f69b.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_stars2x.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_reload2x.png') { throw 'Destination already exists: unlock_reload2x' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-c10cfbb7-580c-4145-85ec-f60dcf0387b9.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/unlock_reload2x.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/starter_pack.png') { throw 'Destination already exists: starter_pack' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-af9247ad-a215-4e40-b1c9-2fe39e09ab11.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/starter_pack.png'
if (Test-Path -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/bundle_halloween.png') { throw 'Destination already exists: bundle_halloween' }
Save-Icon 'C:\Users\roman\.codex\generated_images\01a176ff-aeb4-7521-952a-f1f25b518c3e\exec-3fa3d4a8-2a32-48f4-b3e3-7550227dfa17.png' 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons/bundle_halloween.png'
Set-Content -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/IMAGEGEN_PROMPTS.md' -Value '# BloxFront Halloween flags and product icons

Mode: built-in Imagegen. Flags 1536x1024. Icons normalized to 1024x1024 with alpha preserved. crate_first uses a ribbon without lettering.

## flags/pumpkin_king.png

Create an original flag design for a mobile strategy game. Landscape 3:2 (1536×1024). Flat vector style, bold shapes, thick clean outlines, 3–5 colours, high contrast, readable when shrunk to 60×40 pixels. The design fills the whole rectangle edge to edge like a real flag (no border, no frame, no pole, no waving cloth, no shadow, no mockup). No text, no letters, no logos. Halloween theme. A grinning jack-o''-lantern wearing a golden crown, on a diagonal split of orange and deep purple. Legendary, regal feel.

## flags/bat_moon.png

Create an original flag design for a mobile strategy game. Landscape 3:2 (1536×1024). Flat vector style, bold shapes, thick clean outlines, 3–5 colours, high contrast, readable when shrunk to 60×40 pixels. The design fills the whole rectangle edge to edge like a real flag (no border, no frame, no pole, no waving cloth, no shadow, no mockup). No text, no letters, no logos. Halloween theme. A black bat silhouette flying across a big yellow full moon, night-purple sky with a few small stars.

## flags/grinning_skull.png

Create an original flag design for a mobile strategy game. Landscape 3:2 (1536×1024). Flat vector style, bold shapes, thick clean outlines, 3–5 colours, high contrast, readable when shrunk to 60×40 pixels. The design fills the whole rectangle edge to edge like a real flag (no border, no frame, no pole, no waving cloth, no shadow, no mockup). No text, no letters, no logos. Halloween theme. A cartoon white skull with a lit candle on top, glowing orange eyes, black background, purple stripe along the bottom.

## flags/cauldron.png

Create an original flag design for a mobile strategy game. Landscape 3:2 (1536×1024). Flat vector style, bold shapes, thick clean outlines, 3–5 colours, high contrast, readable when shrunk to 60×40 pixels. The design fills the whole rectangle edge to edge like a real flag (no border, no frame, no pole, no waving cloth, no shadow, no mockup). No text, no letters, no logos. Halloween theme. A black witch''s cauldron with bubbling green potion and rising bubbles, on violet with darker diagonal side panels.

## flags/phantom.png

Create an original flag design for a mobile strategy game. Landscape 3:2 (1536×1024). Flat vector style, bold shapes, thick clean outlines, 3–5 colours, high contrast, readable when shrunk to 60×40 pixels. The design fills the whole rectangle edge to edge like a real flag (no border, no frame, no pole, no waving cloth, no shadow, no mockup). No text, no letters, no logos. Halloween theme. A friendly white ghost with wavy bottom edge and little arms, on a teal-to-dark-teal misty gradient.

## flags/spider_web.png

Create an original flag design for a mobile strategy game. Landscape 3:2 (1536×1024). Flat vector style, bold shapes, thick clean outlines, 3–5 colours, high contrast, readable when shrunk to 60×40 pixels. The design fills the whole rectangle edge to edge like a real flag (no border, no frame, no pole, no waving cloth, no shadow, no mockup). No text, no letters, no logos. Halloween theme. A white spider web spreading from the top-left corner and a black spider with a red mark hanging on a thread, orange and black diagonal split.

## icons/takeover.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #b89eff to #6a3fd1. Symbol: a crown. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.

## icons/crate.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #ffb44d to #c2701c. Symbol: a treasure chest. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.

## icons/crate_first.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #ffb44d to #c2701c. Symbol: a treasure chest with a small ribbon badge, badge is a simple shape without numbers or letters. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.

## icons/crate3.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #ffb44d to #c2701c. Symbol: three treasure chests stacked as a pyramid. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.

## icons/unlock_mega.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #ff7a6b to #b8322d. Symbol: one large missile with a glowing ring around it. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.

## icons/unlock_scatter.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #ff7a6b to #b8322d. Symbol: one missile in the middle with two smaller missiles angled outwards. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.

## icons/unlock_reinforce.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #8f88ff to #4a42d6. Symbol: three soldier silhouettes side by side. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.

## icons/unlock_artillery.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #8f88ff to #4a42d6. Symbol: a wheeled field cannon. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.

## icons/unlock_airfield.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #8f88ff to #4a42d6. Symbol: a fighter jet seen from above. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.

## icons/unlock_railgun.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #8f88ff to #4a42d6. Symbol: a futuristic rail cannon with a yellow energy spark. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.

## icons/unlock_stars2x.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #5fd4c4 to #1d8a7c. Symbol: a big star with a small doubled star behind it. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet. STRICT SYMBOL COUNT: exactly TWO stars total. One large white five-point star centered slightly lower left; ONE smaller white five-point star partially visible behind its upper right edge. There must be no third star, no symmetric pair of background stars.

## icons/unlock_reload2x.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #5fd4c4 to #1d8a7c. Symbol: a circular reload arrow with a lightning bolt in the middle. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.

## icons/starter_pack.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #b89eff to #6a3fd1. Symbol: a gift box with a bow. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.

## icons/bundle_halloween.png

Create an original square icon (1024×1024) for an in-game purchase in a Roblox strategy game. Bold flat vector style, one big centered white symbol with a subtle dark drop shadow, on a rounded-square tile with a vertical gradient background, soft inner glow. Simple, readable at 150×150 pixels. No text, no letters, no numbers, no Robux symbol, no logos. Background gradient top to bottom: #b89eff to #6a3fd1. Symbol: a fan of three small flags with a pumpkin on the front one. Consistent icon-set art direction: tile fills entire square with small rounded corners, radius 9% of canvas; outside tiny rounded corner cutouts transparent. White symbol occupies about 65% width and height with 16% safe margins. Clean solid geometric silhouette with necessary negative-space cutouts; no fine details, no black outlines, no 3D render, no extra decorative objects. Only railgun spark may use yellow; otherwise symbol pure white. Subtle dark shadow displaced downward 1.5% of canvas. One single finished icon, not a sheet.' -Encoding utf8
$manifest = Get-Content -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/assets.json' -Raw | ConvertFrom-Json
$manifest.assets += [pscustomobject]@{name='Incoming_flags_pumpkin_king';type='flag-image';file='incoming/flags/pumpkin_king.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1536x1024. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_flags_bat_moon';type='flag-image';file='incoming/flags/bat_moon.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1536x1024. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_flags_grinning_skull';type='flag-image';file='incoming/flags/grinning_skull.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1536x1024. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_flags_cauldron';type='flag-image';file='incoming/flags/cauldron.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1536x1024. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_flags_phantom';type='flag-image';file='incoming/flags/phantom.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1536x1024. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_flags_spider_web';type='flag-image';file='incoming/flags/spider_web.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1536x1024. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_takeover';type='product-icon';file='incoming/icons/takeover.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_crate';type='product-icon';file='incoming/icons/crate.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_crate_first';type='product-icon';file='incoming/icons/crate_first.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_crate3';type='product-icon';file='incoming/icons/crate3.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_unlock_mega';type='product-icon';file='incoming/icons/unlock_mega.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_unlock_scatter';type='product-icon';file='incoming/icons/unlock_scatter.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_unlock_reinforce';type='product-icon';file='incoming/icons/unlock_reinforce.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_unlock_artillery';type='product-icon';file='incoming/icons/unlock_artillery.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_unlock_airfield';type='product-icon';file='incoming/icons/unlock_airfield.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_unlock_railgun';type='product-icon';file='incoming/icons/unlock_railgun.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_unlock_stars2x';type='product-icon';file='incoming/icons/unlock_stars2x.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_unlock_reload2x';type='product-icon';file='incoming/icons/unlock_reload2x.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_starter_pack';type='product-icon';file='incoming/icons/starter_pack.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest.assets += [pscustomobject]@{name='Incoming_icons_bundle_halloween';type='product-icon';file='incoming/icons/bundle_halloween.png';status='exported';assetId=$null;studioPath=$null;notes='Built-in Imagegen, 2026-10-26. 1024x1024, transparent rounded corners. Ready for user atlas/upload workflow; existing product IDs unchanged.'}
$manifest | ConvertTo-Json -Depth 100 | Set-Content -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/assets.json' -Encoding utf8
$old = Get-Content -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/IMPORT_CHECKLIST.md' -Raw
$lines = @($manifest.assets | Where-Object status -eq 'exported' | ForEach-Object { '- [ ] ' + $_.name + ' — ' + $_.file })
$new = "# BloxFront Bild-Batch 26.10.2026

Fertig: 6 Halloween-Flaggen (1536x1024), 14 Produkt-Icons (1024x1024).

- [ ] Atlas aus incoming/flags und incoming/icons bauen.
- [ ] Atlanten/Bilder hochladen.
- [ ] Produkt-Icons ersetzen und neue Asset-IDs zuordnen.

Diese Schritte uebernimmt Roman bzw. sein nachgelagerter Workflow. Bisher keine Uploads oder Spielaenderungen. crate_first: Bandabzeichen ohne Zahl.

## Alle exportierten Assets

" + ($lines -join "
") + "

---
Bisherige Checkliste:

" + $old
Set-Content -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/IMPORT_CHECKLIST.md' -Value $new -Encoding utf8
Get-ChildItem -LiteralPath 'C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/flags','C:/Users/roman/Desktop/Claude Code/bloxfront/incoming/icons' -Filter '*.png' | ForEach-Object { $im=[System.Drawing.Image]::FromFile($_.FullName); [pscustomobject]@{Name=$_.Name;Width=$im.Width;Height=$im.Height;Bytes=$_.Length};$im.Dispose() } | Format-Table -AutoSize
