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

