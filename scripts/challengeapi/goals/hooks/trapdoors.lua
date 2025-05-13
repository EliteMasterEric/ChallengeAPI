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

-- Not actually a PtrHash but good enough for indexing a table
---@param gridEntity GridEntity
local function getGridEntityPtrHash(gridEntity)
    return tostring(GetPtrHash(Game():GetRoom())) .. "~" .. gridEntity:GetGridIndex()
end

local function isGridPosOccupied(position)
    local gridEntity = Game():GetRoom():GetGridEntityFromPos(position)
    local isEmpty = (gridEntity.Desc.Type == GridEntityType.GRID_NULL) or (gridEntity.Desc.Type == GridEntityType.GRID_DECORATION)
    return not isEmpty
end

---@param gridEntity GridEntity
local function destroyTrapdoor(gridEntity)
    Game():GetRoom():RemoveGridEntity (gridEntity:GetGridIndex(), 0, true)
    gridEntity:Destroy(true)
    gridEntity:Update()

    trapdoorCache[getGridEntityPtrHash(gridEntity)] = false
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
        if not isGridPosOccupied(DOOR_POS_UPCENTER) then
            Isaac.GridSpawn(GridEntityType.GRID_TRAPDOOR, 0, DOOR_POS_UPCENTER, true)
        elseif not isGridPosOccupied(DOOR_POS_DOWNCENTER) then
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
        if not isGridPosOccupied(DOOR_POS_UPCENTER) then
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEAVEN_LIGHT_DOOR, 0, DOOR_POS_UPCENTER, Vector(0, 0), nil)
        elseif not isGridPosOccupied(DOOR_POS_DOWNCENTER) then
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

    ChallengeAPI.Log("Trapdoor spawned! ", gridEntity.Position)

    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return nil
    end

    local currentStage = Game():GetLevel():GetAbsoluteStage()

    ChallengeAPI.Log("Current stage: ", currentStage)
    if currentStage == LevelStage.STAGE3_2 then
        local shouldSpawnWombDoor = (not goal.mustFightBeast)
    
        ChallengeAPI.Log("Should spawn womb door? ", shouldSpawnWombDoor)

        if not shouldSpawnWombDoor then
            -- Prevent trapdoor spawn.
            ChallengeAPI.Log("DESTROYING trapdoor")
            destroyTrapdoor(gridEntity)
            -- This works btw
            -- spawnBeam(false)
        end
    end
end

-- Checks the beam of light to see if it should be modified or deleted.
---@param entityEffect EntityEffect
local function checkBeam(_mod, entityEffect)
    if not isHookValid() then
        return
    end

    local preventBeam = function()
        entityEffect:Kill()
    end

    ChallengeAPI.Log("Beam of light spawned! ", entityEffect.Position)
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
            if gridEntity.Desc.Type == GridEntityType.GRID_TRAPDOOR and not trapdoorCache[getGridEntityPtrHash(gridEntity)] then
                trapdoorCache[getGridEntityPtrHash(gridEntity)] = true
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
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_UPDATE, checkTrapdoors_baseGame)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_GAME_END, onGameEnd)
