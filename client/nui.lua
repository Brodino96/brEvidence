function OpenUI(data)
    TriggerScreenblurFadeIn(500)
    SendNUIMessage({
        payload = data.nui,
        action = "showInterface",
    })
    SetNuiFocus(true, true)
    TriggerEvent("dpemote:stoplatestemote")
end

RegisterNUICallback("closeInterface", function (body, cb)
    cb(SetNuiFocus(false, false))
    TriggerScreenblurFadeOut(500)
end)