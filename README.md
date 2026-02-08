# CS-Blackmarkets

<div align="center">

![FiveM](https://img.shields.io/badge/FiveM-CF1020?style=for-the-badge&logo=fivem&logoColor=white)
![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)

**A fully-featured black market system for FiveM servers**

*Created during the first Community Clash of the QBCore Community*

</div>

---

## Features

- **QBCore Framework** — Built specifically for QBCore servers
- **Inventory Compatibility** — Supports ox_inventory, qb-inventory, and qs-inventory
- **Sell Zones** — Create customizable locations where players can sell illegal goods
- **Buy Zones** — Set up underground suppliers for weapons and contraband
- **Modern UI** — Beautiful React-based admin interface for zone management
- **Live Configuration** — Add, edit, and delete zones in real-time without restarts
- **Teleportation** — Teleport directly to zones from the admin panel
- **Auto-Detection** — Automatically detects your framework and inventory system
- **Price Configuration** — Set custom prices for each item at each location

---

## Dependencies

| Dependency | Required |
|------------|----------|
| [oxmysql](https://github.com/overextended/oxmysql) | Yes |
| [qb-core](https://github.com/qbcore-framework/qb-core) | Yes |
| [ox_inventory](https://github.com/overextended/ox_inventory) **OR** [qb-inventory](https://github.com/qbcore-framework/qb-inventory) | Yes |
| [ox_lib](https://github.com/overextended/ox_lib) | Optional |

---

## Installation

1. **Download** the latest release
2. **Extract** the folder to your server's `resources` directory
3. **Rename** the folder to `cs-blackmarkets`
4. **Add** `ensure cs-blackmarkets` to your `server.cfg`
5. **Configure** the script in `shared/config.lua`
6. **Restart** your server

---

## Configuration

All configuration is done in `shared/config.lua`:

```lua
Config = {}

-- Language setting
Config.Locale = 'en'

-- Force specific systems (leave nil for auto-detection)
Config.Preferences = {
    Inventory = nil,  -- 'ox' | 'qb' | 'qs'
    Notify = nil,     -- 'ox' | 'qb'
    Callback = nil,   -- 'ox' | 'qb'
    Core = nil,       -- 'qb'
}

-- Admin command configuration
Config.Command = {
    Enable = true,
    Permission = 'admin',
    Name = 'blackmarkets'
}

-- Sell zones - Players can sell items here
Config.SellZones = {
    {
        id = 1,
        name = 'Downtown Black Market',
        coords = { x = 123.45, y = -456.78, z = 29.5 },
        type = 'sell',
        items = {
            ['cocaine'] = 500,   -- item name = price
            ['weed'] = 150,
            ['meth'] = 800,
        }
    },
}

-- Buy zones - Players can purchase items here
Config.BuyZones = {
    {
        id = 1,
        name = 'Underground Supplier',
        coords = { x = 456.78, y = 123.45, z = 28.9 },
        type = 'buy',
        items = {
            { name = 'lockpick', price = 50 },
            { name = 'weapon_pistol', price = 2500 },
        }
    },
}
```

---

## Usage

### Admin Panel

Use the command `/blackmarkets` (configurable) to open the admin panel where you can:

- View all configured zones
- Add new sell/buy zones
- Edit existing zone names, coordinates, and items
- Delete zones
- Teleport directly to any zone

### Player Interaction

Players interact with black market zones through the inventory system:

1. Player enters a sell zone area
2. Opens the sell stash
3. Places items they want to sell
4. Closes the inventory to receive payment
5. Only accepted items can be sold — others are returned

---

## Exports

The script provides client-side exports for integration with other resources:

```lua
-- Open a specific sell zone
exports['cs-blackmarkets']:OpenSellZone(zoneId)

-- Close the current sell zone
exports['cs-blackmarkets']:CloseSellZone()

-- Open the admin UI
exports['cs-blackmarkets']:OpenUI()

-- Close the admin UI
exports['cs-blackmarkets']:CloseUI()
```

---

## Preview

<div align="center">

| Admin Panel | Zone Management |
|:-----------:|:---------------:|
| Dashboard with zone statistics | Create, edit, and delete zones |
| One-click teleportation | Item price configuration |

</div>

---

## Support

If you encounter any issues or have suggestions, please open an issue on the repository.

---

## License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

---

<div align="center">

**Made with love by Panda**

*Clinky Software*

</div>
