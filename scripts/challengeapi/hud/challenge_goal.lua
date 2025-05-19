ChallengeAPI.GoalHUD = {
    initialized = false,

    hudSprite = nil,
}

local function onChallengeStart(_mod, challenge, isContinue)
    if challenge == nil then
        ChallengeAPI.Log("Player started a challenge, but it hasn't been registered!")
        if ChallengeAPI.challenges:GetLength() == 0 then
            ChallengeAPI.Log("NOTE: No challenges registered. Did you forget to initialize them?")
        end
        return
    end

    local goal = challenge:FetchGoal()
    if goal == nil then
        ChallengeAPI.Log("Challenge started, but goal couldn't be retrieved!")
        return
    end

    -- ChallengeAPI.Log("We are in challenge: " .. challenge.name)
    -- ChallengeAPI.Log("The goal is: " .. goal.name)

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
    -- A hard-coded value I determined by hand.
    -- We may need to conditionally offset this value.
    local basePos = Vector(36, 86)

    -- Adding ScreenShakeOffset to ensure the icon shakes with the rest of the HUD.
    return basePos + Game().ScreenShakeOffset
end

local function shouldRenderHUD()
    -- Is the HUD initialized?
    if not ChallengeAPI.GoalHUD.initialized then
        return false
    end

    -- Is the HUD hidden by a cutscene?
    if not Game():GetHUD():IsVisible() then
        return false
    end

    -- Is the HUD hidden by an easter egg seed?
    if Game():GetSeeds():HasSeedEffect(SeedEffect.SEED_NO_HUD) then
        return false
    end    

    -- YAY!
    return true
end

local function onPostRender(_)
    -- ChallengeAPI.Log("Game is rendering...")
    if not shouldRenderHUD() then
        return
    end

    -- Do we have an icon to render?
    local goalIcon = ChallengeAPI.GoalHUD.hudSprite
    if goalIcon == nil then
        return
    end

    goalIcon:Render(getGoalIconPosition())
end

ChallengeAPI:AddPriorityCallback(ChallengeAPI.Enum.Callbacks.CALLBACK_CHALLENGE_STARTED, CallbackPriority.LATE, onChallengeStart)
ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, onPreGameExit)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_RENDER, onPostRender)