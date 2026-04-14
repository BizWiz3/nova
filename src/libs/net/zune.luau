local http = zune.net.http
local Types = require("./types")
local normalizeHeader = require("../normalizeHeader")

local ZuneNet = {} :: Types.NetAdapter

function ZuneNet.serve(port, handlerOrConfig)
    if not (typeof(handlerOrConfig) == "table") then return end

    http.serve({
        port = port,
        address = handlerOrConfig.address,
        request = function(request)
            local res = handlerOrConfig.handleRequest(request :: any)

            if typeof(res) == "string" then
                return {
                    status_code = 200,
                    body = res
                }
            end

            local normalizedHeaders = {}

            if not res.headers then
                normalizedHeaders = res.headers
            else
                for header, value in pairs(res.headers) do
                    local newHeader = normalizeHeader(header)
                    normalizedHeaders[newHeader] = value
                end
            end

            return {
                status_code = res.status,
                headers = normalizedHeaders,
                body = res.body
            }
        end
    })
end

function ZuneNet.request(config: Types.FetchParams | string)
    if typeof(config) == "table" and config.url then
        return http.request(config.url, {
            headers = config.headers,
            method = config.method,
            body = config.body,
            
        })
    end

    return http.request(config)
end

return ZuneNet