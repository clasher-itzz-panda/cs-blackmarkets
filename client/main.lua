local currentSellZone = nil
local isUIOpen = false

function OpenSellZone(zoneId)
    currentSellZone = zoneId
    TriggerServerEvent('cs-blackmarkets:server:openSellZone', zoneId)
end

function CloseSellZone()
    if currentSellZone then
        TriggerServerEvent('cs-blackmarkets:server:closeSellZone')
        currentSellZone = nil
    end
end

function OpenUI()
    isUIOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open' })
    Callback.TriggerAsync('cs-blackmarkets:getZones', function(zones)
        SendNUIMessage({ action = 'setZones', zones = zones or {} })
    end)
end

function CloseUI()
    isUIOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

if Bridge.Inventory == 'ox' then
    AddEventHandler('ox_inventory:closed', function()
        if currentSellZone then
            CloseSellZone()
        end
    end)
else
    RegisterNetEvent('qb-inventory:client:closeinv', function()
        if currentSellZone then
            CloseSellZone()
        end
    end)
end

exports('OpenSellZone', OpenSellZone)
exports('CloseSellZone', CloseSellZone)
exports('OpenUI', OpenUI)
exports('CloseUI', CloseUI)

if Config.Command.Enable then
    RegisterCommand(Config.Command.Name, function()
        OpenUI()
    end, false)
end

RegisterNUICallback('close', function(_, cb)
    CloseUI()
    cb('ok')
end)

RegisterNUICallback('getZones', function(_, cb)
    local zones = Callback.Trigger('cs-blackmarkets:getZones')
    cb(zones or {})
end)

RegisterNUICallback('saveZone', function(data, cb)
    local success = Callback.Trigger('cs-blackmarkets:saveZone', data)
    cb(success)
end)

RegisterNUICallback('deleteZone', function(data, cb)
    local success = Callback.Trigger('cs-blackmarkets:deleteZone', data.id)
    cb(success)
end)

RegisterNUICallback('openSellZone', function(data, cb)
    OpenSellZone(data.zoneId)
    cb('ok')
end)

RegisterNUICallback('teleport', function(data, cb)
    SetEntityCoords(PlayerPedId(), data.x, data.y, data.z, false, false, false, false)
    cb('ok')
end)

RegisterNUICallback('getCoords', function(_, cb)
    local coords = GetEntityCoords(PlayerPedId())
    cb({ x = coords.x, y = coords.y, z = coords.z })
end)

CreateThread(function()
    while true do
        Wait(0)
        if isUIOpen and IsControlJustPressed(0, 322) then
            CloseUI()
        end
    end
end)