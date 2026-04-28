local Nova = require("@nova")
local UserService = require("./users.service")

local Users = {}

function Users.Get()
    return Nova.response.json(UserService.getUser(123))
end

return Users
