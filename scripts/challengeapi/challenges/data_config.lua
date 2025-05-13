-- Utilities to register all challenges from the base game with ChallengeAPI.

-- Registers a challenge from the XML data.
---@param entry table
local function registerChallengeFromConfigData(entry)
    -- A human-readable English name
    local name = entry.name
    -- The numeric ID
    local id = tonumber(entry.id)
    if id == nil then
        id = Isaac.GetChallengeIdByName(name)
    end

    -- The player ID for the challenge.
    -- nil values default to Isaac.
    local playerTypeStr = entry.playertype
    local playerType = PlayerType.PLAYER_ISAAC

    if playerTypeStr then
        local playerId = tonumber(entry.playertype)
        if playerId == nil then
            if Isaac.GetPlayerTypeByName(playerTypeStr) ~= -1 then
                playerType = Isaac.GetPlayerTypeByName(playerTypeStr)
            else
                -- Not a valid ID or player name!
                playerType = PlayerType.PLAYER_ISAAC
            end
        else
            playerType = playerId
        end
    end

    local endStage = tonumber(entry.endstage) or LevelStage.STAGE4_2 -- Default to Mom
    local altPath = entry.altpath == "true"
    local secretPath = entry.secretpath == "true"
    local megaSatan = entry.megasatan == "true"

    local isHardMode = entry.difficulty == "1"

    local startingMaxHearts = tonumber(entry.maxhp) or 0
    local startingRedHearts = tonumber(entry.redhp) or 0
    local startingSoulHearts = tonumber(entry.soulhp) or 0
    local startingBlackHearts = tonumber(entry.blackhp) or 0
    local startingCoins = tonumber(entry.coins) or 0
    local startingDamageBonus = tonumber(entry.adddamage) or 0
    -- Minimum fire rate results in a maximum tear delay.
    local minimumFireRate = tonumber(entry.minfirerate) or nil
            
    local isBlindfolded = entry.canshoot == "false"
    local isMaxDamage = entry.maxdamage == "true"
    local isMinShotSpeed = entry.minshotspeed == "true"
    local isBigRange = entry.bigrange == "true"

    local roomFilterStrs = entry.roomfilter and ChallengeAPI.Util.SplitString(entry.roomfilter, ',') or {}
    -- Convert the array of strings to an array of numbers.
    local roomFilter = {}
    for _, roomStr in ipairs(roomFilterStrs) do
        local roomId = tonumber(roomStr)
        if roomId then
            table.insert(roomFilter, roomId)
        end
    end

    local curseValue = entry.getcurse and tonumber(entry.getcurse) or 0
    local curse = {}
    if curseValue > 0 then
        local i = 0
        while curseValue > 0 do
            if (curseValue & (1 << i)) > 0 then
                table.insert(curse, (1 << i))
                curseValue = curseValue - (1 << i)
            end
            i = i + 1
        end
    end

    local curseFilterValue = entry.cursefilter and tonumber(entry.cursefilter) or 0
    local curseFilter = {}
    if curseFilterValue > 0 then
        local i = 0
        while curseFilterValue > 0 do
            if (curseFilterValue & (1 << i)) > 0 then
                table.insert(curseFilter, (1 << i))
                curseFilterValue = curseFilterValue - (1 << i)
            end
            i = i + 1
        end
    end

    local goalId = entry.capigoal
    
    if goalId == nil then
        -- Try to guess the goal ID based on the challenge parameters
        local challengeGoal = ChallengeAPI:GetGoalByChallengeParams(endStage, altPath, secretPath, megaSatan)
        
        if not challengeGoal then
            ChallengeAPI.Log("ChallengeAPI: Could not register challenge " .. name .. " (" .. id .. "): No goal found for challenge.")
            return
        end
                
        goalId = challengeGoal.id
    end
            
    local startingCollectiblesStrs = entry.startingitems and ChallengeAPI.Util.SplitString(entry.startingitems, ',') or {}
    local startingCollectibles = {}
    local removedCollectibles = {}

    -- Parse the starting items
    -- Some challenges remove starting items from certain characters, indicated by a negative.
    -- If we are in REPENTOGON, the item name might get used instead.
    for _, collectible in ipairs(startingCollectiblesStrs) do
        local collectibleId = tonumber(collectible)
        if collectibleId == nil then
            if Isaac.GetItemIdByName(collectible) ~= CollectibleType.COLLECTIBLE_NULL then
                collectibleId = Isaac.GetItemIdByName(collectible)
            else
                -- Not a valid item ID or item name.
                goto continue
            end
        end
        if collectibleId < 0 then
            table.insert(removedCollectibles, -1 * collectibleId)
        else
            table.insert(startingCollectibles, collectibleId)
        end
        ::continue::
    end

    local startingTrinketsStrs = entry.startingtrinkets and ChallengeAPI.Util.SplitString(entry.startingtrinkets, ',') or {}
    local startingTrinkets = {}

    -- Parse the starting trinkets
    -- If we are in REPENTOGON, the trinket name might get used instead
    for _, trinketStr in ipairs(startingTrinketsStrs) do
        local trinketId = tonumber(trinketStr)
        if trinketId == nil then
            if Isaac.GetTrinketIdByName(trinketStr) ~= TrinketType.TRINKET_NULL then
                trinketId = Isaac.GetTrinketIdByName(trinketStr)
            else
                -- Not a valid trinket ID or trinket name.
                goto continue
            end
        end
        table.insert(startingTrinkets, trinketId)
        ::continue::
    end

    ---@type Card?
    local startingCard = entry.startingcard and tonumber(entry.startingcard) or Card.CARD_NULL
    if startingCard == Card.CARD_NULL then
        startingCard = nil
    end

    ---@type PillEffect?
    local startingPill = entry.startingpill and tonumber(entry.startingpill) or nil

    ---@type ChallengeParams
    local challenge = ChallengeAPI:RegisterChallenge(id, name, playerType, goalId)
            
    challenge:SetIsHardMode(isHardMode)
    challenge:SetStartingCollectibles(startingCollectibles)
    challenge:SetRemovedCollectibles(removedCollectibles)
    challenge:SetStartingTrinkets(startingTrinkets)
    challenge:SetStartingCard(startingCard)
    challenge:SetStartingPill(startingPill)
    challenge:SetStartingMaxHearts(startingMaxHearts)
    challenge:SetStartingRedHearts(startingRedHearts)
    challenge:SetStartingSoulHearts(startingSoulHearts)
    challenge:SetStartingBlackHearts(startingBlackHearts)
    challenge:SetStartingCoins(startingCoins)
    challenge:SetStartingDamageBonus(startingDamageBonus)
    challenge:SetIsBlindfolded(isBlindfolded)
    challenge:SetIsMaxDamage(isMaxDamage)
    challenge:SetIsMinShotSpeed(isMinShotSpeed)
    challenge:SetIsBigRange(isBigRange)
    challenge:SetRoomFilter(roomFilter)
    challenge:SetCurse(curse)
    challenge:SetCurseFilter(curseFilter)
    challenge:SetMinimumFireRate(minimumFireRate)

    ChallengeAPI.Log("Registered challenge " .. name .. " (" .. id .. ")")
end

-- Fetches all challenge entries from the XML data, and registers them with ChallengeAPI.
function ChallengeAPI:RegisterChallengesFromConfig()
    if REPENTOGON then
        local count = XMLData.GetNumEntries(XMLNode.CHALLENGE)
        for i = 1, count do
            local entry = XMLData.GetEntryByOrder(XMLNode.CHALLENGE, i)

            -- Skip processing if the entry is invalid
            if entry then
                registerChallengeFromConfigData(entry)
            end
        end
    else
        -- Without REPENTOGON, we can't cache information about existing challenges.
        -- Guess we'll have to hardcode the vanilla challenges.
        ChallengeAPI:RegisterVanillaChallenges()
    end
end