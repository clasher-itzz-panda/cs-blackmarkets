Notify = {}

function Notify.Send(source, type, message)
    if IsDuplicityVersion() then
        if Bridge.Notify == 'ox' then
            TriggerClientEvent('ox_lib:notify', source, { type = type, description = message })
        else
            TriggerClientEvent('QBCore:Notify', source, message, type)
        end
    else
        if Bridge.Notify == 'ox' then
            lib.notify({ type = type, description = message })
        else
            Bridge.Core.Functions.Notify(message, type)
        end
    end
end

function Notify.Success(source, message)
    Notify.Send(source, 'success', message)
end

function Notify.Error(source, message)
    Notify.Send(source, 'error', message)
end

function Notify.Info(source, message)
    Notify.Send(source, 'info', message)
end
