-- Output a message to both the console and the log.
---@param message string
function ChallengeAPI.Log(message)
    -- It's pronounced "chah-lah-pee"
    local output = '[ChalAPI] ' .. message
    Isaac.ConsoleOutput(output .. '\n')
    Isaac.DebugString(output)
end
