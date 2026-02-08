Inventory = Inventory or {}
Inventory.Ox = {}
local sellZones = {}

function Inventory.Ox.CreateSellZone(cfg)
    if not cfg or not cfg.items or not cfg.id then return end
    local zoneId = 'blackmarket_sell_' .. cfg.id
    exports.ox_inventory:RegisterStash(zoneId, cfg.name or 'Black Market Sell', 50, 100000)
    sellZones[zoneId] = {
        id = cfg.id,
        name = cfg.name or 'Black Market Sell',
        coords = cfg.coords,
        items = cfg.items,
        type = 'sell'
    }
    return zoneId
end

function Inventory.Ox.OpenSellZone(source, zoneId)
    local zone = sellZones[zoneId]
    if not zone then return end
    exports.ox_inventory:forceOpenInventory(source, 'stash', zoneId)
end

function Inventory.Ox.GetSellZone(zoneId)
    return sellZones[zoneId]
end

function Inventory.Ox.GetAllSellZones()
    return sellZones
end

function Inventory.Ox.IsItemSellable(zoneId, itemName)
    local zone = sellZones[zoneId]
    if not zone then return false end
    return zone.items[itemName] ~= nil
end

function Inventory.Ox.GetItemPrice(zoneId, itemName)
    local zone = sellZones[zoneId]
    if not zone or not zone.items[itemName] then return 0 end
    return zone.items[itemName]
end

function Inventory.Ox.GetStashItems(zoneId)
    return exports.ox_inventory:GetInventoryItems(zoneId)
end

function Inventory.Ox.AddItem(target, item, count, metadata)
    return exports.ox_inventory:AddItem(target, item, count, metadata)
end

function Inventory.Ox.RemoveItem(target, item, count)
    return exports.ox_inventory:RemoveItem(target, item, count)
end

function Inventory.Ox.RegisterHook(hookType, cb)
    exports.ox_inventory:registerHook(hookType, cb, {})
end

function Inventory.Ox.CloseInventory(source)
    exports.ox_inventory:forceCloseInventory(source)
end

function Inventory.Ox.RemoveSellZone(zoneId)
    sellZones[zoneId] = nil
end
