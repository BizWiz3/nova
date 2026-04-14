--!optimize 2
--!native

local net = require("../../../src/libs/net")
local serde = require("../../../src/libs/serde")
local Types = require("./types")
-- HTTP Method Enums
local METHODS = {
    POST = "POST",
    GET = "GET",
    PUT = "PUT",
    PATCH = "PATCH",
    DELETE = "DELETE"
}

local Aura = {}

function Aura.get(config: Types.AuraRequest): Types.AuraResponse
    assert(config.url, "Url not found")
    assert(typeof(config.url) == "string", "Url must be string")
    
    local displayUrl = config.url
    
    if config.headers and config.headers["Content-Type"] and not (typeof(config.headers["Content-Type"]) == "string") then
        error("Content-Type of Headers has to be string", 2)
    end

    local finalConfig = { 
        url = string.gsub(config.url, "://localhost", "://127.0.0.1"),
        method = config.method or METHODS.GET,
        headers = config.headers or { ["Content-Type"] = "application/json" },
        body = if config.body and typeof(config.body) == "table" then serde.encode("json", config.body) else config.body or "",
        query = config.query,
        options = config.options
    } :: Types.AuraRequest

    local startTime = os.clock()
    local response = net.request(finalConfig :: net.FetchParams)
    local endTime = os.clock()

    local duration = endTime - startTime

    local success, decodedBody = pcall(function()
        return serde.decode("json", response.body :: string)
    end)

    local finalResponse: Types.AuraResponse = {
        ok = response.ok,
        status = response.statusCode,
        statusMessage = response.statusMessage,
        headers = response.headers :: { [string]: string },
        body = if success then decodedBody else response.body,
        responseTime = duration
    }

    if not finalResponse.ok then
        local color = if finalResponse.status >= 400 then "\27[31m" elseif finalResponse.status >= 300 then "\27[34m" else "\27[32m"
        local reset = "\27[0m"
        
        local beautyError = string.format(
            "%s" ..
            " Aura Request got an issue:\n" ..
            "\n" ..
            " Status : %d (%s)\n" ..
            " Method : %s\n" ..
            " URL    : %s\n" ..
            " Time   : %.4f seconds\n" ..
            "\n" ..
            "%s" :: any,
            color,
            finalResponse.status, 
            finalResponse.statusMessage or "Unknown", 
            finalConfig.method or "GET", 
            displayUrl, 
            duration,
            reset
        )

        print(beautyError)
    end

    return finalResponse
end

function Aura.post(config: Types.AuraRequest): Types.AuraResponse
    config.method = METHODS.POST
    return Aura.get(config)
end

function Aura.put(config: Types.AuraRequest): Types.AuraResponse
    config.method = METHODS.PUT
    return Aura.get(config)
end

function Aura.patch(config: Types.AuraRequest): Types.AuraResponse
    config.method = METHODS.PATCH
    return Aura.get(config)
end

function Aura.delete(config: Types.AuraRequest): Types.AuraResponse
    config.method = METHODS.DELETE
    return Aura.get(config)
end

return Aura
