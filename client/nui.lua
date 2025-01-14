---`true` when the nui is ready to be used
---@type boolean
PageReady = false

RegisterNUICallback("pageLoaded", function (body, cb)
    PageReady = true
    cb()
end)