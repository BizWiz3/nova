local task = require("@lune/task")
local Types = require("./types")

local LuneTask = {} :: Types.TaskAdapter

function LuneTask.wait(duration)
    return task.wait(duration)
end

return LuneTask
