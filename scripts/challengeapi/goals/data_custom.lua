-- Register custom challenge goals which require custom logic for ChallengeAPI to work.
function ChallengeAPI:RegisterCustomGoals()
   -- Defeat Delirium in the Void, via the Dark Room
   -- Requires custom functionality:
   --   - [] Guarantee the portal in Dark Room/Chest if Rep+ isn't enabled
   --   - [] Prevent the Chest entity from spawning (touching it ends the run without completing the challenge)
   local delirium = ChallengeAPI:RegisterGoal("delirium", "Delirium", LevelStage.STAGE7, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)
   delirium:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/delirium.png"), 16, 16)
   delirium:SetEIDNotes({"Fight via Dark Room"})

   -- Defeat Delirium in the Void, via the Chest
   -- Requires custom functionality:
   --   - [] Guarantee the portal in Dark Room/Chest if Rep+ isn't enabled
   --   - [] Prevent the Chest entity from spawning (touching it ends the run without completing the challenge)
   local deliriumChest = ChallengeAPI:RegisterGoal("delirium-chest", "Delirium", LevelStage.STAGE7, ChallengeAPI.GoalAltPaths.ANGEL, ChallengeAPI.GoalSecretPaths.NORMAL, false)
   deliriumChest:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/delirium.png"), 16, 16)
   deliriumChest:SetEIDNotes({"Fight via Chest"})

   -- Defeat Mom in Mausoleum II
   -- Requires custom functionality:
   --   - [] Disable the Womb
   local momSecret = ChallengeAPI:RegisterGoal("mom-secret", "Mom", LevelStage.STAGE4_2, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)
   momSecret:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/mom.png"), 16, 16)
   momSecret:SetEIDNotes({"Must go Downpour/Mines/Mausoleum"})

   -- Defeat Hush in ??? (Blue Womb)
   -- Requires custom functionality:
   --   - [] Auto-unlock the Hush door
   local hush = ChallengeAPI:RegisterGoal("hush", "Hush", LevelStage.STAGE7, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)
   hush:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/hush.png"), 16, 16)
   hush:SetHushMode(ChallengeAPI.GoalHushMode.ALWAYS)

   -- Defeat Hush in ??? (Blue Womb), automatically killing the player if they are not in the Hush room when the timer runs out.
   -- Requires custom functionality:
   --   - [] Auto-kill player if they run out of time
   local hushTimed = ChallengeAPI:RegisterGoal("hush-timed", "Hush", LevelStage.STAGE4_3, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)
   hushTimed:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/hush.png"), 16, 16)
   hushTimed:SetHushMode(ChallengeAPI.GoalHushMode.KILL)

   -- Defeat Boss Rush
   -- Request custom functionality:
   --   - [] Auto-unlock the Boss Rush door
   local bossRush = ChallengeAPI:RegisterGoal("boss-rush", "Boss Rush", LevelStage.NUM_STAGES, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)
   bossRush:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/mom.png"), 16, 16)
   bossRush:SetBossRushMode(ChallengeAPI.GoalBossRushMode.ALWAYS)

   -- Defeat Boss Rush, automatically killing the player if they are not in the Boss Rush room when the timer runs out.
   -- Request custom functionality:
   --   - [] Auto-kill player if they run out of time
   local bossRushTimed = ChallengeAPI:RegisterGoal("boss-rush-timed", "Boss Rush", LevelStage.NUM_STAGES, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)
   bossRushTimed:SetGoalIcon(ChallengeAPI.Util.LoadGoalIcon("gfx/ui/challenges/goals/mom.png"), 16, 16)
   bossRushTimed:SetBossRushMode(ChallengeAPI.GoalBossRushMode.KILL)
end
