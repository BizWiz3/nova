local Types = require("./task/types")
local checkRuntime = require("./checkRuntime")

local function getAdapter(): Types.TaskAdapter
    local runtime = checkRuntime()

    if runtime == "lune" then
        return require("@self/lune")
    elseif runtime == "zune" then
        return require("@self/zune")
    else
        error(`Unsupported Runtime: "{runtime}"`)
    end
end

return getAdapter()
