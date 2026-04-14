export type Headers = {
    ["Content-Type"]: "application/json" | "application/x-www-form-urlencoded" | "text/plain" | string,
}

export type AuraRequest = {
    url: string?,
    method: string?,
    body: any?,
    headers: Headers?,
    query: { [string]: string }?,
    options: { [string]: any }?
}

export type AuraResponse = {
    ok: boolean,
    status: number,
    statusMessage: string,
    headers: { [string]: string },
    body: any,
    responseTime: number
}

export type Aura = {
    get: (config: AuraRequest) -> AuraResponse --((url: string) -> AuraResponse) &
}

return {}