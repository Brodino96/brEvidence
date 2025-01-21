---------------------------- # ---------------------------- # ---------------------------- # ----------------------------

Props = {}
Indexes = {}

---------------------------- # ---------------------------- # ---------------------------- # ----------------------------

AddTextEntry("both", Config.prompt["interact"].."\n"..Config.prompt["pickup"])
AddTextEntry("interact", Config.prompt["interact"])

---------------------------- # ---------------------------- # ---------------------------- # ----------------------------

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
    print("starting")
    for _, i in pairs(Config.evidences) do
        Props[_] = i
        Props[_].handle = createProp(i.prop, i.coords)
        if checkTags(i.tags) then
            Indexes[#Indexes+1] = _
        end
    end

    TriggerServerEvent("br_evidence:requestSync")

    CreateThread(function ()
        SetEntityDrawOutlineColor(Config.outline.color[1], Config.outline.color[2], Config.outline.color[3], Config.outline.color[4])
        SetEntityDrawOutlineShader(Config.outline.size)

        while true do
            Wait(0)

            local playerPed = PlayerPedId()
            local pCoords = GetEntityCoords(playerPed)

            for i = 1, #Indexes do
                local this = Props[Indexes[i]]

                if this == nil then
                    print(json.encode(Indexes))
                    goto skip
                end

                local dist = #(pCoords - this.coords)

                if dist < 1.5 then

                    if not this.isHighlighted then
                        SetEntityDrawOutline(this.handle, true)
                        this.isHighlighted = true
                    end

                    if this.pickup then
                        DisplayHelpTextThisFrame("both", true)
                        DisableControlAction(0, 140, true) -- R
                        if IsDisabledControlJustPressed(0, 140) then -- R
                            Action.pickup(Indexes[i])
                            print("aaaaaaaaaaa")
                        end
                    else
                        DisplayHelpTextThisFrame("interact", true)
                    end

                    DisableControlAction(0, 51, true) -- E
                    if IsDisabledControlJustPressed(0, 51) then -- E
                        Action.interact(this)
                    end

                else

                    if this.isHighlighted then
                        SetEntityDrawOutline(this.handle, false)
                        this.isHighlighted = false
                    end

                end

                ::skip::
            end
        end
    end)
end

---------------------------- # ---------------------------- # ---------------------------- # ----------------------------

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", init)

RegisterNetEvent("br_evidence:scriptStarted")
AddEventHandler("br_evidence:scriptStarted", init)

RegisterNetEvent("br_evidence:removeProps")
AddEventHandler("br_evidence:removeProps", function (idx)
    for i = 1, #idx do
        DeleteObject(Props[idx[i]].handle)
        Props[idx[i]] = nil

        for k = 1, #Indexes do
            if Indexes[k] == idx[i] then
                Indexes[k] = nil
            end
        end
    end
end)

RegisterNetEvent("onResourceStop")
AddEventHandler("onResourceStop", function (name)
    if not name == GetCurrentResourceName() then
        return
    end

    for _, i in pairs(Props) do
        DeleteObject(i.handle)
    end
end)

---------------------------- # ---------------------------- # ---------------------------- # ----------------------------