local process = zune.process
local serde = require("../src/libs/serde")
local fs = require("../src/libs/fs")

local luaurcPath = process.cwd() .. "/.luaurc"
local luaurcjson = fs.readFile(luaurcPath)
local decode = serde.decode("json", luaurcjson)

if not decode.aliases then
    decode.aliases = {}
end

local newCAlias = process.cwd() .. "/tests/web/"

if not (newCAlias == decode.aliases.c) then
    decode.aliases.c = newCAlias
end

local encode = serde.encode("json", decode, true)
fs.writeFile(luaurcPath, encode)


process.run("zune", { "run", "src/main", "dev" }, { stderr = "inherit", stdout = "inherit", cwd = "tests/web" })