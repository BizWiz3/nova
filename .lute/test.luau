local process = require("@lute/process")

local running = process.run({"lune", "run", "tests/lune"}, { stdio = "inherit", cwd = "ci" })

if not running.ok then 
    print(running.stderr)
end