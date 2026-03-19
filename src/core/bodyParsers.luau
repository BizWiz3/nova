local serde = require("@lune/serde")
local warn = require("../utils/warn")

type BodyParsers = { [string]: (raw: string) -> string | {any}}

local BodyParsers: BodyParsers = {}

BodyParsers["text/plain"] = function(raw: string) 
    return raw 
end

BodyParsers["application/json"] = function(raw: string)
    local success, result = pcall(function()
        return serde.decode("json", raw)
    end)
    if not success then
        warn("Failed to decode JSON body")
        return {""}
    end
    return result
end

BodyParsers["application/x-www-form-urlencoded"] = function(raw: string)
    local data: {[string]: string | {string}} = {}

    local function cleanData(str: string) 
        return string.gsub(str, "%%(%x%x)", function(hex)
            return string.char(tonumber(hex, 16) :: number)
        end)
    end

    for key, value in string.gmatch(raw, "([^&=]+)=([^&]*)") do
        local decodedKey = cleanData(key)
        local decodedValue = cleanData(value :: string)
        
        if data[decodedKey] then
            if typeof(data[decodedKey]) == "table" then
                table.insert(data[decodedKey] :: {string}, decodedValue)
            else
                data[decodedKey] = {data[decodedKey] :: string, decodedValue}
            end
        else
            data[decodedKey] = decodedValue
        end
    end
    print(data)
    return data 
end

return BodyParsers
