-- Handles functionality for ensuring the player always transitions to the correct stage.

-- Determine whether the hooks in this module are relevant for the current challenge.
---@return boolean Whether the hooks are valid.
local function isHookValid()
    if not ChallengeAPI:AreHooksActive() then
        return false
    end

    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return false
    end

    if goal.mustFightBeast then
        return true
    end

    return false
end

local function isGehennaUnlocked()
    if ChallengeAPI.IsREPENTOGON then
        return Isaac:GetPersistentGameData():Unlocked(Achievement.GEHENNA)
    end

    -- FUCK YOU TYRONE
    return false
end

-- If enabled, prevents Mom's Heart from spawning in Mausoleum 2.
local function forceDadsNote()
    Game():SetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH_INIT, true)
end

-- Causes the player to transition to Mausoleum 2, complete with transition animation,
-- as though the player entered a trapdoor.
local function transitionToMausoleum2(ascent)
    -- Doesn't actually take you to a new stage, just sets the layout of the current one?
    -- Doesn't matter if we're transitioning anyway
    Game():GetLevel():SetStage(LevelStage.STAGE3_1, StageType.STAGETYPE_REPENTANCE)
    Game():StartStageTransition(false, 0, Isaac.GetPlayer())
    
    -- Isaac.ExecuteCommand("stage 5c") -- 5c = Mausoleum 1
end

-- Called when the game selects which level to load, usually when the player enters a trapoor.
---@param level LevelStage
---@param type StageType
---@return table? {level, type}
local function onPreLevelSelect(_mod, level, type)
    if not isHookValid() then
        return
    end

    ChallengeAPI.Log("Transitioning to level: ", level, type)

    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return nil
    end

    if goal.mustFightBeast and level == LevelStage.STAGE4_1 then
        -- Tried to go to Womb during Beast challenge.
        forceDadsNote()
        
        ChallengeAPI.Log("Forcing to Mausoleum 2...")

        local type = StageType.STAGETYPE_REPENTANCE

        -- 50% to use Gehenna if unlocked.
        if isGehennaUnlocked() and (ChallengeAPI.Random:Next() % 2 == 1) then
            type = StageType.STAGETYPE_REPENTANCE_B
        end

        return {LevelStage.STAGE3_2, StageType.STAGETYPE_REPENTANCE}
    end
end

local function onPostNewLevel(_mod)
    if not isHookValid() then
        return
    end

    local level = Game():GetLevel():GetAbsoluteStage()
    local type = Game():GetLevel():GetStageType()

    ChallengeAPI.Log("Transitioned to level: ", level, type)

    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return nil
    end

    if goal.mustFightBeast and level == LevelStage.STAGE3_2 then
        forceDadsNote()
    end
end

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, onPostNewLevel)
if ChallengeAPI.IsREPENTOGON then
    ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, onPreLevelSelect)
end