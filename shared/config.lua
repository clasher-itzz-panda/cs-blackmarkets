Config = {}

Config.Locale = 'en'

Config.Preferences = {
    Inventory = nil,
    Notify = nil,
    Callback = nil,
    Core = nil,
}

Config.Command = {
    Enable = true,
    Permission = 'admin',
    Name = 'blackmarkets'
}

Config.SellZones = {
    {
        id = 1,
        name = 'Downtown Black Market',
        coords = { x = 123.45, y = -456.78, z = 29.5 },
        type = 'sell',
        items = {
            ['cocaine'] = 500,
            ['weed'] = 150,
            ['meth'] = 800,
        }
    },
    {
        id = 2,
        name = 'Harbor Deal Zone',
        coords = { x = -892.12, y = 234.56, z = 31.2 },
        type = 'sell',
        items = {
            ['stolen_goods'] = 200,
            ['electronics'] = 350,
        }
    },
}

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

