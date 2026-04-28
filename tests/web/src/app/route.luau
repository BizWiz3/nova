local Nova = require("@nova")

local Home = {}

function Home.Get()
    return Nova.response.json("Hello, World")
end

return Home
