local Nova = require("../../../src/index")

local Home = {}

function Home.Get(req: Nova.Request)
    
    return Nova.response.json({ msg = "Hello World", body = req.body })
end

return Home