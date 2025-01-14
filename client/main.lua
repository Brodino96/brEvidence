Props = lib.callback.await("br_evidence:syncProps")

AddTextEntry("interact", "Press ~INPUT_CONTEXT~ to interact")
AddTextEntry("pickup", "Press ~INPUT_RELOAD~ to pickup")

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

local function init()

    Wait(1000)

    Props = lib.callback.await("br_evidence:syncProps")

    for _, this in pairs(Props) do
        Props[_].canInteract = checkTags(this.tags)
    end

    -- Main thread
    CreateThread(function ()
        while true do
            Wait(0)
            local playerPed = PlayerPedId()
            local pCoords = GetEntityCoords(playerPed)

            for i = 1, #Props do
                local this = Props[i]
                if not this.canInteract then
                    goto skip
                end

                local dist = #(pCoords - this.coords)

                if dist <= 3.0 then
                    DisplayHelpTextThisFrame("interact", true)
                    DisplayHelpTextThisFrame("pickup", true)

                    if IsControlJustPressed(0, 52) then
                        Action.interact(this)
                    end

                    if IsControlJustPressed(0, 45) then
                        Action.pickup(this)
                    end
                end

                ::skip::
            end
        end
    end)
end

init()