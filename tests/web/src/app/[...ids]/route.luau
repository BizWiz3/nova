local Nova = require("@nova")

local Home = {}

function Home.Get(req: Nova.RequestWith<{ ids: { string } }>)
    local userIds = req.params.ids
    return Nova.response.json({ userIds = userIds, msg = "Found user IDs" })
end

return Home
