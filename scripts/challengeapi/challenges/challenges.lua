-- Data structures and functions for registering and querying challenge data.

-- Represents the data from an entry in `challenges.xml`.
---@class ChallengeParams
---@field id integer
---@field name string
---@field playerType PlayerType
---@field goalId string The ID for the ChallengeAPI goal corresponding to this challenge.
---@field enableHooks boolean Whether custom ChallengeAPI goal hooks should be enabled for this challenge.
---@field isHardMode boolean Whether this challenge is in Hard Mode
---@field startingCollectibles string[] A list of all collectibles the player starts with
---@field startingPocketActives string[] A list of all pocket actives the player starts with
---@field removedCollectibles string[] A list of all collectibles the player does not start with (for example, Bethany doesn't start with Book of Virtues in some challenges)
---@field startingCollectiblesEsau string[] A list of all collectibles the second player starts with
---@field startingTrinkets string[] A list of all trinkets the player starts with
---@field startingCard Card? The card the player starts with
---@field startingPill PillEffect? The pill the player starts with
---@field startingMaxHearts integer The number of max hearts the player starts with
---@field startingRedHearts integer The amount of red hearts the player starts with
---@field startingSoulHearts integer The amount of soul hearts the player starts with
---@field startingBlackHearts integer The amount of black hearts the player starts with
---@field startingCoins integer The amount of coins the player starts with
---@field startingDamageBonus integer The amount of additional damage the player starts with
---@field roomFilter number[] A list of room types that will not spawn during the run
---@field curse number[] A list of curses that will always be active during the run
---@field curseFilter number[] A list of curse filters that will not spawn during the run
---@field isBlindfolded boolean Whether the player is blindfolded during the challenge, and thus unable to shoot
---@field isMaxDamage boolean If true, player damage is fixed at 100 (like Pong and Slow Roll)
---@field isMinShotSpeed boolean If true, player shot speed is fixed at 1.0 (like Slow Roll)
---@field isBigRange boolean If true, player range is fixed at 16.5 (like Pong)
---@field eidNotes string[] A list of additional lines to display in the EID description of the challenge.
---@field minimumFireRate number? The minimum fire rate for the player, this applies a maximum tear delay
local ChallengeParams = {}
ChallengeParams.__index = ChallengeParams

---@param id integer
---@param name string
---@param playerType PlayerType
---@param goalId string The ID for the ChallengeAPI goal corresponding to this challenge.
---@return ChallengeParams
function ChallengeParams.new(id, name, playerType, goalId)
    local self = setmetatable({}, ChallengeParams)
    self.id = id
    self.name = name
    self.playerType = playerType
    self.goalId = goalId

    -- Leave these at their defaults until the function is called.
    self.enableHooks = true
    self.isHardMode = false
    self.startingCollectibles = {}
    self.startingCollectiblesEsau = {}
    self.startingTrinkets = {}
    self.startingCards = {}
    self.startingPills = {}
    self.startingMaxHearts = 0
    self.startingRedHearts = 0
    self.startingSoulHearts = 0
    self.startingBlackHearts = 0
    self.startingCoins = 0
    self.startingDamageBonus = 0
    self.isBlindfolded = false
    self.isMaxDamage = false
    self.isMinShotSpeed = false
    self.isBigRange = false
    self.roomFilter = {}
    self.curse = {}
    self.curseFilter = {}
    self.minimumFireRate = nil
    self.eidNotes = {}
    return self
end

-- Retrieves the challenge goal corresponding to this challenge.
function ChallengeParams:FetchGoal()
    return ChallengeAPI:GetGoalById(self.goalId)
end

-- Modifies the challenge goal for this challenge.
function ChallengeParams:SetGoal(goal)
    self.goalId = goal.id
end

-- Modifies whether this challenge uses custom ChallengeAPI functionality.
function ChallengeParams:SetEnableHooks(value)
    self.enableHooks = value
end

-- Modifies whether this challenge is in Hard Mode.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
function ChallengeParams:SetIsHardMode(value)
    self.isHardMode = value
end

-- Modifies the list of starting collectibles as displayed in EID.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
function ChallengeParams:SetStartingCollectibles(list)
    self.startingCollectibles = list
end

-- Modifies the list of pocket actives the player starts with.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
function ChallengeParams:SetStartingPocketActives(list)
    self.startingPocketActives = list
end

-- Modifies the list of collectibles the player does not start with.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
function ChallengeParams:SetRemovedCollectibles(list)
    self.removedCollectibles = list
end

-- Modifies the list of starting collectibles for Esau.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
function ChallengeParams:SetStartingCollectiblesEsau(list)
    self.startingCollectiblesEsau = list
end

-- NOTE: This doesn't let you change the basic parameters of a challenge!
function ChallengeParams:SetStartingTrinkets(list)
    self.startingTrinkets = list
end

-- NOTE: This doesn't let you change the basic parameters of a challenge!
---@param cards Card[]
function ChallengeParams:SetStartingCards(cards)
    if cards == nil then
        self.startingCards = {}
    else
        self.startingCards = cards
    end
end

-- NOTE: This doesn't let you change the basic parameters of a challenge!
---@param pills PillEffect[]
function ChallengeParams:SetStartingPills(pills)
    if pills == nil then
        self.startingPills = {}
    else
        self.startingPills = pills
    end
end

-- NOTE: This doesn't let you change the basic parameters of a challenge!
function ChallengeParams:SetStartingMaxHearts(maxHearts)
    self.startingMaxHearts = maxHearts
end

-- NOTE: This doesn't let you change the basic parameters of a challenge!
function ChallengeParams:SetStartingRedHearts(redHearts)
    self.startingRedHearts = redHearts
end

-- NOTE: This doesn't let you change the basic parameters of a challenge!
function ChallengeParams:SetStartingSoulHearts(soulHearts)
    self.startingSoulHearts = soulHearts
end

-- NOTE: This doesn't let you change the basic parameters of a challenge!
function ChallengeParams:SetStartingBlackHearts(blackHearts)
    self.startingBlackHearts = blackHearts
end

-- NOTE: This doesn't let you change the basic parameters of a challenge!
function ChallengeParams:SetStartingCoins(coins)
    self.startingCoins = coins
end

-- Whether this challenge forcibly applies a starting damage bonus.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
--       It's only for the EID description.
function ChallengeParams:SetStartingDamageBonus(damageBonus)
    self.startingDamageBonus = damageBonus
end

-- Whether this challenge forcibly sets the player's fire rate to a minimum value, if any.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
--       It's only for the EID description.
function ChallengeParams:SetMinimumFireRate(minimumFireRate)
    self.minimumFireRate = minimumFireRate
end

-- Whether this challenge forcibly blindfolds the player, preventing them from shooting.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
--       It's only for the EID description.
function ChallengeParams:SetIsBlindfolded(isBlindfolded)
    self.isBlindfolded = isBlindfolded
end

-- Whether this challenge forcibly sets the player's damage to 100.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
--       It's only for the EID description.
function ChallengeParams:SetIsMaxDamage(isMaxDamage)
    self.isMaxDamage = isMaxDamage
end

-- Whether this challenge forcibly sets the player's shot speed to 1.0.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
--       It's only for the EID description.
---@param isMinShotSpeed boolean
function ChallengeParams:SetIsMinShotSpeed(isMinShotSpeed)
    self.isMinShotSpeed = isMinShotSpeed
end

-- Whether this challenge forcibly sets the player's range to 16.5.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
--       It's only for the EID description.
---@param isBigRange boolean
function ChallengeParams:SetIsBigRange(isBigRange)
    self.isBigRange = isBigRange
end

-- Define the rooms which are not allowed to spawn.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
--       It's only for the EID description.
---@param roomFilter RoomType[]
function ChallengeParams:SetRoomFilter(roomFilter)
    self.roomFilter = roomFilter
end

-- Define the curses which are forced to spawn.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
--       It's only for the EID description.
---@param curse LevelCurse[]
function ChallengeParams:SetCurse(curse)
    self.curse = curse
end

-- Define the curses which are not allowed to spawn.
-- NOTE: This doesn't let you change the basic parameters of a challenge!
--       It's only for the EID description.
---@param curseFilter LevelCurse[]
function ChallengeParams:SetCurseFilter(curseFilter)
    self.curseFilter = curseFilter
end

-- If the player has a minimum fire rate, compute the corresponding maximum tear delay.
---@return number? The maximum tear delay, or nil if there is no minimum fire rate.
function ChallengeParams:GetMaxTearDelay()
    if self.minimumFireRate == nil then
        return nil
    end

    return ChallengeAPI.Util.FireRateToTearDelay(self.minimumFireRate)
end

---Specify additional line of description for this goal,
---to be displayed in External Item Descriptions (EID).
---@param notes string[] A list of additional lines to display in the EID description of the challenge, just under the goal name.
function ChallengeParams:SetEIDNotes(notes)
    self.eidNotes = notes
end

---Builds the description lines for this challenge and returns them for use by EID.
---@return string[]
function ChallengeParams:BuildDescriptionLines()
    local lines = {}

    if #self.eidNotes > 0 then
        lines = ChallengeAPI.Util.AppendTable(lines, self.eidNotes)
    end

    return lines
end


-- Whether this particular challenge is currently active.
---@return boolean
function ChallengeParams:IsActive()
    return Isaac.GetChallenge() == self.id
end

-- Register a new challenge with the ChallengeAPI.
-- This gets done automatically for all the challenges in `challenges.xml`
---@param id integer An internal ID for the challenge.
---@param name string The name of the challenge.
---@param playerType PlayerType The player type to use for the challenge.
---@param goalId string The ID for the Goal corresponding to this challenge. Check the docs for more info.
---@return ChallengeParams
function ChallengeAPI:RegisterChallenge(id, name, playerType, goalId)
    local challenge = ChallengeParams.new(id, name, playerType, goalId)
    
    ChallengeAPI.challenges[challenge.id] = challenge

    -- Execute the callback.
    -- TODO: Should there be a callback that can prevent registration? How do we handle that?
    Isaac.RunCallback(ChallengeAPI.Enum.Callbacks.CALLBACK_POST_CHALLENGE_REGISTERED, challenge)

    return challenge
end

--- Retrieves a challenge by its numeric ID.
---@param id integer
---@return ChallengeParams?
function ChallengeAPI:GetChallengeById(id)
    return ChallengeAPI.challenges[id]
end

--- Retrieves a challenge by its readable name.
---@param name string
---@return ChallengeParams?
function ChallengeAPI:GetChallengeByName(name)
    local challengeId = Isaac.GetChallengeIdByName(name)
    if challengeId == Challenge.CHALLENGE_NULL then
        return nil
    end
    return ChallengeAPI:GetChallengeById(challengeId)
end

--- Returns true if a challenge with the given ID is currently registered.
--- @param id integer
--- @return boolean
function ChallengeAPI:IsChallengeRegistered(id)
    return ChallengeAPI.challenges[id] ~= nil
end