-- Register custom challenge goals which require custom logic for ChallengeAPI to work.
function ChallengeAPI:RegisterCustomGoals()
   -- Defeat Delirium in the Void, via the Dark Room
   -- Requires custom functionality:
   --   - [] Guarantee the portal in Dark Room/Chest if Rep+ isn't enabled
   --   - [] Prevent the Chest entity from spawning (touching it ends the run without completing the challenge)
   ChallengeAPI:RegisterGoal("delirium", "Delirium", LevelStage.STAGE7, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)

   -- Defeat Delirium in the Void, via the Chest
   -- Requires custom functionality:
   --   - [] Guarantee the portal in Dark Room/Chest if Rep+ isn't enabled
   --   - [] Prevent the Chest entity from spawning (touching it ends the run without completing the challenge)
   ChallengeAPI:RegisterGoal("delirium-chest", "Delirium", LevelStage.STAGE7, ChallengeAPI.GoalAltPaths.ANGEL, ChallengeAPI.GoalSecretPaths.NORMAL, false)

   -- Defeat Mom in Mausoleum II
   -- Requires custom functionality:
   --   - [] Disable the Womb
   local momSecret = ChallengeAPI:RegisterGoal("mom-secret", "Mom", LevelStage.STAGE4_2, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)
   momSecret:SetEIDNotes({"Must go Downpour/Mines/Mausoleum"})

   -- Defeat The Beast in Home
   -- Requires custom functionality:
   --   - [X] Override the boss to ensure the trophy spawns.
   --   - [] Prevent the trapdoor to Womb from opening.
   --   - [] Teleport the player to the starting room when the Polaroid/Negative is collected.
   --   - [] Prevent the player from softlocking themselves in the boss fight room?
   ChallengeAPI:RegisterGoal("beast", "The Beast", LevelStage.STAGE7, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)

   -- Defeat Hush in ??? (Blue Womb)
   -- Requires custom functionality:
   --   - [] Auto-unlock the Hush door
   local hush = ChallengeAPI:RegisterGoal("hush", "Hush", LevelStage.STAGE7, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)
   hush:SetHushMode(ChallengeAPI.GoalHushMode.ALWAYS)

   -- Defeat Hush in ??? (Blue Womb), automatically killing the player if they are not in the Hush room when the timer runs out.
   -- Requires custom functionality:
   --   - [] Auto-kill player if they run out of time
   local hushTimed = ChallengeAPI:RegisterGoal("hush-timed", "Hush", LevelStage.STAGE4_3, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)
   hushTimed:SetHushMode(ChallengeAPI.GoalHushMode.KILL)

   -- Defeat Boss Rush
   -- Request custom functionality:
   --   - [] Auto-unlock the Boss Rush door
   local bossRush = ChallengeAPI:RegisterGoal("boss-rush", "Boss Rush", LevelStage.NUM_STAGES, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)
   bossRush:SetBossRushMode(ChallengeAPI.GoalBossRushMode.ALWAYS)

   -- Defeat Boss Rush, automatically killing the player if they are not in the Boss Rush room when the timer runs out.
   -- Request custom functionality:
   --   - [] Auto-kill player if they run out of time
   local bossRushTimed = ChallengeAPI:RegisterGoal("boss-rush-timed", "Boss Rush", LevelStage.NUM_STAGES, ChallengeAPI.GoalAltPaths.DEVIL, ChallengeAPI.GoalSecretPaths.NORMAL, false)
   bossRushTimed:SetBossRushMode(ChallengeAPI.GoalBossRushMode.KILL)
end
