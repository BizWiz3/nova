local fs = require("@lune/fs")
local luau = require("@lune/luau")
local Types = require("./types")

local moduleCache = {}

local LuneFs = {} :: Types.FsAdapter

function LuneFs.isFile(path: string)
    return fs.isFile(path)
end

function LuneFs.readFile(path: string)
    return fs.readFile(path)
end

function LuneFs.writeFile(path: string, contents: string)
    return fs.writeFile(path, contents)
end

function LuneFs.isDir(path: string)
    return fs.isDir(path)
end

function LuneFs.readDir(path: string)
    return fs.readDir(path)
end

function LuneFs.metadata(path: string)
    return fs.metadata(path) :: any
end

-- Helper to normalize and join paths properly
local function resolvePath(baseDir: string, target: string): string
    -- If it's not a relative path, return as is (for absolute or @lune paths)
    if not target:find("^%.") then
        return target
    end

    local segments = baseDir:split("/")
    -- Remove the last empty segment if baseDir ended in /
    if segments[#segments] == "" then table.remove(segments) end

    for _, segment in target:split("/") do
        if segment == ".." then
            table.remove(segments)
        elseif segment ~= "." and segment ~= "" then
            table.insert(segments, segment)
        end
    end

    return table.concat(segments, "/")
end

function LuneFs.loadModule(path: string): any
    -- 1. Ensure we have a clean path without double .luau
    local cleanPath = path:gsub("%.luau$", ""):gsub("%.lua$", "")
    local fullPath = cleanPath .. ".luau"

    if moduleCache[fullPath] then
        return moduleCache[fullPath]
    end

    -- 2. Read the file with explicit error handling
    local readSuccess, source = pcall(fs.readFile, fullPath)
    if not readSuccess then
        -- This will tell you if it's looking for 'route.luau.luau' or a wrong path
        error(`[LuneFs] File not found: {fullPath}`)
    end

    local bytecode = luau.compile(source)

    -- 3. Injected Environment
    local env = {
        require = function(targetPath: string)
            -- If it's a relative path, resolve it against the CURRENT module's directory
            if targetPath:sub(1, 1) == "." then
                local currentDir = fullPath:match("(.*[/\\])") or "./"
                local resolved = resolvePath(currentDir, targetPath)
                return LuneFs.loadModule(resolved)
            end
            
            -- Fallback for @lune/ built-ins
            return require(targetPath) :: any
        end
    }

    local fn = luau.load(bytecode, {
        debugName = fullPath,
        environment = env,
        injectGlobals = true,
    })

    local success, result = pcall(fn)
    if not success then
        error(`Failed to load module '{fullPath}':\n{result}`)
    end

    moduleCache[fullPath] = result
    return result
end

return LuneFs
