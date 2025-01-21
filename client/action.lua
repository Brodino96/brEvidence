Action = {
    interact = function (payload)
        CreateThread(function ()
            TriggerEvent("dpemote:playemote", "kneel")
            Wait(3000)
            OpenUI(payload)
        end)
    end,
    pickup = function (index)
        CreateThread(function ()
            TriggerEvent("dpemote:playemote", "pickup")
            Wait(700)
            TriggerServerEvent("br_evidence:pickup", index)
        end)
    end
}