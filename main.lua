local mod = RegisterMod("ChallengeAPI", 1)
ChallengeAPI = mod

ChallengeAPI.CALLBACK_POST_LOAD = "CHALLENGEAPI_POST_LOAD"

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
include('scripts.challengeapi.challenges.data_hardcoded')

-- Challenge Goal Hooks
include('scripts.challengeapi.goals.hooks.ascent')
include('scripts.challengeapi.goals.hooks.beast')
include('scripts.challengeapi.goals.hooks.stage_type')

-- Custom HUD elements
include('scripts.challengeapi.hud.challenge')
include('scripts.challengeapi.hud.eid')

local function initialize()
  ChallengeAPI.Log("Starting ChallengeAPI...")

  if REPENTOGON then
    ChallengeAPI.Log("REPENTOGON integration enabled.")
  else
    ChallengeAPI.Log("REPENTOGON integration disabled. Some challenge descritions may be unavailable.")
  end

  ChallengeAPI:LoadLanguageData()

  ChallengeAPI.goalsInitialized = true
  ChallengeAPI:RegisterVanillaGoals()
  ChallengeAPI:RegisterAdditionalGoals()
  ChallengeAPI:RegisterCustomGoals()
  
  ChallengeAPI.challengesInitialized = true
  ChallengeAPI:RegisterChallengesFromConfig()
  -- Regardless if REPENTOGON is enabled, we need to apply corrections and custom descriptions.
  ChallengeAPI:RegisterChallengeCorrections()

  ChallengeAPI.Log("ChallengeAPI has finished loading.")
end

-- Called after all mods are loaded, in case of load order issues.
local function onPostModsLoaded(_)
  ChallengeAPI:EID_EnableIntegration()
  
  Isaac.RunCallback(ChallengeAPI.CALLBACK_POST_LOAD)
end

if REPENTOGON then
  ChallengeAPI:AddPriorityCallback(ModCallbacks.MC_POST_MODS_LOADED, CallbackPriority.DEFAULT, onPostModsLoaded)
else
  ChallengeAPI:AddPriorityCallback(ModCallbacks.MC_POST_GAME_STARTED, CallbackPriority.DEFAULT, onPostModsLoaded)
end

initialize()
