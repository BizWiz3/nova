export type RequestWith<T> = {
    method: string,
    path: string,
    body: {any},
    headers: {any},
    params: T,
    query: T
}

export type Request = RequestWith<{any}>

export type ResponseBody = {any} | string

export type ResponseOptions = {
    status: number?,
    isHtml: boolean?,
    headers: { [string]: string }?
}

export type Next = () -> ()

export type Nova = {
    --[[
        This is the listen handler
    ]]
    listen: (self: Nova, handler: () -> ()) -> ()
}

return {}
