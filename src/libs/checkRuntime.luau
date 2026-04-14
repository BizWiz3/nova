local function checkRuntime()
    local runtime = string.split(_VERSION, " ")

    return runtime[1]:lower()
end

return checkRuntime