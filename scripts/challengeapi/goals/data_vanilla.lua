-- Register all vanilla goals with the ChallengeAPI.
-- Information is implemented by hand.
function ChallengeAPI:RegisterVanillaGoals()
   -- Defeat Mom in Depths/Necropolis/Dank Depths.
   ChallengeAPI:RegisterGoal("mom", "Mom", LevelStage.STAGE3_2, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)

   -- Defeat Mom's Heart in Womb/Utero/Scarred Womb
   ChallengeAPI:RegisterGoal("moms-heart", "Mom's Heart", LevelStage.STAGE4_2, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)

   -- Defeat Satan in Sheol
   ChallengeAPI:RegisterGoal("satan", "Satan", LevelStage.STAGE5, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)

   -- Defeat Isaac in Cathedral
   ChallengeAPI:RegisterGoal("isaac", "Isaac", LevelStage.STAGE5, ChallengeAPI.GoalAltPaths.ANGEL, ChallengeAPI.GoalSecretPaths.NORMAL, false)

   -- Defeat The Lamb in Dark Room
   ChallengeAPI:RegisterGoal("the-lamb", "The Lamb", LevelStage.STAGE6, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)

   -- Defeat ??? in Chest
   ChallengeAPI:RegisterGoal("blue-baby", "???", LevelStage.STAGE6, ChallengeAPI.GoalAltPaths.ANGEL, ChallengeAPI.GoalSecretPaths.NORMAL, false)

   -- Defeat Mega Satan in Dark Room
   local megaSatan = ChallengeAPI:RegisterGoal("mega-satan", "Mega Satan", LevelStage.STAGE7, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, true)
   megaSatan:SetEIDNotes({"Fight in Dark Room"})

   -- Defeat Mother in Corpse
   local mother = ChallengeAPI:RegisterGoal("mother", "Mother", LevelStage.STAGE4_2, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.SECRET, false)
   mother:SetEIDNotes({"Must obtain Knife Piece 1 and Knife Piece 2"})
end

-- Register some basic custom goals that are easy to define by hand.
function ChallengeAPI:RegisterAdditionalGoals()
   -- Defeat the boss of Basement 1/.
   ChallengeAPI:RegisterGoal("basement-1", "Basement 1", LevelStage.STAGE1_1, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)

   -- Defeat Mega Satan in Chest
   -- Note that I RULE and Ultra Hard (the base game challenges that require fighting Mega Satan) both have you fight him in the Dark Room.
   local megaSatanChest = ChallengeAPI:RegisterGoal("mega-satan-chest", "Mega Satan (via Chest)", LevelStage.STAGE7, ChallengeAPI.GoalAltPaths.ANGEL, ChallengeAPI.GoalSecretPaths.NORMAL, true)
   megaSatanChest:SetEIDNotes({"Fight in Chest"})
end
