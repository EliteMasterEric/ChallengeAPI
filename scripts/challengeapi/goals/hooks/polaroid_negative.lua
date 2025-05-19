-- Handles functionality for ensuring the correct combination of Polaroid and Negative spawn after beating Mom.

local SPAWN_POS_LEFT = Vector(280, 360)
local SPAWN_POS_SINGLE = Vector(320, 360)
local SPAWN_POS_RIGHT = Vector(360, 360)

-- Determine whether the hooks in this module are relevant for the current challenge.
---@return boolean result Whether the hooks are valid.
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

-- Called after a Polaroid spawns.
---@param entity EntityPickup
local function onPostPolaroidSpawn(entity)
    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return nil
    end

    local replaceWithNegative = function()
        -- Replace the spawn with a Negative.
        -- ChallengeAPI.Log("GoalHook: Replacing Polaroid with Negative")
        entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_NEGATIVE)
        entity:ToPickup().OptionsPickupIndex = 0
    end

    local ensurePolaroidIsCentered = function()
        -- Ensure the pickup is centered.
        -- ChallengeAPI.Log("GoalHook: Centering Polaroid")
        if entity.Position.X ~= SPAWN_POS_SINGLE.X then
            entity.Position = SPAWN_POS_SINGLE
        end
        entity:ToPickup().OptionsPickupIndex = 0
    end

    local alsoSpawnNegative = function()
        -- If this pickup is centered, its pair won't spawn, so we need to do work here.
        if entity.Position.X == SPAWN_POS_SINGLE.X then
            -- ChallengeAPI.Log("GoalHook: Spawning Negative alongside Polaroid")
            -- Make the current pickup the left option.
            entity.Position = SPAWN_POS_LEFT
            entity:ToPickup().OptionsPickupIndex = 1

            -- Spawn the right option.
            local entityNegative = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_NEGATIVE, SPAWN_POS_RIGHT, Vector(0, 0), nil):ToPickup()
            entityNegative.OptionsPickupIndex = 1
        end
    end

    local removePolaroid = function()
        -- Prevent spawn
        -- ChallengeAPI.Log("GoalHook: Removing Polaroid")
        entity:Kill()
    end

    local switchCase = {
        [ChallengeAPI.Enum.GoalAltPaths.DEVIL] = replaceWithNegative,
        [ChallengeAPI.Enum.GoalAltPaths.ANGEL] = ensurePolaroidIsCentered,
        [ChallengeAPI.Enum.GoalAltPaths.BOTH] = alsoSpawnNegative,
        [ChallengeAPI.Enum.GoalAltPaths.DEVIL_INVERSE] = ensurePolaroidIsCentered,
        [ChallengeAPI.Enum.GoalAltPaths.ANGEL_INVERSE] = replaceWithNegative,
        [ChallengeAPI.Enum.GoalAltPaths.BOTH_INVERSE] = alsoSpawnNegative,
        [ChallengeAPI.Enum.GoalAltPaths.DEVIL_NOPE] = removePolaroid,
        [ChallengeAPI.Enum.GoalAltPaths.ANGEL_NOPE] = removePolaroid,
        [ChallengeAPI.Enum.GoalAltPaths.BOTH_NOPE] = removePolaroid,
        [ChallengeAPI.Enum.GoalAltPaths.ANY] = alsoSpawnNegative
    }

    local case = switchCase[goal.altPath]
    if case then
        return case()
    else
        ChallengeAPI.Log("Case fallthrough in onPostPolaroidSpawn(): ", goal.altPath)
    end
end

-- Called after a Negative spawns.
---@param entity EntityPickup
local function onPostNegativeSpawn(entity)
    local goal = ChallengeAPI:GetCurrentChallengeGoal()
    if goal == nil then
        return nil
    end

    local replaceWithPolaroid = function()
        -- Replace the spawn with a Polaroid.
        -- ChallengeAPI.Log("GoalHook: Replacing Negative with Polaroid")
        entity:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_POLAROID)
        entity:ToPickup().OptionsPickupIndex = 0
    end

    local ensureNegativeIsCentered = function()
        -- Ensure the pickup is centered.
        -- ChallengeAPI.Log("GoalHook: Centering Negative")
        if entity.Position.X ~= SPAWN_POS_SINGLE.X then
            entity.Position = SPAWN_POS_SINGLE
        end
        entity:ToPickup().OptionsPickupIndex = 0
    end

    local alsoSpawnPolaroid = function()
        -- If this pickup is centered, its pair won't spawn, so we need to do work here.
        if entity.Position.X == SPAWN_POS_SINGLE.X then
            -- Make the current pickup the right option.
            -- ChallengeAPI.Log("GoalHook: Spawning Polaroid alongside Negative")
            entity.Position = SPAWN_POS_RIGHT
            entity:ToPickup().OptionsPickupIndex = 1

            -- Spawn the left option.
            local entityPolaroid = Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, CollectibleType.COLLECTIBLE_POLAROID, SPAWN_POS_LEFT, Vector(0, 0), nil):ToPickup()
            entityPolaroid.OptionsPickupIndex = 1
        end
    end

    local removeNegative = function()
        -- Prevent spawn
        -- ChallengeAPI.Log("GoalHook: Removing Negative")
        entity:Kill()
    end

    local switchCase = {
        [ChallengeAPI.Enum.GoalAltPaths.DEVIL] = ensureNegativeIsCentered,
        [ChallengeAPI.Enum.GoalAltPaths.ANGEL] = replaceWithPolaroid,
        [ChallengeAPI.Enum.GoalAltPaths.BOTH] = alsoSpawnPolaroid,
        [ChallengeAPI.Enum.GoalAltPaths.DEVIL_INVERSE] = replaceWithPolaroid,
        [ChallengeAPI.Enum.GoalAltPaths.ANGEL_INVERSE] = ensureNegativeIsCentered,
        [ChallengeAPI.Enum.GoalAltPaths.BOTH_INVERSE] = alsoSpawnPolaroid,
        [ChallengeAPI.Enum.GoalAltPaths.DEVIL_NOPE] = removeNegative,
        [ChallengeAPI.Enum.GoalAltPaths.ANGEL_NOPE] = removeNegative,
        [ChallengeAPI.Enum.GoalAltPaths.BOTH_NOPE] = removeNegative,
        [ChallengeAPI.Enum.GoalAltPaths.ANY] = alsoSpawnPolaroid
    }

    local case = switchCase[goal.altPath]
    if case then
        return case()
    else
        ChallengeAPI.Log("Case fallthrough in onPostNegativeSpawn(): ", goal.altPath)
    end
end

-- Called after a collectible spawns.
---@param _mod table The mod calling this callback.
---@param entity EntityPickup The entity that was spawned.
local function postCollectibleInit(_mod, entity)
    if not isHookValid() then
        return
    end

    if entity.SubType == CollectibleType.COLLECTIBLE_POLAROID then
        return onPostPolaroidSpawn(entity)
    end
    if entity.SubType == CollectibleType.COLLECTIBLE_NEGATIVE then
        return onPostNegativeSpawn(entity)
    end
end

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, postCollectibleInit, PickupVariant.PICKUP_COLLECTIBLE)
