local Nova = require("@nova")
local process = require("../../../src/libs/process")
--local process = zune.process

local PORT = tonumber(process.env.PORT) or 8080
local app = Nova.new(PORT)

app:listen(function()
    print(`Nova is running on Port {PORT}`)
end)
