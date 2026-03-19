local Nova = require("../../../../src/index")

local Bench = {}

function Bench.Get() 
    return Nova.response.json({ msg = "Hello, from Bench" })
end

return Bench