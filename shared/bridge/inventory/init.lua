Inventory = {}

function Inventory.GetBridge()
    if Bridge.Inventory == 'ox' then
        return Inventory.Ox
    else
        return Inventory.QB
    end
end

function Inventory.CreateSellZone(cfg)
    return Inventory.GetBridge().CreateSellZone(cfg)
end

function Inventory.OpenSellZone(source, zoneId)
    return Inventory.GetBridge().OpenSellZone(source, zoneId)
end

function Inventory.GetSellZone(zoneId)
    return Inventory.GetBridge().GetSellZone(zoneId)
end

function Inventory.GetAllSellZones()
    return Inventory.GetBridge().GetAllSellZones()
end

function Inventory.IsItemSellable(zoneId, itemName)
    return Inventory.GetBridge().IsItemSellable(zoneId, itemName)
end

function Inventory.GetItemPrice(zoneId, itemName)
    return Inventory.GetBridge().GetItemPrice(zoneId, itemName)
end

function Inventory.GetStashItems(zoneId)
    return Inventory.GetBridge().GetStashItems(zoneId)
end

function Inventory.AddItem(target, item, count, metadata)
    return Inventory.GetBridge().AddItem(target, item, count, metadata)
end

function Inventory.RemoveItem(target, item, count)
    return Inventory.GetBridge().RemoveItem(target, item, count)
end

function Inventory.CloseInventory(source)
    return Inventory.GetBridge().CloseInventory(source)
end

function Inventory.RemoveSellZone(zoneId)
    return Inventory.GetBridge().RemoveSellZone(zoneId)
end
