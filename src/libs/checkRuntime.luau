local runtime = string.split(_VERSION, " ")[1]:lower()

local function checkRuntime()
    return runtime
end

return checkRuntime