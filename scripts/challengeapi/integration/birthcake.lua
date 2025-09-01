
-- TODO: This code should probably be part of Birthcake.
function ChallengeAPI:Birthcake_EnableIntegration()
    ---@diagnostic disable-next-line: undefined-global
    if BirthcakeRebaked ~= nil then
        ChallengeAPI.Log("Enabling Birthcake (Rebaked) integration...")

        -- Register custom challenges

        -- Isaac's Birthday Party
        local isaacsBirthdayParty = Isaac.GetChallengeIdByName("Isaac's Birthday Party")
        local isaacsBirthdayPartyChallenge = ChallengeAPI:RegisterChallenge(isaacsBirthdayParty, "Isaac's Birthday Party",
            PlayerType.PLAYER_ISAAC, "beast")

        -- Disable custom Beast hooks to prevent conflicts with THEIR custom beast hooks.
        isaacsBirthdayPartyChallenge:SetEnableHooks(false)

        -- NOTE: Starting trinkets defined in the config are added automatically
        -- if you are on REPENTOGON. But if you want your mod to support players without RGON,
        -- or your mod adds trinkets without using the challenges.xml file,
        -- you have to add them to ChallengeAPI's challenge data manually.
        isaacsBirthdayPartyChallenge:SetStartingTrinkets({
            Isaac.GetTrinketIdByName("Birthcake")
        })

        ChallengeAPI.Log(tostring(table.concat(isaacsBirthdayPartyChallenge.startingTrinkets, "#")))

        isaacsBirthdayPartyChallenge:SetEIDNotes({
            "Switch characters when switching floors",
        })
    else
        ChallengeAPI.Log("No Birthcake found, skipping...")
    end
end