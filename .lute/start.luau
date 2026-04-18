local process = require("@lute/process")

local running = process.run( { "lute", "run", "src/index" }, { stdio = "inherit", cwd = "ci" })

if not running.ok then 
    print(running.stderr)
end