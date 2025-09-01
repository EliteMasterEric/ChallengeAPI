-- Handles functionality for ensuring or preventing Angel deals or Devil rooms spawn.

-- Determine whether the hooks in this module are valid for the current challenge.
---@return boolean Whether the hooks are valid.
local function isHookValid()
    if not ChallengeAPI:AreHooksActive() then
        return false
    end

    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        return false
    end
    
    if not challenge:IsRoomFilterActive(RoomType.ROOM_TREASURE) then
        return false
    end

    return true
end

-- Override all previous calculation values and dictate the devil chance.
-- NOTE: Only gets called if REPENTOGON is active.
---@param baseChance number The base chance of the devil deal.
local function onPostDevilCalculate(_mod, baseChance)
    if not ChallengeAPI:AreHooksActive() then
        return nil
    end

    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        return nil
    end

    local devilsBlocked = challenge:IsRoomFilterActive(RoomType.ROOM_DEVIL)
    local angelsBlocked = challenge:IsRoomFilterActive(RoomType.ROOM_ANGEL)

    if devilsBlocked and angelsBlocked then
        -- Force both Devil and Angel room chances to 0%.
        return 0.0
    elseif devilsBlocked then
        -- Add 50% to the 50/50 Angel deal chance. This probably works.
        Game():GetLevel():AddAngelRoomChance(0.50)
        return nil
    elseif angelsBlocked then
        -- TODO: How???
        return nil
    end

    return nil
end

-- Deletes invalid deal doors if they appear.
-- Used to filter deals if REPENTOGON is not active.
local function handleDeletingDoors()
    if not ChallengeAPI:AreHooksActive() then
        return
    end

    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        return
    end

    local doorSlots = {
        DoorSlot.LEFT0,
        DoorSlot.UP0,
        DoorSlot.RIGHT0,
        DoorSlot.DOWN0,
        DoorSlot.LEFT1,
        DoorSlot.UP1,
        DoorSlot.RIGHT1,
        DoorSlot.DOWN1
    }

    local room = Game():GetRoom()
    for index, doorSlot in ipairs(doorSlots) do
        local door = room:GetDoor(doorSlot)
        if door ~= nil then
            local invalidDevilRoom = door:IsRoomType(RoomType.ROOM_DEVIL) and challenge:IsRoomFilterActive(RoomType.ROOM_DEVIL)
            if invalidDevilRoom then
                -- Destroy the door so people think the room doesn't exist.
                ChallengeAPI.Log("Destroying a filtered Devil Room door!")
                room:RemoveDoor(doorSlot)
            end
            
            local invalidAngelRoom = door:IsRoomType(RoomType.ROOM_ANGEL) and challenge:IsRoomFilterActive(RoomType.ROOM_ANGEL)
            if invalidAngelRoom then
                -- Destroy the door so people think the room doesn't exist.
                ChallengeAPI.Log("Destroying a filtered Angel Room door!")
                room:RemoveDoor(doorSlot)
            end
        end
    end
end

-- Blinds the screen in deal rooms if REPENTOGON is not active.
-- Part of the eject functionality in the event the player uses a Joker card.
local function blindScreenInDealRooms()
    if not ChallengeAPI:AreHooksActive() then
        return
    end

    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        return
    end

    local room = Game():GetRoom()
    local invalidDevilRoom = room:GetType() == RoomType.ROOM_DEVIL and challenge:IsRoomFilterActive(RoomType.ROOM_DEVIL)
    local invalidAngelRoom = room:GetType() == RoomType.ROOM_ANGEL and challenge:IsRoomFilterActive(RoomType.ROOM_ANGEL)

    if invalidDevilRoom or invalidAngelRoom then
        ChallengeAPI.Util.BlindScreenWithWhite()
    end
end

-- Ejects the player from deal rooms if REPENTOGON is not active.
-- Part of the eject functionality in the event the player uses a Joker card.
local function evacuateDealRooms()
    if not ChallengeAPI:AreHooksActive() then
        return
    end

    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        return
    end

    local room = Game():GetRoom()
    local invalidDevilRoom = room:GetType() == RoomType.ROOM_DEVIL and challenge:IsRoomFilterActive(RoomType.ROOM_DEVIL)
    local invalidAngelRoom = room:GetType() == RoomType.ROOM_ANGEL and challenge:IsRoomFilterActive(RoomType.ROOM_ANGEL)

    if invalidDevilRoom or invalidAngelRoom then
        ChallengeAPI.Util.EjectFromRoom()
    end
end

local function onRoomClear(_mod)
    handleDeletingDoors()
end

local function onPostRender(_mod)
    if not isHookValid() then
        return
    end

    blindScreenInDealRooms()
end

local function onPostNewRoom(_mod)
    handleDeletingDoors()

    evacuateDealRooms()
end


ChallengeAPI:AddCallback(ModCallbacks.MC_POST_RENDER, onPostRender)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_DEVIL_CALCULATE, onPostDevilCalculate)
ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, onRoomClear)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, onPostNewRoom)