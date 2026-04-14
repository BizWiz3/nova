local serde = zune.serde
local Types = require("./types")

local LuneSerde = {} :: Types.SerdeAdapter

local encoders = {
    json = serde.json.encode,
    toml = serde.toml.encode,
    yaml = serde.yaml.encode,
}

local decoders = {
    json = serde.json.decode,
    toml = serde.toml.decode,
    yaml = serde.yaml.decode,
}

function LuneSerde.decode(format, encoded)
    local decoder = decoders[format]

    if not decoder then
        error(`Unsupported format: "{format}"`)
    end

    return decoder(encoded)
end

function LuneSerde.encode(format, value, pretty)
    local encoder = encoders[format]

    if not encoder then
        error(`Unsupported format: "{format}"`)
    end

    return encoder(value)
end

return LuneSerde
