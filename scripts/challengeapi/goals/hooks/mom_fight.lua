-- Handles functionality for managing the fight against Mom in Depths 2.

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

---@param doorSlot DoorSlot
local function trySpawnDoor(doorSlot)
    local room = Game():GetRoom()

    local doorAtSlot = room:GetDoor(doorSlot)
    local doorPosition = room:GetDoorSlotPosition(doorSlot)
    if doorAtSlot ~= nil then
        ChallengeAPI.Log("Can't spawn door at occupied slot! ", doorSlot)

        local gridEntity = room:GetGridEntityFromPos(doorPosition):ToDoor()
        ChallengeAPI.Log(gridEntity:GetVariant())
        
        return
    end

    doorPosition.X = doorPosition.X - 1

    ChallengeAPI.Log(doorPosition)

    -- NOTE: This line seems to always return nil!
    local result = Isaac.GridSpawn(GridEntityType.GRID_DOOR, DoorVariant.DOOR_LOCKED, doorPosition, true)

    if not result or not result:ToDoor() then
        ChallengeAPI.Log("Tried and failed to spawn door!")
    end
end

-- Handle reopening the boss door 
local function onPostNewRoom(_mod)
    if not isHookValid() then
        return
    end

    ChallengeAPI.Log("Entered a new room.")

    local level = Game():GetLevel()
    local levelStage = level:GetAbsoluteStage()
    local stageType = level:GetStageType()
    local roomType = Game():GetRoom():GetType()
    local isRoomCleared = Game():GetRoom():IsClear()
    
    if levelStage == LevelStage.STAGE3_2
        and (stageType == StageType.STAGETYPE_ORIGINAL or stageType == StageType.STAGETYPE_AFTERBIRTH or stageType == StageType.STAGETYPE_WOTL)
        and roomType == RoomType.ROOM_BOSS then
        ChallengeAPI.Log("Entered the Mom boss room!")

        if isRoomCleared then
            ChallengeAPI.Log("Room is already cleared.")

            local currentIndex = level:GetCurrentRoomIndex()

            local leftIndex = currentIndex - 1
            local isLeftRoom = level:GetRoomByIdx(leftIndex, -1).Data ~= nil
            local rightIndex = currentIndex + 1
            local isRightRoom = level:GetRoomByIdx(rightIndex, -1).Data ~= nil
            local upIndex = currentIndex - 13
            local isUpRoom = level:GetRoomByIdx(upIndex, -1).Data ~= nil
            local downIndex = currentIndex + 13
            local isDownRoom = level:GetRoomByIdx(downIndex, -1).Data ~= nil

            if isLeftRoom then
                ChallengeAPI.Log(Game():GetRoom():GetDoor(DoorSlot.LEFT0) == nil)
                ChallengeAPI.Log("Spawning door on Left")
                trySpawnDoor(DoorSlot.LEFT0)
            elseif isRightRoom then
                ChallengeAPI.Log(Game():GetRoom():GetDoor(DoorSlot.RIGHT0) == nil)
                ChallengeAPI.Log("Spawning door on Right")
                trySpawnDoor(DoorSlot.RIGHT0)
            elseif isUpRoom then
                ChallengeAPI.Log(Game():GetRoom():GetDoor(DoorSlot.UP0) == nil)
                ChallengeAPI.Log("Spawning door on Up")
                trySpawnDoor(DoorSlot.UP0)
            elseif isDownRoom then
                ChallengeAPI.Log(Game():GetRoom():GetDoor(DoorSlot.DOWN0) == nil)
                ChallengeAPI.Log("Spawning door on Down")
                trySpawnDoor(DoorSlot.DOWN0)
            end
        end
    end
end

local function onPostMomKill(_mod)
    ChallengeAPI.Log("Mom has been killed!")
end

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, onPostNewRoom)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, onPostMomKill, EntityType.ENTITY_MOM)
ChallengeAPI:AddCallback(ModCallbacks.MC_USE_ITEM, onPostNewRoom)
