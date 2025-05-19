-- Register all vanilla goals with the ChallengeAPI.
-- Information is implemented by hand.
function ChallengeAPI:RegisterVanillaGoals()
   -- Defeat Mom in Depths/Necropolis/Dank Depths.
   local mom = ChallengeAPI:RegisterGoal("mom", "Mom", LevelStage.STAGE3_2, ChallengeAPI.Enum.GoalAltPaths.DEVIL, ChallengeAPI.Enum.GoalSecretPaths.NORMAL, false)
   mom:SetEIDIcon("{{MomBoss}}")
   mom:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/mom.png"), 16, 16)

   -- Defeat Mom's Heart in Womb/Utero/Scarred Womb
   local momsHeart = ChallengeAPI:RegisterGoal("moms-heart", "Mom's Heart", LevelStage.STAGE4_2, ChallengeAPI.Enum.GoalAltPaths.DEVIL, ChallengeAPI.Enum.GoalSecretPaths.NORMAL, false)
   momsHeart:SetEIDIcon("{{MomsHeart}}")
   momsHeart:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/moms-heart.png"), 16, 16)

   -- Defeat Satan in Sheol
   local satan = ChallengeAPI:RegisterGoal("satan", "Satan", LevelStage.STAGE5, ChallengeAPI.Enum.GoalAltPaths.DEVIL, ChallengeAPI.Enum.GoalSecretPaths.NORMAL, false)
   satan:SetEIDIcon("{{Satan}}")
   satan:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/satan.png"), 16, 16)

   -- Defeat Isaac in Cathedral
   local isaac = ChallengeAPI:RegisterGoal("isaac", "Isaac", LevelStage.STAGE5, ChallengeAPI.Enum.GoalAltPaths.ANGEL, ChallengeAPI.Enum.GoalSecretPaths.NORMAL, false)
   isaac:SetEIDIcon("{{Isaac}}")
   isaac:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/isaac.png"), 16, 16)

   -- Defeat The Lamb in Dark Room
   local theLamb = ChallengeAPI:RegisterGoal("the-lamb", "The Lamb", LevelStage.STAGE6, ChallengeAPI.Enum.GoalAltPaths.DEVIL, ChallengeAPI.Enum.GoalSecretPaths.NORMAL, false)
   theLamb:SetEIDIcon("{{TheLamb}}")
   theLamb:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/the-lamb.png"), 16, 16)

   -- Defeat ??? in Chest
   local blueBaby = ChallengeAPI:RegisterGoal("blue-baby", "???", LevelStage.STAGE6, ChallengeAPI.Enum.GoalAltPaths.ANGEL, ChallengeAPI.Enum.GoalSecretPaths.NORMAL, false)
   blueBaby:SetEIDIcon("{{BlueBaby}}")
   blueBaby:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/blue-baby.png"), 16, 16)

   -- Defeat Mega Satan in Dark Room
   local megaSatan = ChallengeAPI:RegisterGoal("mega-satan", "Mega Satan", LevelStage.STAGE7, ChallengeAPI.Enum.GoalAltPaths.DEVIL, ChallengeAPI.Enum.GoalSecretPaths.NORMAL, true)
   megaSatan:SetEIDNotes({"Fight in Dark Room"})
   megaSatan:SetEIDIcon("{{MegaSatan}}")
   megaSatan:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/mega-satan.png"), 16, 16)

   -- Defeat Mother in Corpse
   local mother = ChallengeAPI:RegisterGoal("mother", "Mother", LevelStage.STAGE4_2, ChallengeAPI.Enum.GoalAltPaths.DEVIL, ChallengeAPI.Enum.GoalSecretPaths.SECRET, false)
   mother:SetEIDIcon("{{Mother}}")
   mother:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/mother.png"), 16, 16)

   -- Defeat The Beast in Home
   local beast = ChallengeAPI:RegisterGoal("beast", "The Beast", LevelStage.STAGE8, ChallengeAPI.Enum.GoalAltPaths.BOTH, ChallengeAPI.Enum.GoalSecretPaths.NORMAL, false)
   -- TODO: Switch this back after EID updates
   -- beast:SetEIDIcon("{{Beast}}")
   beast:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/beast.png"), 16, 16, true)
   beast:SetMustFightBeast(true)
   beast:SetMomDoorMode(ChallengeAPI.Enum.GoalMomDoorMode.KEEP_OPEN)
end

-- Register some basic custom goals that are easy to define by hand.
function ChallengeAPI:RegisterAdditionalGoals()
   -- Defeat the boss of Basement 1/.
   local basement1 = ChallengeAPI:RegisterGoal("basement-1", "Basement 1", LevelStage.STAGE1_1, ChallengeAPI.Enum.GoalAltPaths.DEVIL, ChallengeAPI.Enum.GoalSecretPaths.NORMAL, false)

   -- Defeat Mega Satan in Chest
   -- Note that I RULE and Ultra Hard (the base game challenges that require fighting Mega Satan) both have you fight him in the Dark Room.
   local megaSatanChest = ChallengeAPI:RegisterGoal("mega-satan-chest", "Mega Satan", LevelStage.STAGE7, ChallengeAPI.Enum.GoalAltPaths.ANGEL, ChallengeAPI.Enum.GoalSecretPaths.NORMAL, true)
   megaSatanChest:SetEIDNotes({"Fight in Chest"})
   megaSatanChest:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/mega-satan.png"), 16, 16)   
end
