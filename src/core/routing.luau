--!optimize 2
--!native

local Types = require("../types")
local Response = require("../utils/response")
local BodyParsers = require("./bodyParsers")

local staticRoutes: { [string]: any } = {}

type RouteNode = {
    children: { [string]: RouteNode },
    dynamicChild: RouteNode?,
    dynamicName: string?,
    module: any?
}

local routeTreeRoot: RouteNode = {
    children = {},
    dynamicChild = nil,
    dynamicName = nil,
    module = nil
}

local function splitPath(path: string)
    local segments = {}
    for segment in path:gmatch("[^/]+") do
        table.insert(segments, segment)
    end
    return segments
end

local function createNode(): RouteNode
    return { children = {}, dynamicChild = nil, dynamicName = nil, module = nil }
end

local function registerRoute(path: string, module: any)
    if not path:match("%[.-%]") then
        staticRoutes[path] = module
        return
    end

    local segments = splitPath(path)
    local currentNode = routeTreeRoot

    for _, segment in ipairs(segments) do
        local paramName = segment:match("^%[(.+)%]$")
        
        if paramName then
            if not currentNode.dynamicChild then
                currentNode.dynamicChild = createNode()
                currentNode.dynamicName = paramName
            end
            
            currentNode = currentNode.dynamicChild :: RouteNode
        else
            if not currentNode.children[segment] then
                currentNode.children[segment] = createNode()
            end
            currentNode = currentNode.children[segment]
        end
    end
    
    currentNode.module = module
end

local function routerDispatcher(request: Types.Request)
    local cleanPath = request.path
    if #cleanPath > 1 and cleanPath:sub(-1) == "/" then
        cleanPath = cleanPath:sub(1, -2)
    end

    local method = request.method:sub(1, 1):upper() .. request.method:sub(2):lower()

    local rawBody = request.body or ""
    local decodedBody = {}

    if #rawBody > 0 then
        if not request.headers then 
            return Response.json({ error = "Conflict" }, { status = 409 })
        end

        local rawType = request.headers["content-type"] or ""
        local cleanType = rawType:split(";")[1]
        local parser = BodyParsers[cleanType]

        if not parser then 
            return Response.json({ error = "Unsupported Media Type" }, { status = 415 })
        end

        decodedBody = parser(rawBody :: string)
    end

    local req = {
        method = request.method,
        path = cleanPath,
        body = decodedBody,
        headers = request.headers,
        query = request.query or {},
        params = {}
    } :: Types.Request

    local staticModule = staticRoutes[cleanPath]
    if staticModule then
        local handler = staticModule[method]

        if method == "Head" and not handler then
            handler = staticModule["Get"]
        end

        if type(handler) == "function" then
            local fn = handler :: (Types.Request) -> any
            return fn(req)
        else
            return Response.json({ error = "Method Not Allowed" }, { status = 405 })
        end
    end

    local segments = splitPath(cleanPath)
    local currentNode = routeTreeRoot

    for _, segment in ipairs(segments) do
        if currentNode.children[segment] then
            currentNode = currentNode.children[segment]
        elseif currentNode.dynamicChild then
            req.params[currentNode.dynamicName :: string] = segment
            currentNode = currentNode.dynamicChild :: RouteNode
        else
            return Response.json({ error = "Not Found" }, { status = 404 })
        end
    end

    local matchedModule = currentNode.module
    if not matchedModule then 
        return Response.json({ error = "Not Found" }, { status = 404 }) 
    end

    local handler = matchedModule[method]

    if method == "Head" and not handler then
        handler = matchedModule["Get"]
    end

    if type(handler) ~= "function" then 
        return Response.json({ error = "Method Not Allowed" }, { status = 405 })
    end

    local fn = handler :: (Types.Request) -> any
    return fn(req)
end

return { 
    registerRoute = registerRoute, 
    routerDispatcher = routerDispatcher 
}
