
function ChallengeAPI:RegisterCurrentChallenge()
    if ChallengeAPI:IsInChallenge() then
        local currentChallengeId = Isaac.GetChallenge()
        if ChallengeAPI:IsChallengeRegistered(currentChallengeId) then
            -- We don't need to do anything.
            return
        end

        if currentChallengeId ~= Challenge.CHALLENGE_NULL then
            
        end
    end
end
    
