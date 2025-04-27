-- Handles functionality for custom Beast challenge trophies.

local VARIANT_STALACTITE = 1
local VARIANT_BEAST_ROCK_PROJECTILE = 2
local VARIANT_BEAST_SOUL = 3

local BEAST_FINAL_VELOCITY = Vector(0, 3)
local BEAST_FINAL_MUSICFADERATE = 0.08

-- Allowing the Beast to die naturally, or deleting the Beast without replacing it,
-- will immediately trigger the final cutscene.
-- Spawning a new Beast in MC_POST_NPC_DEATH prevents the final cutscene,
-- but causes the game to softlock on a white screen (part of the fade) before the cutscene ends.
-- This is not done via SetColorMethod so we can't do anything about it.

-- Instead, we delete the Beast entity as it is about to die,
-- then spawn a new Beast with full health to prevent the cutscene from playing.
-- We override it to be invisible, braindead, and uninteractable.
-- Then, we spawn an Entity effect which will play the death animation for us,
-- then do the rest of the sequence (SFX, VFX, etc.) ourselves.

-- While true, stop Beast AI updates.
local isBeastComplete = false
local beastDefeatFrame = nil

local TROPHY_SPAWN_DELAY_FRAMES = 2.5 * 30 -- 2.5 seconds at 30fps

-- Checks for and removes all stalagtites, souls, and rocks spawned by the Beast.
local function killAllBeastBullets()
  -- Check for and kill stalagtites
  for _,stalactite in ipairs(Isaac.FindByType(EntityType.ENTITY_BEAST, VARIANT_STALACTITE)) do
      stalactite:Die()
  end

  -- Check for and kill Beast souls
  for _,beastSoul in ipairs(Isaac.FindByType(EntityType.ENTITY_BEAST, VARIANT_BEAST_SOUL)) do
      beastSoul:Die()
  end

  -- Check for and kill Beast rocks
  for _,beastRock in ipairs(Isaac.FindByType(EntityType.ENTITY_BEAST, VARIANT_BEAST_ROCK_PROJECTILE)) do
      beastRock:Die()
  end
end

-- Called as the Beast dies, but before the death animation.
---@param entity EntityNPC
local function onBeastPreDeathAnim(mod, entity)
    if entity.Type == EntityType.ENTITY_BEAST and entity.Variant == 0 then
        ChallengeAPI.Log("Beast (" .. entity.Variant .. ") starting to die!")
        
        local beastFlipX = entity.FlipX

        -- Remove the real beast so it doesn't play its death animation.
        entity:Remove()
        killAllBeastBullets()

        -- Spawn an invisible uninteractable beast which will keep the cutscene from playing.
        local invisibleBeast = Isaac.Spawn(EntityType.ENTITY_BEAST, 0, 0, entity.Position, Vector.Zero, nil):ToNPC()
        if invisibleBeast == nil then
            ChallengeAPI.Log("Failed to spawn invisible beast!")
            return
        end
        invisibleBeast.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        invisibleBeast.Visible = false
        invisibleBeast.State = 3 -- Idle state
        invisibleBeast:Update()
        
        isBeastComplete = true
        beastDefeatFrame = Game():GetFrameCount()
        
        -- Spawn a fake effect which will be used to play the death animation.
        local fakeBeast = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DEVIL, 0, entity.Position, Vector.Zero, nil)
        fakeBeast.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        fakeBeast:GetSprite():Load(invisibleBeast:GetSprite():GetFilename(), true)
        fakeBeast:GetSprite():Play("Death", true)
        fakeBeast.FlipX = beastFlipX -- Make the Beast face the correct way.
        fakeBeast.Velocity = BEAST_FINAL_VELOCITY -- Sink into the lava so we don't have to end the animation properly.

        -- Play the Beast death SFX
        -- There's other SFX but they're barely audible so I don't really care.
        SFXManager():Play(SoundEffect.SOUND_BEAST_ANGELIC_BLAST)

        -- Fade out the music
        MusicManager():Fadeout(BEAST_FINAL_MUSICFADERATE)
    end
end

-- Called whenever the Beast is about to perform a game update.
---@param entity EntityNPC
local function onBeastPreUpdate(mod, entity)
  if entity.Type == EntityType.ENTITY_BEAST and entity.Variant == 0 then
    print("beast: " .. entity.State .. ", " .. tostring(isBeastComplete))
    if isBeastComplete then
      -- Force the Beast into the Idle state (preventing it from charging),
      -- then return true to prevent default AI updates.
      entity.State = 3
      return true
    end
  else
  end
end

local function spawnTrophy()
  local room = Game():GetRoom()
  local centerPos = room:GetCenterPos()
  Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TROPHY, 0, centerPos, Vector.Zero, nil)
end

-- Called every frame.
local function onPostUpdate()
  -- Timer to spawn the trophy.
  if isBeastComplete and beastDefeatFrame then
      local currentFrame = Game():GetFrameCount()
      if currentFrame - beastDefeatFrame >= TROPHY_SPAWN_DELAY_FRAMES then
          spawnTrophy()
          beastDefeatFrame = nil
      end
  end
end

-- Reset local variables once the run has completed
local function onGameEnd(mod)
  print("Game is ending...")
  isBeastComplete = false
  beastDefeatFrame = nil
end

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, onBeastPreDeathAnim, EntityType.ENTITY_BEAST)
ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, onBeastPreUpdate, EntityType.ENTITY_BEAST)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_UPDATE, onPostUpdate)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_GAME_END, onGameEnd)
