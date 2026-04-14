-- nova/src/libs/process/lune.luau
local process = require("@lune/process")
local Types = require("./types")

local LuneProcess = {} :: Types.ProcessAdapter

LuneProcess.cwd = process.cwd
LuneProcess.env = process.env

function LuneProcess.create(exec, args, opts)
    return process.create(exec, args, opts) :: any
end

return LuneProcess