---------------------------- # ---------------------------- # ---------------------------- # ----------------------------

---Initializes the creator process
---@param model string Prop model
local function init(model)
    local prop = CreateProp(model, GetEntityCoords(PlayerPedId()))
    local placing = true
    local playerPed = PlayerPedId()

    CreateThread(function ()
        while placing do
            Wait(0)
            local pCoords = GetEntityCoords(playerPed)
            local vector = GetEntityForwardVector(playerPed)
            local targetCoords = pCoords + vector * 3.0

            SetEntityCoords(prop, targetCoords.x, targetCoords.y, targetCoords.z, false, false, false, false)
        end
    end)
end

RegisterCommand("test", function ()
    init("prop_laptop_lester")
end, false)

---------------------------- # ---------------------------- # ---------------------------- # ----------------------------