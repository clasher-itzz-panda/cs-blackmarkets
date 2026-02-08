Callback = {}

function Callback.Register(name, cb)
    if IsDuplicityVersion() then
        if Bridge.Callback == 'ox' then
            lib.callback.register(name, cb)
        else
            Bridge.Core.Functions.CreateCallback(name, cb)
        end
    end
end

function Callback.Trigger(name, ...)
    if not IsDuplicityVersion() then
        if Bridge.Callback == 'ox' then
            return lib.callback.await(name, false, ...)
        else
            local p = promise.new()
            Bridge.Core.Functions.TriggerCallback(name, function(result)
                p:resolve(result)
            end, ...)
            return Citizen.Await(p)
        end
    end
end

function Callback.TriggerAsync(name, cb, ...)
    if not IsDuplicityVersion() then
        if Bridge.Callback == 'ox' then
            lib.callback(name, false, cb, ...)
        else
            Bridge.Core.Functions.TriggerCallback(name, cb, ...)
        end
    end
end
