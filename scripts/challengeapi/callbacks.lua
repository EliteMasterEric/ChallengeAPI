ChallengeAPI.Enum.Callbacks = {
    -- Callback has no arguments. Called after the mod is loaded.
    CALLBACK_POST_LOADED = "CHALLENGEAPI_POST_LOADED",

    -- (ChallengeParams challengeData) - Called after a new challenge is registered. You may modify the data, but can't prevent registration.
    CALLBACK_POST_CHALLENGE_REGISTERED = "CHALLENGEAPI_POST_CHALLENGE_REGISTERED",

    -- (Goal goalData) - Called after a new goal is registered. You may modify the data, but can't prevent registration.
    CALLBACK_POST_GOAL_REGISTERED = "CHALLENGEAPI_POST_GOAL_REGISTERED",

    -- (ChallengeParams challenge, boolean isContinued) | Optional Arg: int challengeId - Called after a specific challenge is started.
    CALLBACK_CHALLENGE_STARTED = "CHALLENGEAPI_CHALLENGE_STARTED",
}

local function onGameStart(_mod, isContinue)
    if (ChallengeAPI:IsInChallenge()) then
        local challenge = ChallengeAPI:GetCurrentChallenge()

        if challenge == nil then
            ChallengeAPI.Log("Challenge started, but it hasn't been registered!")
            return
        end

        Isaac.RunCallbackWithParam(ChallengeAPI.Enum.Callbacks.CALLBACK_CHALLENGE_STARTED, challenge.id, challenge, isContinue)
    end
end

local function doCleanup()
    -- If we swapped challenges for compatibility reasons,
    -- ensure we swap back before exiting so the game remembers where we were.
    if ChallengeAPI.Status.currentChallenge ~= nil then
        ChallengeAPI:RevertChallenge()
    end
end

local function onPreGameExit(_mod, shouldSave)
    doCleanup()
end

local function onPreModUnload(mod)
    -- Called when ANY mod is unloaded. We have to check first.
    if mod == ChallengeAPI then
        ChallengeAPI.Log("ChallengeAPI unloaded?")
        doCleanup()
    end
end

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onGameStart)
ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, onPreGameExit)
ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_MOD_UNLOAD, onPreModUnload)