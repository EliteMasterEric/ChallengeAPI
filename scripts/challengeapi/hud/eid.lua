-- Handles the custom category in External Item Descriptions

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
        -- true: show only one entry at a time but allow pressing up/down to scroll
        isScrollable = false,
        -- true: hide content in overview tab.
        hideInOverview = false,
        entryGenerators = {
            function(player) 
                ChallengeAPI:EID_ItemReminderHandleChallengeInfo(player)
            end
        }
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
    return EID:getObjectName(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, id)
end

local function getTrinketName(id)
    return EID:getObjectName(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, id)
end

---@param player EntityPlayer
function ChallengeAPI:EID_ItemReminderHandleChallengeInfo(player)
    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        return
    end
    
    local description = {
        "{{Trophy}} Goal: " .. challenge:FetchGoal().name, -- TODO: Add goal icons as EID icons
    }
    
    if challenge.playerType ~= PlayerType.PLAYER_ISAAC then
        -- If player type is Isaac, then the information isn't useful.
        local template = ChallengeAPI:GetLanguageData().EIDStartingPlayer
        table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, {challenge.playerType, getPlayerName(challenge.playerType)}))
    end

    if challenge.isHardMode then
        table.insert(description, ChallengeAPI:GetLanguageData().EIDHardMode)
    end

    if #challenge.startingCollectibles > 0 then
        table.insert(description, ChallengeAPI:GetLanguageData().EIDStartingItems)
        for _, collectible in ipairs(challenge.startingCollectibles) do
            local template = ChallengeAPI:GetLanguageData().EIDStartingItem
            table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, {collectible, getCollectibleName(collectible)}))
        end
    else
        table.insert(description, ChallengeAPI:GetLanguageData().EIDStartingItems_None)
    end

    if #challenge.startingTrinkets > 0 then
        table.insert(description, ChallengeAPI:GetLanguageData().EIDStartingTrinkets)
        for _, trinket in ipairs(challenge.startingTrinkets) do
            local template = ChallengeAPI:GetLanguageData().EIDStartingTrinket
            table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, {trinket, getTrinketName(trinket)}))
        end
    end

    if challenge.startingCard ~= nil then
        local template = ChallengeAPI:GetLanguageData().EIDStartingCard
        table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, {challenge.startingCard, getCardName(challenge.startingCard)}))
    end

    if challenge.startingPill ~= nil then
        local template = ChallengeAPI:GetLanguageData().EIDStartingPill
        table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, {challenge.startingPill, getPillName(challenge.startingPill)}))
    end

    -- TODO: Add "Blindfold" as an EID icon.
    if challenge.isBlindfolded then
        table.insert(description, ChallengeAPI:GetLanguageData().EIDBlindfolded)
    end

    -- TODO: Add "No Treasure Rooms" as an EID icon.
    for _,roomType in ipairs(challenge.roomFilter) do
        local roomName = ChallengeAPI:GetLanguageData().EIDRoomNames[roomType] or "Unknown"
        table.insert(description, "No " .. roomName)
    end

    for _,curse in ipairs(challenge.curse) do
        print("+" .. curse)
        local curseName = ChallengeAPI:GetLanguageData().EIDCurseNames[curse] or "Unknown"
        local line = ChallengeAPI.Util.ReplaceVariableStr(ChallengeAPI:GetLanguageData().EIDCurseAlways, curseName)
        table.insert(description, line)
    end

    for _,curse in ipairs(challenge.curseFilter) do
        print("-" .. curse)
        local curseName = ChallengeAPI:GetLanguageData().EIDCurseNames[curse] or "Unknown"
        local line = ChallengeAPI.Util.ReplaceVariableStr(ChallengeAPI:GetLanguageData().EIDCurseNever, curseName)
        table.insert(description, line)
    end

    -- TODO: Decide whether to display starting red hearts.

    if challenge.startingMaxHearts ~= 0 then
        local template = challenge.startingMaxHearts > 0 and ChallengeAPI:GetLanguageData().EIDStartingMaxHeartsBonus or ChallengeAPI:GetLanguageData().EIDStartingMaxHeartsPenalty
        table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, math.abs(challenge.startingMaxHearts)))
    end

    if challenge.startingSoulHearts ~= 0 then
        local template = challenge.startingSoulHearts > 0 and ChallengeAPI:GetLanguageData().EIDStartingSoulHeartsBonus or ChallengeAPI:GetLanguageData().EIDStartingSoulHeartsPenalty
        table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, math.abs(challenge.startingSoulHearts)))
    end

    if challenge.startingBlackHearts ~= 0 then
        local template = challenge.startingBlackHearts > 0 and ChallengeAPI:GetLanguageData().EIDStartingBlackHeartsBonus or ChallengeAPI:GetLanguageData().EIDStartingBlackHeartsPenalty
        table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, math.abs(challenge.startingBlackHearts)))
    end

    if challenge.startingCoins ~= 0 then
        local template = challenge.startingCoins > 0 and ChallengeAPI:GetLanguageData().EIDStartingCoinsBonus or ChallengeAPI:GetLanguageData().EIDStartingCoinsPenalty
        table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, math.abs(challenge.startingCoins)))
    end

    if challenge.minimumFireRate ~= nil then
        local tearDelay = challenge:GetMaxTearDelay() or 0
        local line = ChallengeAPI.Util.ReplaceVariableStr(ChallengeAPI:GetLanguageData().EIDFixedTearDelay, tearDelay)
        table.insert(description, line)
    end

    if challenge.startingDamageBonus ~= 0 then
        local template = challenge.startingDamageBonus > 0 and ChallengeAPI:GetLanguageData().EIDStartingDamageBonus or ChallengeAPI:GetLanguageData().EIDStartingDamagePenalty
        table.insert(description, ChallengeAPI.Util.ReplaceVariableStr(template, math.abs(challenge.startingDamageBonus)))
    end

    if challenge.isMaxDamage then
        table.insert(description, ChallengeAPI:GetLanguageData().EIDFixedDamage)
    end

    if challenge.isMinShotSpeed then
        table.insert(description, ChallengeAPI:GetLanguageData().EIDFixedShotSpeed)
    end

    -- EID description line separator is "#"
    local descString = table.concat(description, "#")

    EID:ItemReminderAddTempDescriptionEntry(EID:GetPlayerIcon(player:GetPlayerType()), challenge.name, descString)
end

function ChallengeAPI:EID_EnableIntegration(_)
    if not isEIDEnabled() then
        ChallengeAPI.Log("EID integration disabled.")
        return
    end

    ChallengeAPI.Log("EID integration enabled.")
    injectEIDCategory()
    ChallengeAPI:EID_ApplyLanguageData()

    ChallengeAPI.Log("ChallengeAPI: Injected EID language data.")
    ChallengeAPI.Log(EID.descriptions["en_us"].ItemReminder.CategoryNames.Overview)
    ChallengeAPI.Log(EID.descriptions["en_us"].ItemReminder.CategoryNames.ChallengeAPI)
end

local function onPostGameStarted(_)
    ChallengeAPI.Log("New run started. Checking for challenge status...")

    if not ChallengeAPI:IsInChallenge() then
        ChallengeAPI.Log("Not in a challenge.")
        return
    end

    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        ChallengeAPI.Log("ERROR: Couldn't determine current challenge.")
        if ChallengeAPI.challenges:GetLength() == 0 then
            ChallengeAPI.Log("NOTE: No challenges registered. Did you forget to initialize them?")
        end
        return
    end

    ChallengeAPI.Log("We are in challenge: " .. challenge.name)
    ChallengeAPI.Log("The goal is: " .. challenge:FetchGoal().name)
end

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, onPostGameStarted)