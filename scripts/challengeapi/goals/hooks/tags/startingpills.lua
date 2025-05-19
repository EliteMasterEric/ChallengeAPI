-- Fixes to the `startingpill` XML tag.

local function onChallengeStart(_mod, challenge, isContinue)
    if not ChallengeAPI:AreHooksActive() then
        return
    end

    if not isContinue then
        if #challenge.startingPills > 1 then
            -- Ensure additional pills get spawned.

            for index, pillEffect in ipairs(challenge.startingPills) do
                if index == 1 then
                    -- Base game handles this already.
                else
                    ChallengeAPI.Log("Spawning additional starting pill: ", pillEffect)
                    if pillEffect == PillEffect.PILLEFFECT_NULL then
                        ChallengeAPI.Util.SpawnRandomPill()
                    else
                        ChallengeAPI.Util.SpawnPillByEffect(pillEffect)
                    end
                end
            end
        end
    end
end

ChallengeAPI:AddCallback(ChallengeAPI.Enum.Callbacks.CALLBACK_CHALLENGE_STARTED, onChallengeStart)
