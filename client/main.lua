---------------------------- # ---------------------------- # ---------------------------- # ----------------------------

Props = {}
Indexes = {}

---------------------------- # ---------------------------- # ---------------------------- # ----------------------------

if Config.interaction.method == "ox_target" then
    local state = GetResourceState("ox_target")
    if state ~= "started" then
        Config.interaction.method = "prompt"
        print("`ox_target` was not found, defaulting to prompt mode")
    end
end

if Config.interaction.method == "prompt" then
    AddTextEntry("both", Config.interaction.text["interact"].."\n"..Config.interaction.text["pickup"])
    AddTextEntry("interact", Config.interaction.text["interact"])
end

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
    for _, i in pairs(Config.evidences) do
        Props[_] = i
        Props[_].handle = createProp(i.prop, i.coords)
        if checkTags(i.tags) then
            Indexes[#Indexes+1] = _
            if Config.interaction.method == "ox_target" then
                local options = {}
                options[1] = {
                    label = Config.interaction.text["interact"],
                    name = "interact",
                    onSelect = function ()
                        Action.interact(Props[_])
                    end
                }
                if Props[_].pickup then
                    options[2] = {
                        label = Config.interaction.text["interact"],
                        name = "pickup",
                        onSelect = function ()
                            Action.pickup(_)
                        end
                    }
                end
                exports["ox_target"]:addLocalEntity(Props[_].handle, options)
            end
        end
    end

    TriggerServerEvent("br_evidence:requestSync")

    CreateThread(function () -- Highlight
        SetEntityDrawOutlineColor(Config.outline.color[1], Config.outline.color[2], Config.outline.color[3], Config.outline.color[4])
        SetEntityDrawOutlineShader(Config.outline.size)
        while true do
            Wait(0)
            local pCoords = GetEntityCoords(PlayerPedId())

            for i = 1, #Indexes do
                local this = Props[Indexes[i]]

                if this == nil then
                    goto skip
                end

                local dist = #(pCoords - this.coords)

                if Config.interaction.method == "ox_target" then
                    goto light
                end

                if dist < 1.5 then
                    if this.pickup then
                        DisplayHelpTextThisFrame("both", true)
                        DisableControlAction(0, 140, true) -- R
                        if IsDisabledControlJustPressed(0, 140) then -- R
                            Action.pickup(Indexes[i])
                        end
                    else
                        DisplayHelpTextThisFrame("interact", true)
                    end

                    DisableControlAction(0, 51, true) -- E
                    if IsDisabledControlJustPressed(0, 51) then -- E
                        Action.interact(this)
                    end
                end

                ::light::

                if dist < 1.5 then
                    if not this.isHighlighted then
                        SetEntityDrawOutline(this.handle, true)
                        this.isHighlighted = true
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
        if Config.interaction.method == "ox_target" then
            exports["ox_target"]:removeLocalEntity(Props[idx[i]].handle, { "interact", "pickup" })
        end
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
        if Config.interaction.method == "ox_target" then
            exports["ox_target"]:removeLocalEntity(i.handle, { "interact", "pickup" })
        end
        DeleteObject(i.handle)
    end
end)

---------------------------- # ---------------------------- # ---------------------------- # ----------------------------