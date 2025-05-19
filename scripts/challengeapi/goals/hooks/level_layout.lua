-- Handles functionality for ensuring proper level generation (i.e. floor layout) in challenges.
-- We have limited means of doing this without REPENTOGON.

-- Called after the level has calculated seeded curses.
-- Allows additional curses to be added.
-- NOTE: Skipped if Black Candle is equipped.
-- TODO: Does this happen before or after level generation?
---@param curses integer The provided curses, as a bitmask.
---@return integer? (optional) A new set of curses to use, as a bitmask.
local function onPostCurseEval(_mod, curses)
    -- ChallengeAPI.Log("Curses evaluated.")
end

-- Called as the game is choosing room configs which match the given room slot.
---@param roomSlot LevelGeneratorRoom A slot in the graph of rooms to be generated.
---@param roomConfig RoomConfigRoom The current room config to use.
---@return RoomConfigRoom? (optional) A new room config to use instead. MUST have matching room shape and compatible door slots.
local function onPreLevelPlaceRoom(_mod, roomSlot, roomConfig)
    -- ChallengeAPI.Log("Placing room.")
end

local function onPostNewLevel(_mod)
    -- ChallengeAPI.Log("Entered new level.")
end

local function onPostNewRoom(_mod)
    -- ChallengeAPI.Log("Entered new room.")
end

-- Called whenever a room is placed during level generation.
-- NOTE: Only available with REPENTOGON

if ChallengeAPI.IsREPENTOGON then
    ChallengeAPI:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, onPreLevelPlaceRoom)

else
    -- REPENTOGON not enabled, no level generator callbacks :(
end

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL, onPostCurseEval)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, onPostNewLevel)
ChallengeAPI:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, onPostNewRoom)

-- Examples of modifying Game():Challenge:

-- Switch to XXXXXXXXXXXL when less than 10 pixels from a trapdoor to affect generation
-- https://github.com/An-Annoying-Cat/beasts_of_the_basement/blob/main/scripts/entities/items/house_of_leaves.lua

-- Switch to Red Redemption, reseed to get a split floor, then switch back?
-- https://github.com/Restored-Mods/SegmentedMausoleum/blob/main/main.lua

-- Switch to Solar System, call player:UpdateCanShoot(), then switch back
-- https://github.com/spoopster/greenisaac/blob/main/scripts/items/guns_n_roses.lua