# 🎣 thd_fishing | Immersive Angling

A complete fishing ecosystem for the QBCore framework. This resource offers a relaxing yet rewarding activity for players, featuring restricted fishing zones, item-based mechanics, and an interactive NPC market.

![Version](https://img.shields.io/badge/Version-1.0.0-green?style=for-the-badge)
![Activity](https://img.shields.io/badge/Activity-Leisure-emerald?style=for-the-badge)

---

## ✨ Features

- **Zone-Based Fishing**: Specific designated areas for fishing to encourage player interaction.
- **Dynamic Catch System**: Multiple fish species with varying rarity and market value.
- **Skill-Based Minigame**: Integrated with `qb-skillbar` for a challenging and engaging experience.
- **Bait & Rod Mechanics**: Requires specific items to start fishing, with configurable bait consumption rates.
- **Interactive Fish Market**: Dedicated NPC for selling your catch, featuring custom models and fixed locations.
- **Optimized Performance**: Zero resmon impact when not fishing.

---

## 🎨 Design Philosophy

`thd_fishing` is built for immersion:
- **Visual Feedback**: Clear notifications (thd_notify integrated) for successful catches and bait loss.
- **AstraV Aesthetics**: Consistent with the server's clean and modern UI style.
- **Ease of Use**: Simple, intuitive commands and targeting interactions.

---

## 🛠️ Requirements

- **QBCore Framework**
- **qb-skillbar** (for the fishing minigame)
- **thd_notify** (recommended)
- **ox_inventory / qb-inventory** (for fish items)

---

## 🚀 Installation

1. Drag the `thd_fishing` folder into your `resources/[thd]` directory.
2. Add the following items to your shared inventory config:
   - `fishingrod`, `fishingbait`, `fish_cod`, `fish_mackerel`, `fish_bass`, `fish_tuna`, `fish_salmon`.
3. Add the following to your `server.cfg`:
   ```cfg
   ensure thd_fishing
   ```

---

## ⚙️ Configuration

Configure prices, locations, and success rates in `config.lua`:

```lua
Config.FishingZone = {
    coords = vector3(1299.27, 4216.42, 33.91),
    radius = 50.0,
}

Config.Fish = {
    ['fish_cod'] = { price = 50, label = 'Mezgit' },
    ['fish_mackerel'] = { price = 75, label = 'Uskumru' },
    -- ...
}
```

---

## 🐟 How to Play

1. Buy a **Fishing Rod** and some **Bait** from a local shop.
2. Head to the designated **Fishing Zone**.
3. Use the **Fishing Rod** from your inventory.
4. Complete the skillbar minigame to reel in your catch!
5. Visit the **Fisherman NPC** to sell your fish for cash.

---