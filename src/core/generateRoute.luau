local fs = require("../libs/fs")
local process = require("../libs/process")
local routing = require("./routing") 

local function generateRoute(currentDir: string, currentRoute: string)
    local resolvedDir = currentDir:gsub("@c/", process.cwd .. "/")
    local items = fs.readDir(resolvedDir)

    for _, item in ipairs(items) do
        local path = currentDir .. "/" .. item
        local resolvedPath = path:gsub("@c/", process.cwd .. "/")

        if item == "route.luau" then 
            local modulePath = currentDir .. "/route"
            
            local routeKey = currentRoute == "" and "/" or currentRoute
            
            local routeModule = require(modulePath) :: string

            routing.registerRoute(routeKey, routeModule)
            
            --stdio.write(stdio.color("green"))
            print("Registered Route: " .. routeKey)
            --stdio.write(stdio.color("reset"))

        elseif fs.metadata(resolvedPath).kind == "dir" or fs.metadata(resolvedPath).kind == "directory" then
            local nextRoute = currentRoute .. "/" .. item
            generateRoute(path, nextRoute)
        end
    end
end

return generateRoute