local task = zune.task
local Types = require("./types")

local ZuneTask = {} :: Types.TaskAdapter

function ZuneTask.wait(duration)
    return task.wait(duration)
end

return ZuneTask
