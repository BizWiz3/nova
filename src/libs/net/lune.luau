local net = require("@lune/net")
local Types = require("./types")

local LuneNet = {} :: Types.NetAdapter

function LuneNet.serve(port, handlerOrConfig)
    net.serve(port, handlerOrConfig :: any)
end

function LuneNet.request(config)
    return net.request(config :: any) :: any
end

return LuneNet
