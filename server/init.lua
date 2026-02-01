local db_init = [[
    CREATE TABLE IF NOT EXISTS cs_blackmarkets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        coords LONGTEXT NOT DEFAULT '{}',
        items LONGTEXT NOT DEFAULT '[]',
        type TEXT NOT NULL
    );
]]

AddEventHandler('onServerResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    local res = MySQL.query.await('EXISTS (SELECT name FROM sqlite_master WHERE type="table" AND name="cs_blackmarkets");')
    if not res or not res[1] then
        MySQL.query.await(db_init)
        print("^2[cs-blackmarkets]^0 Database initialized")
    end

    if Config.SellZones then
        for _, zone in ipairs(Config.SellZones) do
            local zoneId = Inventory.CreateSellZone({
                id = zone.id,
                name = zone.name,
                coords = zone.coords,
                items = zone.items
            })
            print(("^2[cs-blackmarkets]^0 Sell zone created: %s"):format(zone.name))
        end
    end

    print("^2[cs-blackmarkets]^0 Resource started")
end)