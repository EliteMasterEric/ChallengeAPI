---@type ModReference
local mod = RegisterMod("ChallengeAPI", 1)
---@class ChallengeAPI: ModReference
ChallengeAPI = mod

ChallengeAPI.Enum = {}

---@diagnostic disable-next-line: undefined-global
ChallengeAPI.IsRepentancePlus = REPENTANCE_PLUS or FontRenderSettings ~= nil -- True if we are on Repentance+, the latest DLC
ChallengeAPI.IsRepentance = REPENTANCE or ChallengeAPI.IsRepentancePlus -- True if we are on Repentance OR Repentance+
ChallengeAPI.IsAfterbirthPlus = not ChallengeAPI.IsRepentance and not ChallengeAPI.IsRepentancePlus -- True only if we are on Afterbirth+ (no other DLCs enabled)
ChallengeAPI.IsRepentanceOnly = ChallengeAPI.IsRepentance and not ChallengeAPI.IsRepentancePlus -- True if we are on Repentance but NOT Repentance+
ChallengeAPI.IsREPENTOGON = REPENTOGON ~= nil

ChallengeAPI.Languages = {"en_us"}

ChallengeAPI.Random = RNG()
ChallengeAPI.Random:SetSeed(Random(), 0)

-- Base setup
include('scripts.challengeapi.data')
include('scripts.challengeapi.log')
include('scripts.challengeapi.callbacks')
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
include('scripts.challengeapi.goals.hooks.init')
include('scripts.challengeapi.goals.hooks.tags.init')

-- Custom HUD elements
include('scripts.challengeapi.hud.challenge_goal')
include('scripts.challengeapi.hud.eid')

include('scripts.challengeapi.integration.index')

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
  
  ChallengeAPI:Birthcake_EnableIntegration()
end

local function onEIDPostLoad()
  ChallengeAPI:EID_EnableIntegration()
end

local function initialize()
  ChallengeAPI.Log("Starting ChallengeAPI...")

  if ChallengeAPI.IsREPENTOGON then
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
  -- Regardless of whether REPENTOGON is enabled, we need to apply corrections and custom descriptions.
  ChallengeAPI:RegisterChallengeCorrections()

  ChallengeAPI.Log("ChallengeAPI has finished loading.")
  
  -- TODO: Enable once EID updates
  -- ChallengeAPI:AddCallback("EID_POST_LOAD", onEIDPostLoad)

  Isaac.RunCallback(ChallengeAPI.Enum.Callbacks.CALLBACK_POST_LOADED)
end

initialize()

-- Do this after mods are loaded.
if ChallengeAPI.IsREPENTOGON then
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