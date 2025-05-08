local function doBirthcakeIntegration()
    -- Register custom challenges

    -- Isaac's Birthday Party
    local isaacsBirthdayParty = Isaac.GetChallengeIdByName("Isaac's Birthday Party")
    local isaacsBirthdayPartyChallenge = ChallengeAPI:RegisterChallenge(isaacsBirthdayParty, "Isaac's Birthday Party",
        PlayerType.PLAYER_ISAAC, "beast")
    if not REPENTOGON then
        isaacsBirthdayPartyChallenge:SetStartingTrinkets({
            Isaac.GetTrinketIdByName("Birthcake")
        })
    end

    isaacsBirthdayPartyChallenge:SetEIDNotes({
        "Switch characters when switching floors",
    })

end

if BirthcakeRebaked ~= nil then
    doBirthcakeIntegration()
end
