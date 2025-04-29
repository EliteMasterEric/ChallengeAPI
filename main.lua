local mod = RegisterMod("ChallengeAPI", 1)
ChallengeAPI = mod

---@diagnostic disable-next-line: undefined-global
ChallengeAPI.isRepentancePlus = REPENTANCE_PLUS or FontRenderSettings ~= nil -- True if we are on Repentance+, the latest DLC
ChallengeAPI.isRepentance = REPENTANCE or ChallengeAPI.isRepentancePlus -- True if we are on Repentance OR Repentance+
ChallengeAPI.isAfterbirthPlus = not ChallengeAPI.isRepentance and not ChallengeAPI.isRepentancePlus -- True only if we are on Afterbirth+ (no other DLCs enabled)
ChallengeAPI.isRepentanceOnly = ChallengeAPI.isRepentance and not ChallengeAPI.isRepentancePlus -- True if we are on Repentance but NOT Repentance+

ChallengeAPI.Languages = {"en_us"}

-- Base setup
include('scripts.challengeapi.data')
include('scripts.challengeapi.log')
include('scripts.challengeapi.commands')
include('scripts.challengeapi.status')
include('scripts.challengeapi.util')

-- Languages and Localization Data
include('scripts.challengeapi.language.main')
include('scripts.challengeapi.language.eid')

-- Challenge Goals
include('scripts.challengeapi.goals.enums')
include('scripts.challengeapi.goals.goals')
include('scripts.challengeapi.goals.data_vanilla')
include('scripts.challengeapi.goals.data_custom')

-- Challenges
include('scripts.challengeapi.challenges.challenges')
include('scripts.challengeapi.challenges.data_config')

-- Challenge Goal Hooks
include('scripts.challengeapi.goals.hooks.ascent')
include('scripts.challengeapi.goals.hooks.beast')
include('scripts.challengeapi.goals.hooks.stage_type')

-- Custom HUD elements
include('scripts.challengeapi.hud.challenge')
include('scripts.challengeapi.hud.eid')

-- Tests (REMOVE LATER)
include('scripts.challengeapi.test')

local function enableIntegrations(_)
  if REPENTOGON then
    ChallengeAPI.Log("Repentogon integration enabled.")
  else
    ChallengeAPI.Log("Repentogon integration disabled.")
  end

  ChallengeAPI:EID_EnableIntegration()
end

-- Called after all mods are loaded, in case of load order issues.
local function onPostModsLoaded(_)
  ChallengeAPI.Log("ChallengeAPI has loaded.")

  ChallengeAPI:Initialize()
  enableIntegrations()
end

function ChallengeAPI:Initialize(_)
  ChallengeAPI.goalsInitialized = true
  ChallengeAPI:RegisterVanillaGoals()
  ChallengeAPI:RegisterAdditionalGoals()
  ChallengeAPI:RegisterCustomGoals()

  ChallengeAPI.challengesInitialized = true
  ChallengeAPI:RegisterVanillaChallenges()
end

if REPENTOGON then
    ChallengeAPI:AddPriorityCallback(ModCallbacks.MC_POST_MODS_LOADED, CallbackPriority.DEFAULT, onPostModsLoaded)
else
    ChallengeAPI:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.DEFAULT, onPostModsLoaded)
end