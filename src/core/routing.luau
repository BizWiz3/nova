local Types = require("../types")
local Response = require("../utils/response")
local BodyParsers = require("./bodyParsers")

type RouteNode = {
	children: { [string]: RouteNode },
	dynamicChild: RouteNode?,
	dynamicName: string?,
	wildcardChild: RouteNode?,
	wildcardName: string?,
	module: any?,
}

local json = Response.json

local staticRoutes: { [string]: any } = {}

local routeTreeRoot: RouteNode = {
	children = {},
	dynamicChild = nil,
	dynamicName = nil,
	module = nil,
}

local METHOD_MAP = {
	GET = "Get",
	POST = "Post",
	PUT = "Put",
	DELETE = "Delete",
	PATCH = "Patch",
	HEAD = "Head",
}

local function splitPath(path: string): { string }
	local segments = {}
	for segment in path:gmatch("[^/]+") do
		table.insert(segments, segment)
	end
	return segments
end

local function createNode(): RouteNode
	return { children = {} }
end

local function registerRoute(path: string, module: any)
	if not string.find(path, "%[") then
		staticRoutes[path] = module
		return
	end

	local segments = splitPath(path)
	local currentNode = routeTreeRoot

	for _, segment in ipairs(segments) do
		if string.byte(segment, 1) == 91 and string.byte(segment, -1) == 93 then
			local paramName = string.sub(segment, 2, -2)

			if string.sub(paramName, 1, 3) == "..." then
				local cleanName = string.sub(paramName, 4)
				if not currentNode.wildcardChild then
					currentNode.wildcardChild = createNode()
					currentNode.wildcardName = cleanName
				end
				currentNode = currentNode.wildcardChild :: RouteNode
			else
				if not currentNode.dynamicChild then
					currentNode.dynamicChild = createNode()
					currentNode.dynamicName = paramName
				end
				currentNode = currentNode.dynamicChild :: RouteNode
			end
		else
			if not currentNode.children[segment] then
				currentNode.children[segment] = createNode()
			end
			currentNode = currentNode.children[segment]
		end
	end

	currentNode.module = module
end

local function matchRouteFrom(
	node: RouteNode,
	segments: { string },
	index: number,
	params: { [string]: any }
): RouteNode?
	while index <= #segments do
		local segment = segments[index]

		if node.children[segment] then
			node = node.children[segment]
		elseif node.dynamicChild then
			if node.wildcardChild and node.wildcardChild.module then
				local dynamicParams = table.clone(params)
				dynamicParams[node.dynamicName :: string] = segment

				local result = matchRouteFrom(node.dynamicChild :: RouteNode, segments, index + 1, dynamicParams)
				if result then
					for k, v in dynamicParams do
						params[k] = v
					end
					return result
				end

				local remainingCount = #segments - index + 1
				local remaining = table.create(remainingCount)
				for i = index, #segments do
					remaining[i - index + 1] = segments[i]
				end
				params[node.wildcardName :: string] = remaining
				return node.wildcardChild
			end

			params[node.dynamicName :: string] = segment
			node = node.dynamicChild :: RouteNode
		elseif node.wildcardChild and node.wildcardChild.module then
			local remainingCount = #segments - index + 1
			local remaining = table.create(remainingCount)
			for i = index, #segments do
				remaining[i - index + 1] = segments[i]
			end
			params[node.wildcardName :: string] = remaining
			return node.wildcardChild
		else
			return nil
		end

		index += 1
	end

	if node.wildcardChild and node.wildcardChild.module then
		params[node.wildcardName :: string] = {}
		return node.wildcardChild
	end

	return node.module and node or nil
end

local function matchRoute(rootNode: RouteNode, segments: { string }, params: { [string]: any }): RouteNode?
	return matchRouteFrom(rootNode, segments, 1, params)
end

local function routerDispatcher(req: Types.Request)
	if #req.path > 1 and string.byte(req.path, -1) == 47 then
		req.path = string.sub(req.path, 1, -2)
	end

	if req.body and #req.body > 0 then
		local rawType: string = req.headers and req.headers["content-type"]
			or req.headers and req.headers["Content-Type"]
			or ""
		local cleanType = rawType:match("^([^;]+)") or ""
        local parser = BodyParsers[cleanType]
        if parser then
            req.body = (parser :: (any) -> any)(req.body)
        end
	end

	local matchedModule = staticRoutes[req.path]
	if not matchedModule then
		local segments = splitPath(req.path)
		local matchedNode = matchRoute(routeTreeRoot, segments, req.params)
		if not matchedNode or not matchedNode.module then
			return json({ error = "Not Found" }, { status = 404 })
		end
		matchedModule = matchedNode.module
	end

	local method = METHOD_MAP[req.method]
	local handler = matchedModule[method] or (method == "Head" and matchedModule.Get)

	if type(handler) ~= "function" then
		return json({ error = "Method Not Allowed" }, { status = 405 })
	end

	local fn = handler :: (Types.Request) -> any
	return fn(req)
end

local function createTestRouter()
	local staticRoutes: { [string]: any } = {}
	local root: RouteNode = { children = {} }

	return {
		registerRoute = function(path: string, module: any)
			if not string.find(path, "%[") then
				staticRoutes[path] = module
				return
			end

			local segments = splitPath(path)
			local currentNode = root

			for _, segment in ipairs(segments) do
				if string.byte(segment, 1) == 91 and string.byte(segment, -1) == 93 then
					local paramName = string.sub(segment, 2, -2)

					if string.sub(paramName, 1, 3) == "..." then
						local cleanName = string.sub(paramName, 4)
						if not currentNode.wildcardChild then
							currentNode.wildcardChild = createNode()
							currentNode.wildcardName = cleanName
						end
						currentNode = currentNode.wildcardChild :: RouteNode
					else
						if not currentNode.dynamicChild then
							currentNode.dynamicChild = createNode()
							currentNode.dynamicName = paramName
						end
						currentNode = currentNode.dynamicChild :: RouteNode
					end
				else
					if not currentNode.children[segment] then
						currentNode.children[segment] = createNode()
					end
					currentNode = currentNode.children[segment]
				end
			end

			currentNode.module = module
		end,

		matchRoute = function(path: string, params: { [string]: any })
			local cleanPath = path
			if #cleanPath > 1 and string.byte(cleanPath, -1) == 47 then
				cleanPath = string.sub(cleanPath, 1, -2)
			end

			if staticRoutes[cleanPath] then
				return staticRoutes[cleanPath]
			end

			local segments = splitPath(cleanPath)
			local node = matchRouteFrom(root, segments, 1, params)
			return node and node.module or nil
		end,
	}
end

return {
	registerRoute = registerRoute,
	routerDispatcher = routerDispatcher,
	createTestRouter = createTestRouter,
}
