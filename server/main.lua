Props = {}

---Creates the in game prop
---@param prop string The prop name
---@param coords vector3 Where to spawn the prop
---@return number prop The prop handle
local function createProp(prop, coords)
    return CreateObject(prop, coords.x, coords.y, coords.z, true, true, false)
end

---Starting function
local function init()
    for _, i in pairs(Config.evidences) do
        Props[_] = i
        print("created prop")
        Props[_].handle = createProp(i.prop, i.coords)
        print("created prop")
    end

    TriggerClientEvent("br_evidence:syncProps", -1, Props)
end


lib.callback.register("br_evidence:syncProps", function ()
    return Props
end)

init()

RegisterNetEvent("onResourceStop")
AddEventHandler("onResourceStop", function (name)
    if name ~= GetCurrentResourceName() then
        return
    end

    for i = 1, #Props do
        DeleteObject(Props[i].handle)
    end
end)