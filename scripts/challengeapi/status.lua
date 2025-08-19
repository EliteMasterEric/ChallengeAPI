ChallengeAPI.Status = {
    -- Represents the "real" current challenge.
    -- This is used to maintain the HUD if we temporarily switch challenges to mess with game logic.
    -- For example, we switch to CHALLENGE_NULL to make the game spawn the Strange Door,
    -- or enable XXXXXXXXL or Red Redemption to modify floor generation.
    ---@type Challenge
    currentChallenge = nil
}

--- Returns true if we are currently in a challenge.
--- @return boolean
function ChallengeAPI:IsInChallenge()
    return Game().Challenge > 0 or (ChallengeAPI.Status.currentChallenge ~= nil and ChallengeAPI.Status.currentChallenge > 0)
end

--- Fetch the data for the active challenge.
--- Will return nil if we are not in a challenge right now.
--- @return ChallengeParams?
function ChallengeAPI:GetCurrentChallenge()
    if (ChallengeAPI.Status.currentChallenge ~= nil and ChallengeAPI.Status.currentChallenge > 0) then
        return ChallengeAPI:GetChallengeById(ChallengeAPI.Status.currentChallenge)
    end

    local challenge = Game().Challenge
    if challenge == 0 then
        ChallengeAPI.Log("(getCurrentChallenge) Not in challenge!")
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

-- Switch the game to a different challenge, permanently.
-- This updates the HUD display and stuff.
---@param target Challenge The new challenge to use, as an enum ID.
function ChallengeAPI:SetChallenge(target)
    local challenge = ChallengeAPI:GetChallengeById(target)
    if challenge == nil then
        -- Challenge couldn't be fetched, cancelling set.
        return
    end

    Game().Challenge = target
    ChallengeAPI.Status.currentChallenge = nil

    Isaac.RunCallbackWithParam(ChallengeAPI.Enum.Callbacks.CALLBACK_CHALLENGE_STARTED, target, challenge, true)
end

-- Switch the game to a different challenge temporarily.
-- This affects things like level generation, and can mess with ChallengeAPI if you aren't careful.
---@param target Challenge The new challenge to use.
function ChallengeAPI:SwitchChallenge(target)
    if (ChallengeAPI.Status.currentChallenge == nil or ChallengeAPI.Status.currentChallenge == 0) then
        ChallengeAPI.Status.currentChallenge = Game().Challenge
    end

    Game().Challenge = target
end

-- Revert the game back to the previous challenge, if we had swapped to one temporarily.
function ChallengeAPI:RevertChallenge()
    if ChallengeAPI.Status.currentChallenge ~= nil then
        -- ChallengeAPI.Log("Reverting to challenge: ", ChallengeAPI.Status.currentChallenge)
        Game().Challenge = ChallengeAPI.Status.currentChallenge
        ChallengeAPI.Status.currentChallenge = nil
    end
end
