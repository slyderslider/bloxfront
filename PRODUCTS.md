# Robux-Produkte für BloxFront

Alle IDs stehen auf `0`: Das Angebot ist versteckt bzw. der Kauf geht nicht, bis du die ID einträgst.
Anlegen: Creator Dashboard → dein Spiel → Monetization → Developer Products → Create.
Preis und Name kannst du frei ändern. Wenn du den Preis änderst, trag ihn auch als `robux` ein.

## 1. Haupt-Produkte → `src/shared/Data/Products.luau` (Feld `id`)

| Key | Vorschlag Name | Robux |
|---|---|---|
| `takeover` | Take over the nation that beat you | 25 |
| `crate` | Cosmetic crate | 49 |
| `crate_first` | First cosmetic crate (discount) | 15 |
| `crate3` | 3 cosmetic crates | 100 |
| `unlock_mega` | Arsenal: Mega Nuke | 39 |
| `unlock_scatter` | Arsenal: Scattershot | 67 |
| `unlock_reinforce` | Arsenal: Reinforcements | 149 |
| `unlock_artillery` | Arsenal: Artillery | 99 |
| `unlock_airfield` | Arsenal: Air Strike | 349 |
| `unlock_railgun` | Arsenal: Railgun | 999 |
| `unlock_stars2x` | Arsenal: 2x Stars | 59 |
| `unlock_reload2x` | Arsenal: Rapid Reload | 129 |
| `starter_pack` | Starter pack | 39 |

## 2. Flaggen-Shop → `src/shared/Assets/ShopFlags.luau` (Feld `product` je Flagge)

Preise kommen aus der Seltenheit (`src/shared/Data/Shop.luau`).

| Key | Name | Seltenheit | Robux |
|---|---|---|---|
| `pumpkin_king` | Pumpkin King | legendary | 149 |
| `bat_moon` | Bat Moon | epic | 99 |
| `grinning_skull` | Candle Skull | epic | 99 |
| `cauldron` | Witch's Brew | epic | 99 |
| `phantom` | Phantom | rare | 49 |
| `spider_web` | Spider's Lair | rare | 49 |
| `lion_crest` | Lion Crest | epic | 99 |
| `wolf_pack` | Wolf Pack | rare | 49 |
| `dragon_dynasty` | Dragon Dynasty | legendary | 149 |
| `phoenix` | Phoenix Rising | legendary | 149 |
| `radioactive` | Radioactive | rare | 49 |
| `warhead` | Warhead | epic | 99 |
| `mirv_storm` | MIRV Storm | legendary | 149 |
| `big_red_button` | Big Red Button | rare | 49 |
| `kraken` | Kraken | legendary | 149 |
| `anchor` | Iron Anchor | rare | 49 |
| `jolly_roger` | Jolly Roger | epic | 99 |
| `lighthouse` | Lighthouse | rare | 49 |
| `astronaut` | Astronaut | rare | 49 |
| `rocket` | Liftoff | rare | 49 |
| `ringed_planet` | Ringed Planet | epic | 99 |
| `comet` | Comet | epic | 99 |
| `cat` | Smug Cat | rare | 49 |
| `capybara` | Capybara | epic | 99 |
| `rubber_duck` | Rubber Duck | rare | 49 |
| `pizza` | Pizza Party | rare | 49 |
| `volcano` | Volcano | epic | 99 |
| `thunder` | Thunderstrike | rare | 49 |
| `frost_crown` | Frost Crown | epic | 99 |
| `tornado` | Tornado | rare | 49 |

## 3. Set-Bundle → `src/shared/Assets/ShopFlags.luau` → `sets.halloween.product`

| Key | Name | Robux |
|---|---|---|
| `halloween` | All 6 Halloween flags | 299 |

## Keine Gamepasses nötig

Das Spiel nutzt nur Developer Products (Einmal-Käufe, im Spiel gespeichert), keine Gamepasses.

Summe: 13 + 30 + 1 = 44 Produkte.

Tipp: `tools/assets/make_arsenal_products.py` und `make_shop_flags.py` können Produkte automatisch über die Open-Cloud-API anlegen. Dafür brauchst du einen eigenen API-Key in `.secrets/roblox_api_key`. Der Ordner ist in `.gitignore`, also nie committen.
