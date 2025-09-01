-- Data structures and functions for registering and querying challenge goal data.

-- Represents a challenge goal, for example beating a certain boss.
---@class Goal
---@field id string An internal ID for the challenge goal.
---@field name string The name of the challenge goal (as displayed in the challenge description).
---
---@field endStage LevelStage The level stage value corresponding to the challenge goal.
---@field altPath GoalAltPaths Whether this challenge goal requires you to visit the alt path.
---@field secretPath GoalSecretPaths Whether this challenge goal requires you to visit the secret path.
---
---@field mustFightMegaSatan boolean Whether this challenge goal requires you to beat Mega Satan, locking out the other boss fights on the floor.
---@field mustFightBeast boolean Whether this challenge goal requires you to beat The Beast. If false, the trophy will spawn when beating Dogma.
---@field momDoorMode GoalMomDoorMode How this challenge goal should behave in relation to Hush. Alter this with Goal:SetHushMode.
---@field hushMode GoalHushMode How this challenge goal should behave in relation to Hush. Alter this with Goal:SetHushMode.
---@field bossRushMode GoalBossRushMode How this challenge goal should behave in relation to Boss Rush. Alter this with Goal:SetBossRushMode.
---
---@field stageTypes table<LevelStage, integer> A table of stage types which should be forced during generation.
---
---@field eidIcon string? The icon to display for this challenge goal next to the name in the EID description.
---@field eidNotes string[] A list of additional lines to display in the EID description of the challenge, just under the goal name.
---@field goalIcon Sprite? The icon to display for this challenge goal in the user interface.
local Goal = {}
Goal.__index = Goal

---@param id string An internal ID for the challenge goal.
---@param name string The name of the challenge goal (as displayed in the challenge description).
---@param endStage LevelStage The endstage value corresponding to the challenge goal, if it has one.
---@param altPath GoalAltPaths Whether this challenge goal requires you to visit the alt path.
---@param secretPath GoalSecretPaths Whether this challenge goal requires you to visit the secret path.
---@param megaSatan boolean Whether this challenge goal requires you to beat Mega Satan.
---@return Goal
function Goal.new(id, name, endStage, altPath, secretPath, megaSatan)
    local self = setmetatable({}, Goal)
    self.id = id
    self.name = name
    self.endStage = endStage
    self.altPath = altPath
    self.secretPath = secretPath
    self.mustFightMegaSatan = megaSatan
    self.mustFightBeast = false
    self.hushMode = ChallengeAPI.Enum.GoalHushMode.NORMAL
    self.bossRushMode = ChallengeAPI.Enum.GoalBossRushMode.NORMAL
    self.momDoorMode = ChallengeAPI.Enum.GoalMomDoorMode.NORMAL
    self.stageTypes = {
        [LevelStage.STAGE1_1] = -1,
        [LevelStage.STAGE1_2] = -1,
        [LevelStage.STAGE2_1] = -1,
        [LevelStage.STAGE2_2] = -1,
        [LevelStage.STAGE3_1] = -1,
        [LevelStage.STAGE3_2] = -1,
        [LevelStage.STAGE4_1] = -1,
        [LevelStage.STAGE4_2] = -1,
        -- Not needed, just use GoalAltPaths
        -- [LevelStage.STAGE5] = -1,
        -- [LevelStage.STAGE6] = -1,
        -- Void has no stage types
        -- [LevelStage.STAGE7] = -1,
        -- Home has no stage types
        -- [LevelStage.STAGE8] = -1,
    }
    self.eidIcon = nil
    self.eidNotes = {}
    self.goalIcon = nil
    return self
end

---
---@param endStage LevelStage
---@param altPath boolean
---@param secretPath boolean
---@param megaSatan boolean
---@return boolean
function Goal:MatchesChallengeParams(endStage, altPath, secretPath, megaSatan)
    -- true = Devil path, false = Angel path
    if (not altPath and self.altPath ~= ChallengeAPI.Enum.GoalAltPaths.DEVIL) or (altPath and self.altPath ~= ChallengeAPI.Enum.GoalAltPaths.ANGEL) then
        return false
    end

    -- true = Secret path, false = Normal path
    if (not secretPath and self.secretPath ~= ChallengeAPI.Enum.GoalSecretPaths.NORMAL) or (secretPath and self.secretPath ~= ChallengeAPI.Enum.GoalSecretPaths.SECRET) then
        return false
    end

    -- true = Mega Satan , false = No Mega Satan
    if self.mustFightMegaSatan ~= megaSatan then
        return false
    end

    return self.endStage == endStage
end

---While the challenge with this goal is active, force a given stage type for a given level stage.
---For example, `ForceStageType(LevelStage.STAGE1_1, StageType.STAGETYPE_WOTL)` will force the player into Cellar 1.
---
---@param levelStage LevelStage The level stage to override.
---@param stageType StageType The stage type to force, or -1 to use disable override.
function Goal:ForceStageType(levelStage, stageType)
    if self.stageTypes[levelStage] == nil then
        error("Goal:ForceStageType() should only be called on challenges ending at a valid stage.")
    end

    self.stageTypes[levelStage] = stageType
end

-- While the challenge is active, determine the behavior of the Hush door after the Mom's Heart fight.
function Goal:SetHushMode(mode)
    self.hushMode = mode
end

-- While the challenge is active, determine the behavior of the Boss Rush door after the Mom fight.
function Goal:SetBossRushMode(mode)
    self.bossRushMode = mode
end

-- While the challenge is active, determine the behavior of the door out of the Mom boss fight on Depths 2.
function Goal:SetMomDoorMode(mode)
    self.momDoorMode = mode
end

-- While the challenge is active, enable the The Beast fight.
-- Requires the end stage to be Home (`LevelStage.STAGE8`).
function Goal:SetMustFightBeast(value)
    -- Validation.
    if value and self.endStage ~= LevelStage.STAGE8 then
        error("Goal:SetMustFightBeast() should only be called on challenges ending at Home.")
    end
    self.mustFightBeast = value
end

-- Specify additional line of description for this goal,
-- to be displayed in External Item Descriptions (EID).
---@param notes string[] A list of additional lines to display in the EID description of the challenge, just under the goal name.
function Goal:SetEIDNotes(notes)
    self.eidNotes = notes
end

-- Builds one or more lines of the EID description for this challenge goal.
-- This is generally for internal use only.
function Goal:BuildDescriptionLines()
    local lines = {}
    
    if self.secretPath == ChallengeAPI.Enum.GoalSecretPaths.SECRET then
        table.insert(lines, ChallengeAPI:Translate("EIDGoalSecretPath"))
        if self.endStage >= LevelStage.STAGE4_1 then
            table.insert(lines, ChallengeAPI:Translate("EIDGoalKnifePieces"))
        end
    end

    if #self.eidNotes > 0 then
        lines = ChallengeAPI.Util.AppendTable(lines, self.eidNotes)
    end

    return lines
end

-- Assigns a shortcut string to display as a goal icon for the Challenge Summary in EID.
-- For example, `"{{BlueBaby}}"` will use the Blue Baby boss icon.
---@param icon string? The string to display for this challenge goal in the EID description.
function Goal:SetEIDIcon(icon)
    self.eidIcon = icon
end

-- Set a sprite to use for this goal on the HUD.
-- Also registers it to be displayed in EID!
---@param icon Sprite
---@param width integer Width of the icon, in pixels. Defaults to 16.
---@param height integer Height of the icon, in pixels. Defaults to 16.
---@param makeEIDIcon boolean? Whether to register the icon in EID. Defaults to true.
function Goal:SetGoalIcon(icon, width, height, makeEIDIcon)
    makeEIDIcon = makeEIDIcon or false

    self.goalIcon = icon

    if EID and makeEIDIcon then
        width = width or 16
        height = height or 16
        local leftOffset = 0
        local topOffset = 0

        ChallengeAPI:EID_AddIcon("Goal"..self.id, width, height, icon, leftOffset, topOffset)
        self:SetEIDIcon("{{Goal"..self.id.."}}")
    end
end

-- Retrieve the first goal corresponding to the values from the `challenges.xml` file.
-- May return nil if no goal matches.
---@param endStage LevelStage
---@param altPath boolean
---@param secretPath boolean
---@param megaSatan boolean
---@return Goal?
function ChallengeAPI:GetGoalByChallengeParams(endStage, altPath, secretPath, megaSatan)
    -- Loop over the list of goals and return the first one that matches the endstage
    for _, goal in pairs(ChallengeAPI.goals) do
        if goal:MatchesChallengeParams(endStage, altPath, secretPath, megaSatan) then
            return goal
        end
    end

    return nil
end

-- Retrieve a goal by its ID.
---@param id string
---@return Goal?
function ChallengeAPI:GetGoalById(id)
    return ChallengeAPI.goals[id]
end

-- Register a new goal with the ChallengeAPI
---@param id string An internal ID for the challenge goal.
---@param name string The name of the challenge goal (as displayed in the challenge description).
---@param endStage integer The endstage value corresponding to the challenge goal, if it has one.
---@param altPath GoalAltPaths Whether this challenge goal requires you to visit the alt path.
---@param secretPath GoalSecretPaths Whether this challenge goal requires you to visit the secret path.
---@param megaSatan boolean Whether this challenge goal requires you to beat Mega Satan.
---@return Goal
function ChallengeAPI:RegisterGoal(id, name, endStage, altPath, secretPath, megaSatan)
    local goal = Goal.new(id, name, endStage, altPath, secretPath, megaSatan)
    
    ChallengeAPI.goals[goal.id] = goal

    -- Execute the callback.
    -- TODO: Should this be allowed to prevent registration? How do we handle that?
    Isaac.RunCallback(ChallengeAPI.Enum.Callbacks.CALLBACK_POST_GOAL_REGISTERED, goal)

    return goal
end

--- Returns true if a goal with the given ID is registered.
--- @param id string The ID of the goal to check.
--- @return boolean True if the goal is registered.
function ChallengeAPI:IsGoalRegistered(id)
    return ChallengeAPI.goals[id] ~= nil
end
