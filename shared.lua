---@type table Debug functions
Debug = {
    ---@param text string The text to print
    ---@param bypass boolean If Config.debugMode should be bypassed
    success = function (text, bypass)
        if Config.debugMode or bypass then
            print("[^2SUCCESS^0] "..text)
        end
    end,
    ---@param text string The text to print
    ---@param bypass boolean If Config.debugMode should be bypassed
    info = function (text, bypass)
        if Config.debugMode or bypass then
            print("[^3INFO^0] "..text)
        end
    end,
    ---@param text string The text to print
    ---@param bypass boolean If Config.debugMode should be bypassed
    error = function (text, bypass)
        if Config.debugMode or bypass then
            print("[^1ERROR^0] "..text)
        end
    end
}