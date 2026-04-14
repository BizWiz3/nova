local net = require("../../src/libs/net")
local process = require("../../src/libs/process")
local task = require("../../src/libs/task")

local Tester = {}

function Tester.describe(name, callback)
    local server = process.create("lune", { "run", "src/index" }, {
        env = process.env :: any
    })

    local ready = false
    for i = 1, 10 do
        local success = pcall(function()
            net.request("http://localhost:8080")
        end)
        if success then ready = true; break end
        task.wait(0.5)
    end

    if not ready then
        local out = server.stdout and server.stdout:read() or "no stdout"
        local err = server.stderr and server.stderr:read() or "no stderr"
        server:kill()
        error(`[{name}] Server failed to respond.\nstdout: {out}\nstderr: {err}`)
    end

    print(`--- Running: {name} ---`)

    local success, err = pcall(callback)

    server:kill()
    task.wait(0.2)

    if not success then
        error(`Test Suite [{name}] failed: {err}`)
    else
        print(`✅ {name} passed.`)
    end
end

return Tester