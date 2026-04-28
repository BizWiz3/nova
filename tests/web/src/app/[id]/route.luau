local Nova = require("@nova")

local Home = {}

function Home.Get(banana: Nova.RequestWith<{ id: string }>)
    local userId = banana.params.id
    return Nova.response.json({ userId = userId, msg = "Found a user ID" })
end

return Home
