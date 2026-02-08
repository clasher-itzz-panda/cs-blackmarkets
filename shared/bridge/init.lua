Bridge = {}
Bridge.Inventory = nil
Bridge.Notify = nil
Bridge.Callback = nil
Bridge.Core = nil

local function DetectInventory()
    if Config.Preferences and Config.Preferences.Inventory then
        return Config.Preferences.Inventory
    end
    if GetResourceState('ox_inventory') == 'started' then return 'ox' end
    if GetResourceState('qb-inventory') == 'started' then return 'qb' end
    if GetResourceState('qs-inventory') == 'started' then return 'qs' end
    return 'qb'
end

local function DetectNotify()
    if Config.Preferences and Config.Preferences.Notify then
        return Config.Preferences.Notify
    end
    if GetResourceState('ox_lib') == 'started' then return 'ox' end
    if GetResourceState('qb-core') == 'started' then return 'qb' end
    return 'qb'
end

local function DetectCallback()
    if Config.Preferences and Config.Preferences.Callback then
        return Config.Preferences.Callback
    end
    if GetResourceState('ox_lib') == 'started' then return 'ox' end
    if GetResourceState('qb-core') == 'started' then return 'qb' end
    return 'qb'
end

local function DetectCore()
    if Config.Preferences and Config.Preferences.Core then
        return Config.Preferences.Core
    end
    if GetResourceState('qb-core') == 'started' then return 'qb' end
    if GetResourceState('es_extended') == 'started' then return 'esx' end
    return 'qb'
end

function Bridge.Init()
    local inv = DetectInventory()
    local notify = DetectNotify()
    local callback = DetectCallback()
    local core = DetectCore()

    if core == 'qb' then
        Bridge.Core = exports['qb-core']:GetCoreObject()
    elseif core == 'esx' then
        Bridge.Core = exports['es_extended']:getSharedObject()
    end

    Bridge.Inventory = inv
    Bridge.Notify = notify
    Bridge.Callback = callback

    print('^2[cs-blackmarkets]^0 Bridge initialized:')
    print(('  Inventory: %s | Notify: %s | Callback: %s | Core: %s'):format(inv, notify, callback, core))
end

Bridge.Init()
