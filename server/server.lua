---------------------------- # ---------------------------- # ---------------------------- # ----------------------------

local toRemove = {}

---------------------------- # ---------------------------- # ---------------------------- # ----------------------------

RegisterNetEvent("br_evidence:pickup")
AddEventHandler("br_evidence:pickup", function (index)
    toRemove[#toRemove+1] = index
    exports["ox_inventory"]:AddItem(source, index, 1)
    TriggerClientEvent("br_evidence:removeProps", -1, { index })
end)

RegisterNetEvent("br_evidence:requestSync")
AddEventHandler("br_evidence:requestSync", function ()
    TriggerClientEvent("br_evidence:removeProps", source, toRemove)
end)

CreateThread(function ()
    Wait(2000)
    TriggerClientEvent("br_evidence:scriptStarted", -1)
end)


---------------------------- # ---------------------------- # ---------------------------- # ----------------------------