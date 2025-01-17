function OpenUI(data)
    TriggerScreenblurFadeIn(500)
    SendNUIMessage({
        action = "showInterface",
        model = data.nui.model,
        offset = {
            x = data.nui.offset.x,
            y = data.nui.offset.y,
            z = data.nui.offset.z,
        },
        distance = data.nui.distance,
        title = data.nui.title,
        description = data.nui.description,
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback("closeInterface", function (body, cb)
    cb(SetNuiFocus(false, false))
    TriggerScreenblurFadeOut(500)
end)