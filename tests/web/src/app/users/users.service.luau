local UserService = {}

function UserService.getUser(userId: number)
    return {
        msg = "Hello, user " .. userId
    }
end

return UserService
