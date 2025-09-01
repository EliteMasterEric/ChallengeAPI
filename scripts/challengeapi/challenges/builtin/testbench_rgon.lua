
local CHALLENGE_TESTBENCH_RGON = Isaac.GetChallengeIdByName("[CAPI] Test - Repentogon")

local function onChallengeAPILoad(_mod)
    local challenge = nil

    if not ChallengeAPI.IsREPENTOGON then
        -- We need to register the challenge ourselves if REPENTOGON is not loaded to do it for us.

        -- Specify starting character and goal.
        challenge = ChallengeAPI:RegisterChallenge(CHALLENGE_TESTBENCH_RGON, "[CAPI] Test - Repentogon", PlayerType.PLAYER_ISAAC, "satan")
    else
        -- Retrieve existing challenge data.
        challenge = ChallengeAPI:GetChallengeById(CHALLENGE_TESTBENCH_RGON)
    end

    if challenge == nil then
        -- error("[700K] Challenge '[CAPI] Test - Repentogon' not found, I'm sad.")
        return
    end

    -- Lock the challenge unless REPENTOGON is installed and active
    challenge:SetRequiresRepentogon(true)

    -- Add hardcoded EID text
    challenge:SetEIDNotes({
        "This challenge is for testing.",
        "You shouldn't be able to play it."
    })
end

ChallengeAPI:AddCallback(ChallengeAPI.Enum.Callbacks.CALLBACK_POST_LOADED, onChallengeAPILoad)