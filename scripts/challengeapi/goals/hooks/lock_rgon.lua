-- Handles functionality for ensuring challenges are locked under conditions that aren't available in the base game.
-- This includes preventing challenges from being played unless REPENTOGON is installed and active.

-- Determine whether the hooks in this module are relevant for the current challenge.
---@return boolean Whether the hooks are valid.
local function isHookValid()
    if ChallengeAPI.IsREPENTOGON then
        return false
    end

    local challenge = ChallengeAPI:GetCurrentChallenge()
    if challenge == nil then
        return false
    end

    if not challenge.requiresRepentogon then
        return false
    end

    return true
end

local blindSprite = Sprite()

local function displayRgonDisclaimer()
    ChallengeAPI.Util.BlindScreenWithBlack()

    -- Display text over the black screen.
    local f = Font()
    f:Load("font/teammeatfont16.fnt")

    local text = ChallengeAPI:Translate("REPENTOGONNotInstalled");

    f:DrawString(text, 60, Isaac.GetScreenHeight() / 2 - 10, KColor(1, 1, 1, 1), 0, true)
end

local function softlockPlayer()
    local player = Isaac.GetPlayer(0)
    if player == nil then
        return
    end

    -- Prevent the player from moving.
    player.Velocity = Vector(0, 0)
    player.ControlsEnabled = false
end

local function onPostRender(_mod)
    if not isHookValid() then
        return
    end

    displayRgonDisclaimer()
    softlockPlayer()
end

ChallengeAPI:AddCallback(ModCallbacks.MC_POST_RENDER, onPostRender)
-- ChallengeAPI:AddCallback(ChallengeAPI.Enum.Callbacks.CALLBACK_POST_LOADED, onChallengeAPILoad)