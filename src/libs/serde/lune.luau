local serde = require("@lune/serde")
local Types = require("./types")

local LuneSerde = {} :: Types.SerdeAdapter

function LuneSerde.decode(format, encoded)
    return serde.decode(format, encoded)
end

function LuneSerde.encode(format, value, pretty)
    return serde.encode(format, value, pretty)
end

return LuneSerde
