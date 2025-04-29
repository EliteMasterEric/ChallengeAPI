-- Define simple functions for flexible logging.

-- Output a message to both the console and the log.
---@param ... any
function ChallengeAPI.Log(...)
    -- It's pronounced "chah-lah-pee"
    local output = '[ChalAPI] '

    for _, arg in ipairs({...}) do
        output = output .. tostring(arg)
    end

    Isaac.ConsoleOutput(output .. '\n')
    Isaac.DebugString(output)
end
