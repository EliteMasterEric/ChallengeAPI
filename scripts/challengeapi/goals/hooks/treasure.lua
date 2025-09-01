-- Handles functionality for ensuring or preventing treasure in treasure rooms from spawning.

-- If a Treasure Room or Planetarium spawns when it shouldn't, we replace the treasure with a poop.
-- We also prevent the door from requiring a lock so you don't spend a key on a poop.

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

---@param entityType EntityType
---@param variant integer
---@param subType integer
---@param position Vector
local function onPreEntitySpawn(_mod, entityType, variant, subType, position)
    if not isHookValid() then
        return
    end

    local isTreasure = entityType == EntityType.ENTITY_PICKUP and variant == PickupVariant.PICKUP_COLLECTIBLE

    if not isTreasure then
        return
    end

    -- If the hook is valid, we are in a challenge where treasure rooms are filtered.
    -- If the game bugs and a treasure room spawns anyway, we need to replace any items that spawn in it.

    -- ChallengeAPI.Log("A collectible is spawning!")

    local room = Game():GetRoom()
    if room:GetType() ~= RoomType.ROOM_TREASURE and room:GetType() ~= RoomType.ROOM_PLANETARIUM then
        -- ChallengeAPI.Log("It's not in a Treasure Room or Planetarium tho...")
        return
    end

    ChallengeAPI.Log("Collectible spawning in a Treasure room or Planetarium, but we're on a challenge that doesn't spawn treasure rooms!")
    
    local roomDescriptor = Game():GetLevel():GetCurrentRoomDesc()
    -- If roomDescriptor.Flags includes RED_ROOM, ignore it.
    if roomDescriptor.Flags & RoomDescriptor.FLAG_RED_ROOM == RoomDescriptor.FLAG_RED_ROOM then
        ChallengeAPI.Log("It's in a Red Room tho...")
        return
    end

    -- ChallengeAPI.Log("It's not spawning in a Red room!")

    -- We are in a treasure room, that is not in a Red Room, and we are spawning a collectible,
    -- and the room filter is supposed to be active.

    -- Replace the entity with a poop.

    -- Spawn a poop at that position.
    ChallengeAPI.Log("Replacing treasure with Poop...")
    local poop = Isaac.GridSpawn(GridEntityType.GRID_POOP, GridPoopVariant.NORMAL, position, true)
    
    -- Remove the entity that would spawn by spawning a "Poof" particle effect instead.
    
    return {EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, 0}
end

local function handleDeletingDoors()
    -- ChallengeAPI.Log("Room cleared!")

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
    for index,doorSlot in ipairs(doorSlots) do
        local door = room:GetDoor(doorSlot)
        if door ~= nil then
            local isTreasureDoor = door:IsRoomType(RoomType.ROOM_TREASURE) or door:IsRoomType(RoomType.ROOM_PLANETARIUM)

            if isTreasureDoor then
                -- Open the door for free, so that you don't lose any resources from opening a corrected treasure room.
                --ChallengeAPI.Log("Unlocking a filtered Treasure Room door for free!")
                -- door:SetLocked(false)

                -- Destroy the door so people think the room doesn't exist.
                ChallengeAPI.Log("Destroying a filtered Treasure Room door!")
                room:RemoveDoor(doorSlot)
            end
        end
    end
end

local function blindScreenInTreasureRoom()
    local room = Game():GetRoom()
    if room:GetType() == RoomType.ROOM_TREASURE or room:GetType() == RoomType.ROOM_PLANETARIUM then
        ChallengeAPI.Util.BlindPlayerWithWhite()
    end
end

local function evacuateTreasureRoom()
    local room = Game():GetRoom()
    if room:GetType() == RoomType.ROOM_TREASURE or room:GetType() == RoomType.ROOM_PLANETARIUM then
        ChallengeAPI.Util.EjectFromRoom()
    end
end

local function onRoomClear(_mod)
    if not isHookValid() then
        return
    end

    handleDeletingDoors()
end

local function onPostRender(_mod)
    if not isHookValid() then
        return
    end

    ChallengeAPI.Util.HideAllRoomsOfTypeOnMinimap(RoomType.ROOM_TREASURE)
    ChallengeAPI.Util.HideAllRoomsOfTypeOnMinimap(RoomType.ROOM_PLANETARIUM)

    blindScreenInTreasureRoom()
end

local function onPostNewRoom(_mod)
    if not isHookValid() then
        return
    end

    handleDeletingDoors()

    evacuateTreasureRoom()
end

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_RENDER, onPostRender)
ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, onPreEntitySpawn)
ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, onRoomClear)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, onPostNewRoom)