
export type NetRequest = {
    path: string,
    query: {[string]: string?},
    method: "GET" | "POST" | "PATCH" | "PUT" | "DELETE" | "HEAD" | "OPTIONS",
    headers: {[string]: string}?,
    body: string
}

export type FetchParams = {
    url: string,
    options: {any}?,
    query: {[string]: string?},
    method: "GET" | "POST" | "PATCH" | "PUT" | "DELETE" | "HEAD" | "OPTIONS",
    headers: {[string]: string}?,
    body: string
}

export type FetchResponse = {
    ok: boolean, 
    statusCode: number, 
    statusMessage: string, 
    headers: {[string]: string}?,
    body: string | buffer | nil
} 

export type NetResponse = {
    status: number,
    headers: {[string]: string}?,
    body: string | buffer | nil
}

export type NetConfig = {
    address: string?,
    handleRequest: Handler,
    handleWebSocket: ((ws: any) -> ())?
}

export type Handler = (request: NetRequest) -> NetResponse

export type NetAdapter = {
    serve: (port: number, handlerOrConfig: Handler | NetConfig) -> (),
    request: (config: FetchParams | string) -> FetchResponse
}

return {}
