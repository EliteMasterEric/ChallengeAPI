-- Handles functionality for managing the fight against Mom in Depths 2.

local BOSS_DOOR_GRAPHIC = "gfx/grid/door_10_bossroomdoor.anm2"

local DOOR_ROTATION = {
    [DoorSlot.RIGHT0] = 90,
    [DoorSlot.RIGHT1] = 90,
    [DoorSlot.LEFT0] = 270,
    [DoorSlot.LEFT1] = 270,
    [DoorSlot.UP0] = 0,
    [DoorSlot.UP1] = 0,
    [DoorSlot.DOWN0] = 180,
    [DoorSlot.DOWN1] = 180,
}

local DOOR_OFFSET = {
    [DoorSlot.RIGHT0] = Vector(-20, -30),
    [DoorSlot.RIGHT1] = Vector(-20, -30),
    [DoorSlot.LEFT0] = Vector(20, -30),
    [DoorSlot.LEFT1] = Vector(20, -30),
    [DoorSlot.UP0] = Vector(0, 0),
    [DoorSlot.UP1] = Vector(0, 0),
    [DoorSlot.DOWN0] = Vector(0, -40),
    [DoorSlot.DOWN1] = Vector(0, -40),
}

local FAKE_DOOR_ID = 4269

local fakeDoorData = {}

local handledMomDeath = false

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

    if goal.momDoorMode ~= ChallengeAPI.Enum.GoalMomDoorMode.NORMAL then
        return true
    end

    return false
end

-- Handles the logic for the fake boss door.
local function onPostEffectRender(_mod, entity)
    if not isHookValid() then
        return
    end

    if fakeDoorData[GetPtrHash(entity)] then
        local player = Isaac.GetPlayer(0)
        local playerPosition = player.Position
        local doorPosition = entity.Position

        local distanceSquared = doorPosition:DistanceSquared(playerPosition)

        if distanceSquared < 520 then
            if fakeDoorData[GetPtrHash(entity)].cooldown > 0 then
                return
            end
            
            local level = Game():GetLevel()
            local currentIndex = level:GetCurrentRoomIndex()

            local leftIndex = currentIndex - 1
            local isLeftRoom = leftIndex >= 0 and level:GetRoomByIdx(leftIndex, -1).Data ~= nil
            local rightIndex = currentIndex + 1
            local isRightRoom = rightIndex >= 0 and level:GetRoomByIdx(rightIndex, -1).Data ~= nil
            local upIndex = currentIndex - 13
            local isUpRoom = upIndex >= 0 and level:GetRoomByIdx(upIndex, -1).Data ~= nil
            local downIndex = currentIndex + 13
            local isDownRoom = downIndex >= 0 and level:GetRoomByIdx(downIndex, -1).Data ~= nil

            -- Force a room transition
            if isLeftRoom then
                -- level.LeaveDoor determines where the player will leave from after the room transition
                -- realIndex determines the index of the target room, accounting for 2x2 rooms
                local realIndex = level:GetRoomByIdx(leftIndex, -1).GridIndex
                level.LeaveDoor = Direction.LEFT
                Game():StartRoomTransition(realIndex, Direction.LEFT, RoomTransitionAnim.WALK)
            elseif isRightRoom then
                local realIndex = level:GetRoomByIdx(rightIndex, -1).GridIndex
                level.LeaveDoor = Direction.RIGHT
                Game():StartRoomTransition(realIndex, Direction.RIGHT, RoomTransitionAnim.WALK)
            elseif isUpRoom then
                local realIndex = level:GetRoomByIdx(upIndex, -1).GridIndex
                level.LeaveDoor = Direction.UP
                Game():StartRoomTransition(realIndex, Direction.UP, RoomTransitionAnim.WALK)
            elseif isDownRoom then
                local realIndex = level:GetRoomByIdx(downIndex, -1).GridIndex
                level.LeaveDoor = Direction.DOWN
                Game():StartRoomTransition(realIndex, Direction.DOWN, RoomTransitionAnim.WALK)
            end
            entity:Remove()
            fakeDoorData[GetPtrHash(entity)] = nil
        elseif fakeDoorData[GetPtrHash(entity)].cooldown > 0 then
            fakeDoorData[GetPtrHash(entity)].cooldown = fakeDoorData[GetPtrHash(entity)].cooldown - 1
        end
    end
end

-- Spawns a "door" on the given wall.
-- Don't look at this code, it's horrifying.
---@param doorSlot DoorSlot
local function trySpawnDoor(doorSlot)
    local room = Game():GetRoom()

    -- BUG FIX: Sometimes there is already a door (like Boss Rush or Devil Deal) in the spot where the door SHOULD be. We sadly can't ftell 
    -- SOLUTION: Try placing the door on a different wall.
    -- This sacrifices visuals (wonky transitions) for the sake of keeping the game functional.
    local doorAtSlot = room:GetDoor(doorSlot)
    if doorAtSlot ~= nil then
        ChallengeAPI.Log("Door already exists at slot " .. doorSlot .. ".")
        local nextSlot = doorSlot + 1
        if nextSlot > DoorSlot.DOWN0 then
            nextSlot = DoorSlot.LEFT0
        end
        trySpawnDoor(nextSlot)
        return
    end

    local doorPosition = room:GetDoorSlotPosition(doorSlot)

    local fakeDoor = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DEVIL, FAKE_DOOR_ID + doorSlot, doorPosition, Vector.Zero, nil)
    fakeDoor.Position = doorPosition + DOOR_OFFSET[doorSlot]
    fakeDoor:GetSprite():Load(BOSS_DOOR_GRAPHIC, true)
    fakeDoor:GetSprite():Play("Opened", true)
    fakeDoor:GetSprite().Rotation = DOOR_ROTATION[doorSlot]
    fakeDoor.DepthOffset = -9999

    fakeDoorData[GetPtrHash(fakeDoor)] = {
        doorSlot = doorSlot,
        cooldown = 30,
    }

    ChallengeAPI.Log("Spawned fake door at slot " .. doorSlot .. ".")

    -- Enable the postEffectRender callback
    ChallengeAPI:AddCallback(ModCallbacks.MC_POST_EFFECT_RENDER, onPostEffectRender, EffectVariant.DEVIL)
end

local function handleClearedBossRoom()
    local level = Game():GetLevel()
    local currentIndex = level:GetCurrentRoomIndex()

    local leftIndex = currentIndex - 1
    local isLeftRoom = leftIndex > 0 and level:GetRoomByIdx(leftIndex, -1).Data ~= nil
    local rightIndex = currentIndex + 1
    local isRightRoom = rightIndex > 0 and level:GetRoomByIdx(rightIndex, -1).Data ~= nil
    local upIndex = currentIndex - 13
    local isUpRoom = upIndex > 0 and level:GetRoomByIdx(upIndex, -1).Data ~= nil
    local downIndex = currentIndex + 13
    local isDownRoom = downIndex > 0 and level:GetRoomByIdx(downIndex, -1).Data ~= nil

    if isLeftRoom then
        ChallengeAPI.Log("Spawning fake door at LEFT0, towards ", leftIndex)
        trySpawnDoor(DoorSlot.LEFT0)
    end
    if isRightRoom then
        ChallengeAPI.Log("Spawning fake door at RIGHT0, towards ", rightIndex)
        trySpawnDoor(DoorSlot.RIGHT0)
    end
    if isUpRoom then
        ChallengeAPI.Log("Spawning fake door at UP0, towards ", upIndex)
        trySpawnDoor(DoorSlot.UP0)
    end
    if isDownRoom then
        ChallengeAPI.Log("Spawning fake door at DOWN0, towards ", downIndex)
        trySpawnDoor(DoorSlot.DOWN0)
    end
end

-- Handle reopening the boss door 
local function onPostNewRoom(_mod)
    handledMomDeath = false

    if not isHookValid() then
        return
    end

    local level = Game():GetLevel()
    local levelStage = level:GetAbsoluteStage()
    local stageType = level:GetStageType()
    local roomType = Game():GetRoom():GetType()
    local isRoomCleared = Game():GetRoom():IsClear()
    
    local isOnMomStage = (levelStage == LevelStage.STAGE3_2)
        and (stageType == StageType.STAGETYPE_ORIGINAL or stageType == StageType.STAGETYPE_AFTERBIRTH or stageType == StageType.STAGETYPE_WOTL)

    if isOnMomStage and roomType == RoomType.ROOM_BOSS then
        if isRoomCleared then
            handleClearedBossRoom()
        end
    end
end

-- Called after a collectible spawns.
---@param _mod table The mod calling this callback.
---@param entity EntityPickup The entity that was spawned.
local function postCollectibleInit(_mod, entity)
    if not isHookValid() then
        return
    end

    if entity.SubType == CollectibleType.COLLECTIBLE_POLAROID or entity.SubType == CollectibleType.COLLECTIBLE_NEGATIVE then
        -- The door out of the Mom fight will spawn on its own when she is killed,
        -- if we are on Repentance+ and we are in a challenge.
        -- This is due to the code for handling the Beast daily run.
        local willMomDoorSpawnOnItsOwn = ChallengeAPI.IsRepentancePlus and not Game().Challenge == Challenge.CHALLENGE_NULL

        
        if not handledMomDeath and not willMomDoorSpawnOnItsOwn then
            local isInDeathCertificateDimension = ChallengeAPI.Util.IsInDimension(2)

            if isInDeathCertificateDimension then
                ChallengeAPI.Log("Mom didn't actually die, we're in the Death Certificate dimension.")
                return
            end

            ChallengeAPI.Log("Mom has died, spawning a door!")
            handleClearedBossRoom()
            handledMomDeath = true
        else
            ChallengeAPI.Log("Mom has died, but we already handled it.")
        end
    end
end

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, postCollectibleInit, PickupVariant.PICKUP_COLLECTIBLE)

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, onPostNewRoom)
