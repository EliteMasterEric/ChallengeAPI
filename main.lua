local mod = RegisterMod("ChallengeAPI", 1)
ChallengeAPI = mod

ChallengeAPI.CALLBACK_POST_LOAD = "CHALLENGEAPI_POST_LOAD"

---@diagnostic disable-next-line: undefined-global
ChallengeAPI.IsRepentancePlus = REPENTANCE_PLUS or FontRenderSettings ~= nil -- True if we are on Repentance+, the latest DLC
ChallengeAPI.IsRepentance = REPENTANCE or ChallengeAPI.isRepentancePlus -- True if we are on Repentance OR Repentance+
ChallengeAPI.IsAfterbirthPlus = not ChallengeAPI.isRepentance and not ChallengeAPI.isRepentancePlus -- True only if we are on Afterbirth+ (no other DLCs enabled)
ChallengeAPI.IsRepentanceOnly = ChallengeAPI.isRepentance and not ChallengeAPI.isRepentancePlus -- True if we are on Repentance but NOT Repentance+
ChallengeAPI.IsREPENTOGON = REPENTOGON ~= nil

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
include('scripts.challengeapi.goals.hooks.beast')
include('scripts.challengeapi.goals.hooks.polaroid_negative')
include('scripts.challengeapi.goals.hooks.trapdoors')

-- Custom HUD elements
include('scripts.challengeapi.hud.challenge_goal')
include('scripts.challengeapi.hud.eid')

-- Called after all mods are loaded, in case of load order issues.
local didPostModLoad = false
local function onPostModsLoaded(_)
  if didPostModLoad then
    return
  else
    didPostModLoad = true
  end

  ChallengeAPI.Log("Loading additional integrations...")

  ChallengeAPI:EID_EnableIntegration()
  
  include('scripts.challengeapi.integration.index')
end

local function onEIDPostLoad()
  ChallengeAPI:EID_EnableIntegration()
end

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
  
  -- TODO: Enable once EID updates
  -- ChallengeAPI:AddCallback("EID_POST_LOAD", onEIDPostLoad)

  Isaac.RunCallback(ChallengeAPI.CALLBACK_POST_LOAD)
end

initialize()

-- Do this after mods are loaded.
if REPENTOGON then
  ChallengeAPI:AddCallback(ModCallbacks.MC_POST_MODS_LOADED, onPostModsLoaded)
else
  ChallengeAPI:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onPostModsLoaded)
end

local function onPostUpdate(mod)
  if not didPostModLoad then
    onPostModsLoaded(mod)
  end
end

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_UPDATE, onPostUpdate)