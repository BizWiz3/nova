-- Normalizes an HTTP header key to a consistent Pascal-Case format (e.g., "content-type" -> "Content-Type").
local function normalizeHeader(header: string): string
    local parts = string.split(header, "-")
    local normalizedParts = {}

    for i, part in ipairs(parts) do
        if #part > 0 then
            normalizedParts[i] = part:sub(1, 1):upper() .. part:sub(2):lower()
        else
            normalizedParts[i] = ""
        end
    end

    return table.concat(normalizedParts, "-")
end

return normalizeHeader
