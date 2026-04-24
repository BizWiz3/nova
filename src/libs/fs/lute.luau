local fs = require("@lute/fs")
local Types = require("./types")

local LuteFs = {} :: Types.FsAdapter

function LuteFs.isFile(path: string)
    return fs.stat(path).type == "file"
end

function LuteFs.isDir(path: string)
    return fs.stat(path).type == "dir"
end

function LuteFs.readFile(path: string): string
    local fileHandle = fs.open(path)
    local fileContent = fs.read(fileHandle)
    fs.close(fileHandle)

    return fileContent
end

function LuteFs.writeFile(path: string, contents: string)
    local ok, err = pcall(function()
        local handle = fs.open(path, "w")
        fs.write(handle, contents)
        fs.close(handle)
    end)
    if not ok then
        error(`Failed to write file '{path}': {err}`)
    end
end

function LuteFs.readDir(path: string)
    local dirEntry: {fs.DirectoryEntry} = fs.listdir(path)
    local dirList = {}

    for i = 1, table.maxn(dirEntry) do
        table.insert(dirList, dirEntry[i].name)
    end

    return dirList
end

function LuteFs.metadata(path: string)
    local ok, stat = pcall(fs.stat, path)
    if not ok then
        error("Path not found: " .. path)
    end
    return {
        kind = stat.type :: any,
        exists = true,
        createdAt = stat.created:toSeconds(),
        modifiedAt = stat.modified:toSeconds(),
        accessedAt = stat.accessed:toSeconds(),
        permissions = {
            readOnly = stat.permissions.readonly,
        },
    }
end

return LuteFs