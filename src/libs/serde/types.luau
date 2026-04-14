export type Format = "json" | "jsonc" | "toml" | "yaml"

export type Encoded = string

export type SerdeAdapter = {
    encode: (format: Format, value: any, pretty: boolean?) -> string,
    decode: (format: Format, encoded: Encoded) -> any,
}

return {}
