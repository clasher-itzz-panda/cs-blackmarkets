Inventory = Inventory or {}
Inventory.QB = {}
local sellZones = {}
local openStashes = {}

function Inventory.QB.CreateSellZone(cfg)
    if not cfg or not cfg.items or not cfg.id then return end
    local zoneId = 'blackmarket_sell_' .. cfg.id
    sellZones[zoneId] = {
        id = cfg.id,
        name = cfg.name or 'Black Market Sell',
        coords = cfg.coords,
        items = cfg.items,
        type = 'sell',
        stashItems = {}
    }
    return zoneId
end

function Inventory.QB.OpenSellZone(source, zoneId)
    local zone = sellZones[zoneId]
    if not zone then return end
    openStashes[source] = zoneId
    local stashData = {
        label = zone.name,
        maxweight = 100000,
        slots = 50,
        items = zone.stashItems or {}
    }
    TriggerClientEvent('qb-inventory:client:OpenInventory', source, 'stash', zoneId, stashData)
end

function Inventory.QB.GetSellZone(zoneId)
    return sellZones[zoneId]
end

function Inventory.QB.GetAllSellZones()
    return sellZones
end

function Inventory.QB.IsItemSellable(zoneId, itemName)
    local zone = sellZones[zoneId]
    if not zone then return false end
    return zone.items[itemName] ~= nil
end

function Inventory.QB.GetItemPrice(zoneId, itemName)
    local zone = sellZones[zoneId]
    if not zone or not zone.items[itemName] then return 0 end
    return zone.items[itemName]
end

function Inventory.QB.GetStashItems(zoneId)
    local zone = sellZones[zoneId]
    if not zone then return {} end
    return zone.stashItems or {}
end

function Inventory.QB.AddItem(target, item, count, metadata)
    local Player = Bridge.Core.Functions.GetPlayer(target)
    if Player then
        return Player.Functions.AddItem(item, count, nil, metadata)
    end
    return false
end

function Inventory.QB.RemoveItem(target, item, count)
    if type(target) == 'number' then
        local Player = Bridge.Core.Functions.GetPlayer(target)
        if Player then
            return Player.Functions.RemoveItem(item, count)
        end
    else
        local zone = sellZones[target]
        if zone and zone.stashItems then
            for i, stashItem in ipairs(zone.stashItems) do
                if stashItem.name == item then
                    stashItem.amount = stashItem.amount - count
                    if stashItem.amount <= 0 then
                        table.remove(zone.stashItems, i)
                    end
                    return true
                end
            end
        end
    end
    return false
end

function Inventory.QB.AddToStash(zoneId, item, count, metadata)
    local zone = sellZones[zoneId]
    if not zone then return false end
    zone.stashItems = zone.stashItems or {}
    local found = false
    for _, stashItem in ipairs(zone.stashItems) do
        if stashItem.name == item then
            stashItem.amount = stashItem.amount + count
            found = true
            break
        end
    end
    if not found then
        table.insert(zone.stashItems, { name = item, amount = count, info = metadata or {} })
    end
    return true
end

function Inventory.QB.ClearStash(zoneId)
    local zone = sellZones[zoneId]
    if zone then
        zone.stashItems = {}
    end
end

function Inventory.QB.GetOpenStash(source)
    return openStashes[source]
end

function Inventory.QB.CloseStash(source)
    openStashes[source] = nil
end

function Inventory.QB.CloseInventory(source)
    TriggerClientEvent('qb-inventory:client:CloseInventory', source)
    openStashes[source] = nil
end

function Inventory.QB.RemoveSellZone(zoneId)
    sellZones[zoneId] = nil
end
