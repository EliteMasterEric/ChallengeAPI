ChallengeAPI.GoalHUD = {
    initialized = false,

    hudSprite = nil,
}

local function onPostGameStarted(_)
    ChallengeAPI.Log("New run started. Checking for challenge status...")

    if not ChallengeAPI:IsInChallenge() then
        ChallengeAPI.Log("Not in a challenge.")
        return
    end

    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        ChallengeAPI.Log("ERROR: Couldn't determine current challenge.")
        if ChallengeAPI.challenges:GetLength() == 0 then
            ChallengeAPI.Log("NOTE: No challenges registered. Did you forget to initialize them?")
        end
        return
    end

    local goal = challenge:FetchGoal()
    if goal == nil then
        ChallengeAPI.Log("ERROR: Couldn't determine current goal.")
        return
    end

    ChallengeAPI.Log("We are in challenge: " .. challenge.name)
    ChallengeAPI.Log("The goal is: " .. goal.name)

    local goalIcon = goal.goalIcon

    if goalIcon == nil then
        ChallengeAPI.Log("Goal icon is not defined.")
        return
    end

    ChallengeAPI.GoalHUD.hudSprite = goalIcon

    ChallengeAPI.GoalHUD.initialized = true
end

local function onPreGameExit(_)
    ChallengeAPI.Log("Game is ending...")

    ChallengeAPI.GoalHUD.hudSprite = nil
    ChallengeAPI.GoalHUD.initialized = false
end

local function getGoalIconPosition()
    return Vector(36, 86)
end

local function onPostRender(_)
    -- ChallengeAPI.Log("Game is rendering...")
    if not ChallengeAPI.GoalHUD.initialized then
        return
    end

    local goalIcon = ChallengeAPI.GoalHUD.hudSprite
    if goalIcon == nil then
        return
    end

    goalIcon:Render(getGoalIconPosition())
end

ChallengeAPI:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.LATE, onPostGameStarted)
ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, onPreGameExit)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_RENDER, onPostRender)