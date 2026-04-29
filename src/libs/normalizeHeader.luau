-- Normalizes an HTTP header key to a consistent Pascal-Case format (e.g., "content-type" -> "Content-Type").
local cache: { [string]: string } = {}

local function normalizeHeader(header: string): string
    local cached = cache[header]
    if cached then return cached end

    local normalized = header:lower():gsub("%f[%a]%a", string.upper)

    cache[header] = normalized
    return normalized
end

return normalizeHeader
