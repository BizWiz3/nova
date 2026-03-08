local stdio = require("@lune/stdio")
local task = require("@lune/task")

local RED = stdio.color("red")
local RESET = stdio.color("reset")

local Try = {}
Try.__index = Try

type Try = {
    success: boolean?,
    result: any,
    _isAsync: boolean,
    _pendingCatch: ((err: string) -> ())?,
    _pendingFinally: (() -> ())?
}

local function execute(self, f, ...)
    local args = { ... }
    self.success, self.result = pcall(f, table.unpack(args))
    
    if not self.success and self._pendingCatch then
        self._pendingCatch(debug.traceback(tostring(self.result), 3))
    end
    
    if self._pendingFinally then
        local ok, err = pcall(self._pendingFinally)
        if not ok then
            stdio.write(RED)
            print("Error in finally block: " .. tostring(err))
            stdio.write(RESET)
        end
    end
end

function Try.new(f: (...any) -> ...any, ...: any)
    local self = setmetatable({ _isAsync = false } :: Try, Try)
    execute(self, f, ...)
    return self
end

function Try.async(f: (...any) -> ...any, ...: any)
    local self = setmetatable({ _isAsync = true } :: Try, Try)
    local args = { ... }
    
    task.spawn(function()
        task.wait() 
        execute(self, f, table.unpack(args))
    end)
    
    return self
end

function Try:catch(f: (err: string) -> ())
    if self._isAsync then
        self._pendingCatch = f
    elseif not self.success then
        f(debug.traceback(tostring(self.result), 3))
    end
    return self
end

function Try:finally(f: () -> ())
    if self._isAsync then
        self._pendingFinally = f
    else
        local ok, err = pcall(f)
        if not ok then
            stdio.write(RED)
            print("Error in finally block: " .. tostring(err))
            stdio.write(RESET)
        end
    end
    return self
end

return Try