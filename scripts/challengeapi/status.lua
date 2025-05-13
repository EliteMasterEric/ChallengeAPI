--- Returns true if we are currently in a challenge.
--- @return boolean
function ChallengeAPI:IsInChallenge()
    return Game().Challenge > 0
end

--- Fetch the data for the active challenge.
--- Will return nil if we are not in a challenge right now.
--- @return ChallengeParams?
function ChallengeAPI:GetCurrentChallenge()
    local challenge = Game().Challenge
    if challenge == 0 then
        return nil
    end

    -- ChallengeAPI.Log("Current challenge id: " .. challenge)

    return ChallengeAPI:GetChallengeById(challenge)
end

--- Fetch the challenge goal corresponding to the active challenge.
--- Will return nil if we are not in a challenge right now.
--- @return Goal?
function ChallengeAPI:GetCurrentChallengeGoal()
    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        return nil
    end

    return challenge:FetchGoal()
end

-- Returns true if any of ChallengeAPI's hooks should be used for this challenge.
-- Use challenge:SetEnableHooks(false) to disable ALL custom tweaks and bug fixes
-- provided by ChallengeAPI. Useful for maintaining mod compatibility.
function ChallengeAPI:AreHooksActive()
    local challenge = ChallengeAPI:GetCurrentChallenge()
    -- If we aren't in a challenge, no hooks.
    if challenge == nil then
        return false
    end

    return challenge.enableHooks
end