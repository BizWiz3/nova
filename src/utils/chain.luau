--!optimize 2

type Middleware = (req: any, next: () -> ()) -> any?
type Handler = (req: any) -> any

local function chain(middlewares: { Middleware }?, finalHandler: Handler)
    -- GUARD CLAUSE: 
    -- If middlewares is nil (not passed), default to an empty table {}.
    -- This prevents the "attempt to index nil" error.
    local queue = middlewares or {}

    return function(req: any)
        local index = 1
        local finalResponse = nil

        local function runNext()
            local currentIndex = index
            
            -- Now we read from 'queue', which is guaranteed to be a table.
            local middleware = queue[currentIndex]
            index += 1 

            if middleware then
                local nextCalled = false

                local function nextFn()
                    if nextCalled then
                        error(`[Nova] next() was called multiple times in middleware #{currentIndex}`)
                    end
                    nextCalled = true
                    runNext()
                end

                local result = middleware(req, nextFn)
                
                if result ~= nil then
                    finalResponse = result
                elseif not nextCalled then
                    error(`[Nova] Middleware at index {currentIndex} failed to call next() or return a response!`)
                end
            else
                -- If queue is empty, we land here immediately.
                -- This executes the router (finalHandler).
                local result = finalHandler(req)
                
                if result ~= nil then
                    finalResponse = result
                else
                    error("[Nova] Final route handler did not return a response!")
                end
            end
        end

        runNext()
        return finalResponse
    end
end

return chain
