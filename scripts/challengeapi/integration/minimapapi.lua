-- Determine whether the hooks in this module are valid for the current challenge.
---@return boolean Whether the hooks are valid.
local function isHookValid()
    if not ChallengeAPI:AreHooksActive() then
        return false
    end

    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        ChallengeAPI.Log("Not in a challenge...")
        return false
    end
    return true
end

local function handleDisplayFlagsForTreasureRooms(_mod, room, dflags)
    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge ~= nil and challenge:IsRoomFilterActive(RoomType.ROOM_TREASURE) then
        -- This challenge has treasure rooms disabled.
        
        if room.Descriptor.Flags & RoomDescriptor.FLAG_RED_ROOM == RoomDescriptor.FLAG_RED_ROOM then
            -- Don't hide Red Room treasure rooms on the map.
            return dflags
        end

        if room.Descriptor.Data.Type == RoomType.ROOM_TREASURE then
            -- Hide treasure rooms on the map.
            --return 0 -- Invisible
            return dflags
        end
        if room.Descriptor.Data.Type == RoomType.ROOM_PLANETARIUM then
            -- Hide planetarium rooms on the map.
            --return 0 -- Invisible
            return dflags
        end
    end
end

local function onUpdateDisplayFlags(_mod, room, dflags)
    -- Ignore hooks if we aren't in a challenge.
    if not isHookValid() then
        return dflags
    end

    return handleDisplayFlagsForTreasureRooms(_mod, room, dflags)
end

local function onChallengeStart(_mod, challenge, isContinue)
    MinimapAPI:AddDisplayFlagsCallback(ChallengeAPI, onUpdateDisplayFlags)
end

if MinimapAPI then
    -- ChallengeAPI:AddCallback(ChallengeAPI.Enum.Callbacks.CALLBACK_CHALLENGE_STARTED, onChallengeStart)
end