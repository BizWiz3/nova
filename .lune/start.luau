local process = require("@lune/process")

local running = process.exec("lune", { "run", "src/index" }, { stdio = "inherit", cwd = "ci" })

if not running.ok then 
    print(running.stderr)
end