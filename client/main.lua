Props = {}
Indexes = {}

AddTextEntry("interact", "Press ~INPUT_CONTEXT~ to interact\nPress ~INPUT_MELEE_ATTACK_LIGHT~ to pickup")

---Creates the props in the world
---@param prop string The prop hash
---@param coords vector3 The place where the prop will be spawned
---@return number prop The props handle
local function createProp(prop, coords)
    RequestModel(prop)
    while not HasModelLoaded(prop) do
        Wait(0)
    end
    local handle = CreateObject(prop, coords.x, coords.y, coords.z - 1, false, true, false)
    SetModelAsNoLongerNeeded(prop)
    return handle
end

---Checks if the player has the given tags
---@param tags nil|string|table The list of tags
---@return boolean
local function checkTags(tags)
    if tags == nil then
        return true
    end

    local tagType = type(tags)
    if tagType == "string" then
        return exports["br_tags"]:has(tags)
    elseif tagType == "table" then
        for i = 1, #tags do
            if exports["br_tags"]:has(tags[i]) then
                return true
            end
        end
    end

    return false
end

---Starting function
local function init()
    for _, i in pairs(Config.evidences) do
        Props[_] = i
        Props[_].handle = createProp(i.prop, i.coords)
        if checkTags(i.tags) then
            Indexes[#Indexes+1] = _
        end
    end

    CreateThread(function ()
        SetEntityDrawOutlineColor(Config.outline.color[1], Config.outline.color[2], Config.outline.color[3], Config.outline.color[4])
        SetEntityDrawOutlineShader(Config.outline.size)

        while true do
            Wait(0)

            local playerPed = PlayerPedId()
            local pCoords = GetEntityCoords(playerPed)

            for i = 1, #Indexes do
                local this = Props[Indexes[i]]

                local dist = #(pCoords - this.coords)

                if dist < 3 then

                    if not this.isHighlighted then
                        SetEntityDrawOutline(this.handle, true)
                        this.isHighlighted = true
                    end

                    DisplayHelpTextThisFrame("interact", true)

                    DisableControlAction(0, 51, true) -- E
                    DisableControlAction(0, 140, true) -- R
                    if IsDisabledControlJustPressed(0, 51) then -- E
                        OpenUI(this)
                    end

                    if IsDisabledControlJustPressed(0, 140) then -- R
                        print(json.encode(this))
                    end

                else

                    if this.isHighlighted then
                        SetEntityDrawOutline(this.handle, false)
                        this.isHighlighted = false
                    end

                end
            end
        end
    end)
end

init()

RegisterNetEvent("onResourceStop")
AddEventHandler("onResourceStop", function (name)
    if not name == GetCurrentResourceName() then
        return
    end

    for _, i in pairs(Props) do
        DeleteObject(i.handle)
    end
end)