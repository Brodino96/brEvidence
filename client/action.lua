Action = {
    interact = function (payload)
        TriggerEvent("dpemote:playemotenotstoppable", "kneel")
        Wait(3000)
        OpenUI(payload)
    end,
    pickup = function (payload)
        TriggerEvent("dpemote:playemotenotstoppable", "pickup")
        Wait(1000)
        
        TriggerServerEvent("br_evidence:pickup", payload)
    end
}