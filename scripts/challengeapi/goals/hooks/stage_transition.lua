-- Handles functionality for ensuring the player always transitions to the correct stage,
-- and that the stage generates correctly.

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

-- Called after the level has calculated seeded curses.
-- Allows additional curses to be added.
-- NOTE: Skipped if Black Candle is equipped, so only reliable for querying for XL floors.
-- TODO: Does this happen before or after level generation?
---@param curses integer The provided curses, as a bitmask.
---@return integer? (optional) A new set of curses to use, as a bitmask.
local function onPostCurseEval(_mod, curses)
    if not isHookValid() then
        return
    end

    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return nil
    end

    local currentStage = Game():GetLevel():GetAbsoluteStage()

    if goal.mustFightBeast and currentStage == LevelStage.STAGE3_1 then
        if curses & LevelCurse.CURSE_OF_LABYRINTH then
            -- ChallengeAPI.Log("Moving into Depths XL...")

            -- TODO: Fix the various bugs associated with XL floors rather than disabling them.
            return 0
        end
    end
end

-- Called before the level layout is generated.
-- NOTE: Only available with REPENTOGON
local function onPreLevelInit(_mod)
    -- ChallengeAPI.Log("Level initialized.")
end

-- Called after the initial level layout is determined, but before rooms are actually placed.
-- Use the LevelGenerator to place additional rooms.
-- NOTE: Only available with REPENTOGON
-- TODO: Does this exclude special rooms?
---@param levelGenerator LevelGenerator
local function onPostLevelLayoutGenerated(_mod, levelGenerator)
    -- ChallengeAPI.Log("Level layout generated.")
end

-- Called when the game selects which level to load, usually when the player enters a trapoor.
-- NOTE: Exclusive to REPENTOGON
---@param level LevelStage
---@param type StageType
---@return table? {level, type}
local function onPreLevelSelect(_mod, level, type)
    if not isHookValid() then
        return
    end

    -- ChallengeAPI.Log("Transitioning to level: ", level, type)

    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return nil
    end

    if goal.mustFightBeast and level == LevelStage.STAGE3_2 then
        -- Temporarily switch to an empty challenge.
        -- This allows the Strange Door to generate.
        ChallengeAPI.Log("Forcing player out of challenge to generate Strange Door (onPreLevelSelect)")
        ChallengeAPI:SwitchChallenge(Challenge.CHALLENGE_NULL)
    end

    if goal.mustFightBeast and level == LevelStage.STAGE4_1 then
        -- Tried to go to Womb during Beast challenge.
        forceDadsNote()
        
        -- ChallengeAPI.Log("Forcing to Mausoleum 2...")

        local type = StageType.STAGETYPE_REPENTANCE

        -- 50% to use Gehenna if unlocked.
        if isGehennaUnlocked() and (ChallengeAPI.Random:Next() % 2 == 1) then
            type = StageType.STAGETYPE_REPENTANCE_B
        end

        return {LevelStage.STAGE3_2, type}
    end
end

local function onPreNewRoom(_mod, room, roomDescriptor)
    if not isHookValid() then
        return
    end

    local currentStage = Game():GetLevel():GetAbsoluteStage()
    local type = Game():GetLevel():GetStageType()

    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return nil
    end

    local level = Game():GetLevel()
    local isStartingRoom = level:GetCurrentRoomIndex() == level:GetStartingRoomIndex()

    if goal.mustFightBeast and currentStage == LevelStage.STAGE3_2 and isStartingRoom then
        -- Temporarily set the challenge to null (without affecting display)
        -- This forces the Strange Door to appear.
        ChallengeAPI.Log("Forcing player out of challenge to generate Strange Door (onPreNewRoom)...")
        ChallengeAPI:SwitchChallenge(Challenge.CHALLENGE_NULL)
    else
        -- Keep the run on the current challenge.
        -- NOTE: We don't have a callback without REPENTOGON that runs early enough
        -- to guarantee we can respawn the strange door again, so we spend the
        -- entirety of Depths 2 in "switched" mode.
        ChallengeAPI:RevertChallenge()
    end
end

local function onPostNewLevel(_mod)
    if not isHookValid() then
        return
    end

    local currentStage = Game():GetLevel():GetAbsoluteStage()
    local type = Game():GetLevel():GetStageType()

    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return nil
    end

    if goal.mustFightBeast and currentStage == LevelStage.STAGE3_2 then
        forceDadsNote()
    end
end

---@param player EntityPlayer
local function isPlayerOnTrapdoor(player)
    local THRESHOLD = 10

    ---@type GridEntityTrapDoor[]
    local trapdoors = ChallengeAPI.Util.GetTrapdoors()

    if #trapdoors ~= 0 then
        for index = 1, #trapdoors, 1 do
            local trapdoor = trapdoors[index]
            if trapdoor.Position:Distance(player.Position) <= THRESHOLD then
                -- Player is REALLY close to a trapdoor. They're probably going to switch floors.
                return true
            end
        end
    end

    return false
end

local wasPlayerOnTrapdoor = false
-- Called every frame to check if the player just touched a trapdoor.
local function onPostPlayerUpdate(_mod, player)
    if not isHookValid() then
        return
    end

    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return nil
    end
            
    local currentStage = Game():GetLevel():GetAbsoluteStage()
    local nextStage = currentStage + 1
    
    local thisFloorHasStrangeDoor = goal.mustFightBeast and (currentStage == LevelStage.STAGE3_2)
    local nextFloorHasStrangeDoor = goal.mustFightBeast and (currentStage == LevelStage.STAGE3_1 and nextStage == LevelStage.STAGE3_2)

    local isPlayerOnTrapdoor = isPlayerOnTrapdoor(player)
    -- Only called once per each time the player steps on the trapdoor.
    if isPlayerOnTrapdoor and not wasPlayerOnTrapdoor and nextFloorHasStrangeDoor then
        -- Player touched the trapdoor, and is about to change floors.

        -- Temporarily switch to an empty challenge.
        -- This allows the Strange Door to generate.
        ChallengeAPI.Log("Forcing player out of challenge to generate Strange Door...")
        ChallengeAPI:SwitchChallenge(Challenge.CHALLENGE_NULL)
    end
    wasPlayerOnTrapdoor = isPlayerOnTrapdoor
end


ChallengeAPI:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, onPostCurseEval)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, onPostNewLevel)
if ChallengeAPI.IsREPENTOGON then
    ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, onPreLevelSelect)
    ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_LEVEL_INIT, onPreLevelInit)
    ChallengeAPI:AddCallback(ModCallbacks.MC_POST_LEVEL_LAYOUT_GENERATED, onPostLevelLayoutGenerated)
    ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_NEW_ROOM, onPreNewRoom)
else
    ChallengeAPI:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, onPostPlayerUpdate)
    -- ChallengeAPI:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, onPostNewRoom)
end
