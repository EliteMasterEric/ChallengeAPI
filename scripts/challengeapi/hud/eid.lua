-- Handles the custom category in External Item Descriptions

ChallengeAPI.EID_CurrentScrollOffset = 0
ChallengeAPI.EID_DescriptionLineCount = 8
ChallengeAPI.EID_HasInitialized = false

-- A list of 
ChallengeAPI.EID_MarkupCache = {}

local function isEIDEnabled()
    return EID ~= nil
end

-- Called after all mods are registered.
-- Adds a new category to EID for ChallengeAPI. It does this in a sorta hacky way, since right now there's no API for it.
-- @see https://github.com/wofsauge/External-Item-Descriptions/blob/master/features/eid_holdmapdesc.lua
-- TODO: Resolve once https://github.com/wofsauge/External-Item-Descriptions/issues/831 is approved
local function injectEIDCategory()
    if EID == nil then
        ChallengeAPI.Log("ERROR: Tried to inject EID category, but EID is not enabled.")
        return
    end

    -- Skip if we've already done it.
    if EID.ItemReminderCategories[2].id == "ChallengeAPI" then
        return
    end

    local category = {
        id = "ChallengeAPI",
        -- we use scrolling
        isScrollable = true,
        -- true: hide content in overview tab.
        hideInOverview = false,
        entryGenerators = {
            function(player) 
                ChallengeAPI:EID_HandleChallengeInfo(player)
            end
        },
        scrollbarGenerator = function(player)
            return ChallengeAPI:EID_HandleChallengeScrollbar(player)
        end
    }

    -- 2 = after "Overview"
    table.insert(EID.ItemReminderCategories, 2, category)
end

local function getPlayerName(id)
    return EID:getPlayerName(id)
end

local function getCollectibleName(id)
    return EID:getObjectName(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, id)
end

local function getCardName(id)
    return EID:getObjectName(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, id)
end

local function getPillName(id)
    return EID:getPillName(id+1)
end

local function getTrinketName(id)
    return EID:getObjectName(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, id)
end

local function isGoalIconValid(goalId)
    return EID:getIcon("Goal"..goalId)[1] ~= "ERROR"
end

-- Display a message in EID if the current challenge is unknown.
---@param player EntityPlayer
local function EID_HandleUnknownChallenge(player)
    EID:ItemReminderAddTempDescriptionEntry(
        "{{UltraSecretRoom}}", 
        ChallengeAPI:Translate("EIDChallengeUnknown"), 
        ChallengeAPI:Translate("EIDChallengeUnknownDescription")
    )
end

-- Add a new markup icon to EID.
-- If EID is not initialized yet, it will be added to a cache to be added later.
function ChallengeAPI:EID_AddIcon(goalId, width, height, sprite, leftOffset, topOffset)   
    local shortcut = goalId
    local animName = "Idle"
    local animFrame = -1

    if ChallengeAPI.EID_HasInitialized then
        EID:addIcon(shortcut, animName, animFrame, width, height, leftOffset, topOffset, sprite)
    else
        table.insert(ChallengeAPI.EID_MarkupCache, {shortcut, animName, animFrame, width, height, leftOffset, topOffset, sprite})
    end
end

-- Add all icons in the markup cache to EID.
function ChallengeAPI:EID_AddCachedIcons()
    for _, iconData in ipairs(ChallengeAPI.EID_MarkupCache) do
        EID:addIcon(iconData[1], iconData[2], iconData[3], iconData[4], iconData[5], iconData[6], iconData[7], iconData[8])
    end

    ChallengeAPI.EID_MarkupCache = {}
end

-- Build the full description of the current challenge.
-- We will later truncate it to fit in the EID description area. 
---@param player EntityPlayer
---@return string[]
function ChallengeAPI:EID_BuildFullChallengeDescription(player)
    if not ChallengeAPI:IsInChallenge() then
        return {}
    end

    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        EID_HandleUnknownChallenge(player)
        return {}
    end
    
    local description = {}

    local challengeGoal = challenge:FetchGoal()

    local goalIcon = challengeGoal.eidIcon or ""
    
    -- Check the actual player count too, in order to resolve a niche bug
    local isSecondPlayer = (EID.ItemReminderSelectedPlayer ~= 0) and (#EID.ItemReminderGetAllPlayers() > 1)
    
    table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(ChallengeAPI:Translate("EIDGoalTemplate"), {goalIcon, challengeGoal.name}))
   
    description = ChallengeAPI.Util.AppendTable(description, challengeGoal:BuildDescriptionLines())

    if challenge.playerType ~= PlayerType.PLAYER_ISAAC then
        -- If player type is Isaac, then the information isn't useful.
        local template = ChallengeAPI:Translate("EIDStartingPlayer")

        local playerType = challenge.playerType
        if isSecondPlayer then
            playerType = playerType + 1
        end
        
        table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, {playerType, getPlayerName(playerType)}))
    end

    if challenge.isHardMode then
        table.insert(description, ChallengeAPI:Translate("EIDHardMode"))
    end

    local hasStartingItems = #challenge.startingCollectibles > 0 or #challenge.startingTrinkets > 0 or challenge.startingCard ~= nil or challenge.startingPill ~= nil

    if hasStartingItems then
        table.insert(description, ChallengeAPI:Translate("EIDStartingItems"))

        local collectibleList = challenge.startingCollectibles
        if isSecondPlayer then
            collectibleList = challenge.startingCollectiblesEsau
        end
        local collectibleCounts = {}
        for _, collectible in ipairs(collectibleList) do
            -- Combine duplicate collectibles with a multiplier.
            collectibleCounts[collectible] = (collectibleCounts[collectible] or 0) + 1
        end
        for collectible, count in pairs(collectibleCounts) do
            local template = count > 1 and ChallengeAPI:Translate("EIDStartingItemMultiple") or ChallengeAPI:Translate("EIDStartingItem")
            table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, {collectible, getCollectibleName(collectible), count}))
        end

        local trinketList = challenge.startingTrinkets
        if isSecondPlayer then
            -- No startingtrinkets2?
            -- trinketList = challenge.startingTrinketsEsau
        end
        for _, trinket in ipairs(trinketList) do
            local template = ChallengeAPI:Translate("EIDStartingTrinket")
            table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, {trinket, getTrinketName(trinket)}))
        end

        local cardList = challenge.startingCards
        if isSecondPlayer then
            -- No startingcard2?
            -- cardList = challenge.startingCardEsau
        end
        if #cardList > 0 then
            local randomCount = 0

            for _, card in ipairs(cardList) do
                if card == Card.CARD_RANDOM then
                    randomCount = randomCount + 1
                else
                    table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(ChallengeAPI:Translate("EIDStartingCard"), {card, getCardName(card)}))
                end
            end

            if randomCount > 1 then
                table.insert(description, ChallengeAPI:Translate("EIDStartingCardRandomMultiple"))
            elseif randomCount == 1 then
                table.insert(description, ChallengeAPI:Translate("EIDStartingCardRandom"))
            end
        end
    
        local pillList = challenge.startingPills
        if isSecondPlayer then
            -- No startingpill2?
            -- pillList = challenge.startingPillEsau
        end
        if #pillList > 0 then
            local randomCount = 0

            for _, pill in ipairs(pillList) do
                if pill == PillEffect.PILLEFFECT_NULL then
                    randomCount = randomCount + 1
                else
                    table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(ChallengeAPI:Translate("EIDStartingPill"), {pill, getPillName(pill)}))
                end
            end

            if randomCount > 1 then
                table.insert(description, ChallengeAPI:Translate("EIDStartingPillRandomMultiple"))
            elseif randomCount == 1 then
                table.insert(description, ChallengeAPI:Translate("EIDStartingPillRandom"))
            end
        end
    else
        -- No starting items.
    end
    
    -- TODO: Decide whether to display starting red hearts.

    if challenge.startingMaxHearts ~= 0 then
        local template = challenge.startingMaxHearts > 0 and ChallengeAPI:Translate("EIDStartingMaxHeartsBonus") or ChallengeAPI:Translate("EIDStartingMaxHeartsPenalty")
        -- Format the number to display as a whole number if it's an integer.
        local maxHearts = math.abs(challenge.startingMaxHearts / 2)
        if maxHearts % 1 == 0 then
            maxHearts = math.floor(maxHearts)
        end
        local result = ChallengeAPI.Util.ReplaceVariableStr(template, maxHearts)
        table.insert(description, result)
    end

    if challenge.startingSoulHearts ~= 0 then
        local template = challenge.startingSoulHearts > 0 and ChallengeAPI:Translate("EIDStartingSoulHeartsBonus") or ChallengeAPI:Translate("EIDStartingSoulHeartsPenalty")
        -- Format the number to display as a whole number if it's an integer.
        local soulHearts = math.abs(challenge.startingSoulHearts / 2)
        if soulHearts % 1 == 0 then
            soulHearts = math.floor(soulHearts)
        end
        local result = ChallengeAPI.Util.ReplaceVariableStr(template, soulHearts)
        table.insert(description, result)
    end

    if challenge.startingBlackHearts ~= 0 then
        local template = challenge.startingBlackHearts > 0 and ChallengeAPI:Translate("EIDStartingBlackHeartsBonus") or ChallengeAPI:Translate("EIDStartingBlackHeartsPenalty")
        -- Format the number to display as a whole number if it's an integer.
        local blackHearts = math.abs(challenge.startingBlackHearts / 2)
        if blackHearts % 1 == 0 then
            blackHearts = math.floor(blackHearts)
        end
        local result = ChallengeAPI.Util.ReplaceVariableStr(template, blackHearts)
        table.insert(description, result)
    end

    if challenge.startingCoins ~= 0 then
        local template = challenge.startingCoins > 0 and ChallengeAPI:Translate("EIDStartingCoinsBonus") or ChallengeAPI:Translate("EIDStartingCoinsPenalty")
        -- Coins is always an integer.
        local result = ChallengeAPI.Util.ReplaceVariableStr(template, math.floor(challenge.startingCoins))
        table.insert(description, result)
    end

    -- TODO: Add "Blindfold" as an EID icon.
    if challenge.isBlindfolded then
        table.insert(description, ChallengeAPI:Translate("EIDBlindfolded"))
    end

    if challenge.minimumFireRate ~= nil then
        local tearDelay = challenge:GetMaxTearDelay() or 0
        local result = ChallengeAPI.Util.ReplaceVariableStr(ChallengeAPI:Translate("EIDFixedTearDelay"), tearDelay)
        table.insert(description, result)
    end

    if challenge.startingDamageBonus ~= 0 then
        local template = challenge.startingDamageBonus > 0 and ChallengeAPI:Translate("EIDStartingDamageBonus") or ChallengeAPI:Translate("EIDStartingDamagePenalty")
        local result = ChallengeAPI.Util.ReplaceVariableStr(template, math.abs(challenge.startingDamageBonus))
        table.insert(description, result)
    end

    if challenge.isMaxDamage then
        table.insert(description, ChallengeAPI:Translate("EIDFixedDamage"))
    end

    if challenge.isMinShotSpeed then
        table.insert(description, ChallengeAPI:Translate("EIDFixedShotSpeed"))
    end

    -- TODO: Add "No Treasure Rooms" as an EID icon.
    for _,roomType in ipairs(challenge.roomFilter) do
        local roomName = ChallengeAPI:Translate("EIDRoomNames." .. roomType) or "Unknown"
        table.insert(description, "No " .. roomName)
    end
    
    for _,curse in ipairs(challenge.curse) do
        local line = ChallengeAPI:Translate("EIDCurse." .. curse) or ""
        table.insert(description, line)
    end
    
    for _,curse in ipairs(challenge.curseFilter) do
        local line = ChallengeAPI:Translate("EIDCurseFilter." .. curse) or ""
        table.insert(description, line)
    end

    description = ChallengeAPI.Util.AppendTable(description, challenge:BuildDescriptionLines())

    return description
end

-- Display information about the current challenge in the "Current Challenge" category of EID.
---@param player EntityPlayer
function ChallengeAPI:EID_HandleChallengeInfo(player)
    if not ChallengeAPI:IsInChallenge() then
        return
    end

    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        EID_HandleUnknownChallenge(player)
        return
    end

    local description = ChallengeAPI:EID_BuildFullChallengeDescription(player)

    local descLineCount = #description

    local position = EID.ItemReminderSelectedItems[EID.ItemReminderSelectedCategory]
    -- Clamp the position
    if position < 0 then
        EID.ItemReminderSelectedItems[EID.ItemReminderSelectedCategory] = 0
    elseif position > descLineCount then
        EID.ItemReminderSelectedItems[EID.ItemReminderSelectedCategory] = descLineCount
    end

    local startIndex = position + 1
    local endIndex = startIndex + ChallengeAPI.EID_DescriptionLineCount

    if descLineCount < endIndex then
        endIndex = descLineCount
    end

    local visibleDescription = {}
    for i = startIndex, endIndex do
        table.insert(visibleDescription, description[i])
    end

    -- EID description line separator is "#"
    local descString = table.concat(visibleDescription, "#")

    EID:ItemReminderAddTempDescriptionEntry(EID:GetPlayerIcon(player:GetPlayerType()), "{{NoLB}}" .. challenge.name, descString)
end

-- Handle the scrollbar for the "Current Challenge" category in EID.
---@param player EntityPlayer
function ChallengeAPI:EID_HandleChallengeScrollbar(player)
    if not ChallengeAPI:IsInChallenge() then
        return
    end

    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        return
    end

    local descLineCount = #ChallengeAPI:EID_BuildFullChallengeDescription(player)
    if descLineCount <= ChallengeAPI.EID_DescriptionLineCount then
        return ""
    end

    local position = EID.ItemReminderSelectedItems[EID.ItemReminderSelectedCategory]
    -- Clamp the position
    if position < 0 then
        EID.ItemReminderSelectedItems[EID.ItemReminderSelectedCategory] = 0
    elseif position > descLineCount then
        EID.ItemReminderSelectedItems[EID.ItemReminderSelectedCategory] = descLineCount
    end

    local upButton = EID.ButtonToIconMap[EID.Config["ItemReminderNavigateUpButton"]]
    local downButton = EID.ButtonToIconMap[EID.Config["ItemReminderNavigateDownButton"]]

    local currentLine = position + 1
    
    local scrollbarDesc = "{{Blank}} {{NoLB}} " .. upButton .. " (" .. currentLine .. "/" .. descLineCount .. ") " .. downButton .. "#"

    return scrollbarDesc
end

function ChallengeAPI:EID_EnableIntegration(_)
    if not isEIDEnabled() then
        ChallengeAPI.Log("EID integration disabled.")
        return
    end
    
    injectEIDCategory()
    ChallengeAPI:EID_ApplyLanguageData()
    ChallengeAPI:EID_AddCachedIcons()
    
    ChallengeAPI.EID_HasInitialized = true

    ChallengeAPI.Log("EID integration enabled.")
end
