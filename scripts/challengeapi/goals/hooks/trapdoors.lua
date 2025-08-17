-- Handles functionality for ensuring or preventing trapdoors from spawning.

local DOOR_POS_UPLEFT = Vector(280, 200)
local DOOR_POS_DOWNLEFT = Vector(280, 280)
local DOOR_POS_UPCENTER = Vector(320, 200)
local DOOR_POS_DOWNCENTER = Vector(320, 280)
local DOOR_POS_UPRIGHT = Vector(360, 200)
local DOOR_POS_DOWNRIGHT = Vector(360, 280)

local trapdoorCache = {}

-- Determine whether the hooks in this module are valid for the current challenge.
---@return boolean Whether the hooks are valid.
local function isHookValid()
    if not ChallengeAPI:AreHooksActive() then
        return false
    end

    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return false
    end

    return true
end

local function isGridPosOccupied(position)
    local gridEntity = Game():GetRoom():GetGridEntityFromPos(position)
    if gridEntity == nil then
        return false
    end
    local isEmpty = (gridEntity.Desc.Type == GridEntityType.GRID_NULL) or (gridEntity.Desc.Type == GridEntityType.GRID_DECORATION)
    return not isEmpty
end

---@param gridEntity GridEntity
local function destroyTrapdoor(gridEntity)
    Game():GetRoom():RemoveGridEntity (gridEntity:GetGridIndex(), 0, true)
    gridEntity:Destroy(true)
    gridEntity:Update()

    trapdoorCache[ChallengeAPI.Util.GetGridEntityPtrHash(gridEntity)] = false
end

---@param entityEffect EntityEffect
local function destroyBeam(entityEffect)
    entityEffect:Kill()
end

local function spawnTrapdoor(left)
    if left then
        if not isGridPosOccupied(DOOR_POS_UPLEFT) then
            Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, DOOR_POS_UPLEFT, true)
        elseif not isGridPosOccupied(DOOR_POS_DOWNLEFT) then
            Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, DOOR_POS_DOWNLEFT, true)
        else
            ChallengeAPI.Log("Couldn't place trapdoor, no space!")
        end
    else
        if not isGridPosOccupied(DOOR_POS_DOWNCENTER) then
        elseif not isGridPosOccupied(DOOR_POS_UPCENTER) then
            Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, DOOR_POS_UPCENTER, true)
            Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, DOOR_POS_DOWNCENTER, true)
        else
            ChallengeAPI.Log("Couldn't place trapdoor, no space!")
        end
    end
end

local function spawnBeam(right)
    if right then
        if not isGridPosOccupied(DOOR_POS_UPRIGHT) then
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEAVEN_LIGHT_DOOR, 0, DOOR_POS_UPRIGHT, Vector(0, 0), nil)
        elseif not isGridPosOccupied(DOOR_POS_DOWNRIGHT) then
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEAVEN_LIGHT_DOOR, 0, DOOR_POS_DOWNRIGHT, Vector(0, 0), nil)
        else
            ChallengeAPI.Log("Couldn't place beam, no space!")
        end
    else
        if not isGridPosOccupied(DOOR_POS_DOWNCENTER) then
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEAVEN_LIGHT_DOOR, 0, DOOR_POS_UPCENTER, Vector(0, 0), nil)
        elseif not isGridPosOccupied(DOOR_POS_UPCENTER) then
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEAVEN_LIGHT_DOOR, 0, DOOR_POS_DOWNCENTER, Vector(0, 0), nil)
        else
            ChallengeAPI.Log("Couldn't place beam, no space!")
        end
    end
end

-- Checks the trapdoor as it spawns to see if it should be modified or deleted.
-- Gets called both by bosses and by other effects like We Need To Go Deeper.
---@param gridEntity GridEntity The grid entity for the trapdoor.
local function checkTrapdoor(_mod, gridEntity)
    if not isHookValid() then
        return
    end

    -- ChallengeAPI.Log("Trapdoor spawned! ", gridEntity.Position)

    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return nil
    end

    local currentStage = Game():GetLevel():GetAbsoluteStage()

    -- ChallengeAPI.Log("Current stage: ", currentStage)
    if currentStage == LevelStage.STAGE3_2 then
        local isSecretPathDoor = Game():GetLevel():GetCurrentRoomIndex() == GridRooms.ROOM_SECRET_EXIT_IDX
        local isGenesis = Game():GetLevel():GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX
        local isErrorRoomTrapdoor = Game():GetLevel():GetCurrentRoomIndex() == GridRooms.ROOM_ERROR_IDX
        local shouldSpawnWombDoor = (not goal.mustFightBeast)
    
        ChallengeAPI.Log("Should spawn womb door? ", shouldSpawnWombDoor)

        if isSecretPathDoor then
            return
        end

        if not shouldSpawnWombDoor then
            if isErrorRoomTrapdoor or isGenesis then
                -- TODO: Guarantee this goes to Mausoleum 2
                spawnBeam(false)
            end

            -- Prevent trapdoor spawn.
            destroyTrapdoor(gridEntity)
        end
    end
end

-- Checks the beam of light to see if it should be modified or deleted.
---@param entityEffect EntityEffect
local function checkBeam(_mod, entityEffect)
    if not isHookValid() then
        return
    end

    -- ChallengeAPI.Log("Beam of light spawned! ", entityEffect.Position)

    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return nil
    end

    local currentStage = Game():GetLevel():GetAbsoluteStage()

    -- ChallengeAPI.Log("Current stage: ", currentStage)

    local isInAscent = Game():GetStateFlag(GameStateFlag.STATE_BACKWARDS_PATH)

    if isInAscent then
        -- Don't mess with beams of light in the Ascent.
        return
    end
    
    if currentStage == LevelStage.STAGE3_2 then
        local isSecretPathDoor = Game():GetLevel():GetCurrentRoomIndex() == GridRooms.ROOM_SECRET_EXIT_IDX
        local isGenesis = Game():GetLevel():GetCurrentRoomIndex() == GridRooms.ROOM_GENESIS_IDX
        local isErrorRoomTrapdoor = Game():GetLevel():GetCurrentRoomIndex() == GridRooms.ROOM_ERROR_IDX
        local shouldSpawnWombDoor = (not goal.mustFightBeast)
    
        -- ChallengeAPI.Log("Should spawn womb door? ", shouldSpawnWombDoor)

        if isSecretPathDoor and goal.mustFightBeast then
            return
        end

        if not shouldSpawnWombDoor then
            if (isErrorRoomTrapdoor or isGenesis) then
                return
            end

            -- Prevent beam spawn.
            ChallengeAPI.Log("DESTROYING beam")
            destroyBeam(entityEffect)
        end
    end
end

-- There's no MC_POST_GRID_ENTITY_SPAWN without REPENTOGON,
-- so we have to do some work to perform a one-time check.
local function checkTrapdoors_baseGame(_mod)
    if not isHookValid() then
        return
    end

    local room = Game():GetRoom()
    for i = 0, room:GetGridSize() do
        local gridEntity = room:GetGridEntity(i)
        -- Wait until AFTER the gridEntity is initialized.
        -- and gridEntity.Desc.Initialized
        if gridEntity then
            if gridEntity.Desc.Type == GridEntityType.GRID_TRAPDOOR and not trapdoorCache[ChallengeAPI.Util.GetGridEntityPtrHash(gridEntity)] then
                trapdoorCache[ChallengeAPI.Util.GetGridEntityPtrHash(gridEntity)] = true
                checkTrapdoor(_mod, gridEntity)
            end
        end
    end
end

-- Reset local variables once the run has completed
local function onGameEnd(mod)
    trapdoorCache = {}
end

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, checkBeam, EffectVariant.HEAVEN_LIGHT_DOOR)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_GAME_END, onGameEnd)

if ChallengeAPI.IsREPENTOGON then
    ---@diagnostic disable-next-line: undefined-field
    ChallengeAPI:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_SPAWN, checkTrapdoor, GridEntityType.GRID_TRAPDOOR)
else
    ChallengeAPI:AddCallback(ModCallbacks.MC_POST_UPDATE, checkTrapdoors_baseGame)
end
