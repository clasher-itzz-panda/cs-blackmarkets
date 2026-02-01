local activeSellSessions = {}

local function GetPlayer(src)
    if Bridge.Core then
        if Bridge.Core.Functions then
            return Bridge.Core.Functions.GetPlayer(src)
        elseif Bridge.Core.GetPlayerData then
            return Bridge.Core.GetPlayerData(src)
        end
    end
    return nil
end

local function AddMoney(src, amount)
    local Player = GetPlayer(src)
    if not Player then return false end
    if Player.Functions and Player.Functions.AddMoney then
        return Player.Functions.AddMoney('cash', amount)
    elseif Player.addMoney then
        return Player.addMoney(amount)
    end
    return false
end

RegisterNetEvent('cs-blackmarkets:server:openSellZone', function(zoneId)
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end

    local zone = Inventory.GetSellZone(zoneId)
    if not zone then
        return Notify.Error(src, 'Zone not found')
    end

    activeSellSessions[src] = {
        zoneId = zoneId,
        itemsToSell = {},
        totalValue = 0
    }

    Inventory.OpenSellZone(src, zoneId)
end)

RegisterNetEvent('cs-blackmarkets:server:closeSellZone', function()
    local src = source
    local session = activeSellSessions[src]
    if not session then return end

    local Player = GetPlayer(src)
    if not Player then
        activeSellSessions[src] = nil
        return
    end

    local zoneId = session.zoneId
    local totalEarned = 0

    local stashItems = Inventory.GetStashItems(zoneId)
    if stashItems then
        for _, item in pairs(stashItems) do
            if item and item.name then
                local count = item.count or item.amount or 1
                local price = Inventory.GetItemPrice(zoneId, item.name)
                if price > 0 then
                    totalEarned = totalEarned + (price * count)
                    Inventory.RemoveItem(zoneId, item.name, count)
                else
                    Inventory.AddItem(src, item.name, count)
                    Inventory.RemoveItem(zoneId, item.name, count)
                end
            end
        end
    end

    if totalEarned > 0 then
        AddMoney(src, totalEarned)
        Notify.Success(src, 'You sold items for $' .. totalEarned)
    end

    activeSellSessions[src] = nil
end)

CreateThread(function()
    Wait(500)
    if Bridge.Inventory == 'ox' then
        exports.ox_inventory:registerHook('swapItems', function(payload)
            local src = payload.source
            local session = activeSellSessions[src]
            if not session then return true end
            local zoneId = session.zoneId
            if payload.toInventory == zoneId then
                local itemName = payload.fromSlot.name
                if not Inventory.IsItemSellable(zoneId, itemName) then
                    Notify.Error(src, 'This item cannot be sold here!')
                    return false
                end
            end
            return true
        end, {})
    end
end)

RegisterNetEvent('qb-inventory:server:SaveStashItems', function(stashId, items)
    if Bridge.Inventory ~= 'qb' then return end
    local src = source
    local session = activeSellSessions[src]
    if not session then return end
    if stashId == session.zoneId then
        local zone = Inventory.GetSellZone(stashId)
        if zone then
            for _, item in pairs(items) do
                if item and item.name then
                    if not Inventory.IsItemSellable(stashId, item.name) then
                        Notify.Error(src, 'This item cannot be sold here!')
                        local Player = GetPlayer(src)
                        if Player and Player.Functions then
                            Player.Functions.AddItem(item.name, item.amount or 1)
                        end
                    else
                        Inventory.QB.AddToStash(stashId, item.name, item.amount or 1, item.info)
                    end
                end
            end
        end
    end
end)

Callback.Register('cs-blackmarkets:getZones', function(src)
    local zones = {}
    local allZones = Inventory.GetAllSellZones()
    for zoneId, zone in pairs(allZones) do
        local items = {}
        for itemName, price in pairs(zone.items) do
            table.insert(items, { name = itemName, price = price })
        end
        table.insert(zones, {
            id = zone.id,
            name = zone.name,
            coords = zone.coords,
            type = zone.type,
            items = items
        })
    end
    return zones
end)

Callback.Register('cs-blackmarkets:saveZone', function(src, zoneData)
    if not zoneData then return false end
    local items = {}
    for _, item in ipairs(zoneData.items or {}) do
        items[item.name] = item.price
    end
    local zoneId = Inventory.CreateSellZone({
        id = zoneData.id,
        name = zoneData.name,
        coords = zoneData.coords,
        items = items
    })
    return zoneId ~= nil
end)

Callback.Register('cs-blackmarkets:deleteZone', function(src, zoneId)
    Inventory.RemoveSellZone('blackmarket_sell_' .. zoneId)
    return true
end)

AddEventHandler('playerDropped', function()
    local src = source
    local session = activeSellSessions[src]
    if session then
        local zoneId = session.zoneId
        local stashItems = Inventory.GetStashItems(zoneId)
        if stashItems then
            for _, item in pairs(stashItems) do
                if item and item.name then
                    local count = item.count or item.amount or 1
                    Inventory.RemoveItem(zoneId, item.name, count)
                end
            end
        end
        activeSellSessions[src] = nil
    end
end)
