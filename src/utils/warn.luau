local stdio = require("@lune/stdio")

local function warn(T)
    stdio.write(stdio.color("yellow"))
    print(`[Warn]: {tostring(T)}`)
    stdio.write(stdio.color("reset"))
end

return warn