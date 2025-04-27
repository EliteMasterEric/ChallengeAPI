-- Provides a set of debug commands for the mod.

local VARIANT_BEAST = 0
local VARIANT_ULTRA_FAMINE = 10
local VARIANT_ULTRA_PESTILENCE = 20
local VARIANT_ULTRA_WAR = 30
local VARIANT_ULTRA_DEATH = 40

local VARIANT_DOGMA_STAGE_1 = 0
local VARIANT_DOGMA_TV = 1
local VARIANT_DOGMA_STAGE_2 = 2

local function debug_kill_horseman(_, cmd, args)
    ChallengeAPI.Log("Killing all horsemen in room...")
    
    -- Check for and kill Ultra Famine
    for _,horseman in ipairs(Isaac.FindByType(EntityType.ENTITY_BEAST, VARIANT_ULTRA_FAMINE)) do
        horseman:ToNPC():Die()
    end

    -- Check for and kill Ultra Pestilence
    for _,horseman in ipairs(Isaac.FindByType(EntityType.ENTITY_BEAST, VARIANT_ULTRA_PESTILENCE)) do
        horseman:ToNPC():Die()
    end

    -- Check for and kill Ultra War
    for _,horseman in ipairs(Isaac.FindByType(EntityType.ENTITY_BEAST, VARIANT_ULTRA_WAR)) do
        horseman:ToNPC():Die()
    end

    -- Check for and kill Ultra Death
    for _,horseman in ipairs(Isaac.FindByType(EntityType.ENTITY_BEAST, VARIANT_ULTRA_DEATH)) do
        horseman:ToNPC():Die()
    end
end

local function debug_kill_dogma(_, cmd, args)
    -- Thanks Headcrab
    ChallengeAPI.Log("Go-go-Gadget murder Dogma!")
    for _,dogma in ipairs(Isaac.FindByType(EntityType.ENTITY_DOGMA)) do
        dogma.HitPoints = 1
        dogma:ToNPC().State = 3
        dogma:TakeDamage(1, 0, EntityRef(Isaac.GetPlayer()), 1)
        if dogma.Variant == VARIANT_DOGMA_STAGE_1 then
            dogma:GetSprite():SetFrame("Transition", 81)
        end
        if REPENTOGON then
            Isaac.CreateTimer(function()
                for _,dogmaStage2 in ipairs(Isaac.FindByType(EntityType.ENTITY_DOGMA, VARIANT_DOGMA_STAGE_2)) do
                    dogmaStage2:GetSprite().PlaybackSpeed = 50
                    dogmaStage2:Die()
                end
            end, 5, 2)
        else
            if dogma.Variant == VARIANT_DOGMA_STAGE_2 then
                dogma:GetSprite().PlaybackSpeed = 50
                dogma:Die()
            end
        end
    end
end

local function debug_weaken_beast(_, cmd, args)
    local targetHealth = 30
    if #args > 0 then
        local mode = args[1]
        if mode == "stage2" then
            targetHealth = 6660 - 1
        elseif mode == "stage3" then
            targetHealth = 3330 - 1
        end
    end

    for _,beast in ipairs(Isaac.FindByType(EntityType.ENTITY_BEAST, VARIANT_BEAST)) do
        ChallengeAPI.Log("Weakening the Beast to " .. targetHealth .. " HP.")
        beast.HitPoints = targetHealth
    end
end


-- Adds a callback for a command which checks the command name before executing the command.
-- This should really be done by the base API, but whatever.
---@param commandFunction fun(_, cmd, args)
---@param commandName string
local function registerCommand(commandFunction, commandName)
    ChallengeAPI:AddCallback(ModCallbacks.MC_EXECUTE_CMD, function(_, cmd, arg)
        if cmd == commandName then
            local args = {}
            if arg and #arg > 0 then
                for word in string.gmatch(arg, "[^%s]+") do
                    table.insert(args, word)
                end
            end
            commandFunction(_, cmd, args)
        end
    end)
end

-- Register the console commands
registerCommand(debug_kill_horseman, "kill_horseman")
registerCommand(debug_kill_dogma, "kill_dogma")
registerCommand(debug_weaken_beast, "weaken_beast")

if REPENTOGON then
    -- Add console commands to autocomplete
    Console.RegisterCommand("kill_horseman", "Kill all the Ultra Horsemen on screen right now.", "kill_horseman ", false, AutocompleteType.NONE)
    Console.RegisterCommand("kill_dogma", "Kill Dogma (both stages).", "kill_dogma", false, AutocompleteType.NONE)
    Console.RegisterCommand("weaken_beast", "Weaken the Beast to 30 HP, just before death.", "weaken_beast [mode]", false, AutocompleteType.CUSTOM)
    
    -- Add console command autocomplete for weaken_beast
    ChallengeAPI:AddCallback(ModCallbacks.MC_CONSOLE_AUTOCOMPLETE, function(_, cmd, params)
        return {
            {"stage2", "Weakens the Beast to 6660 HP, the start of Stage 2."},
            {"stage3", "Weakens the Beast to 3330 HP, the start of Stage 3."},
            {"fatal", "Weakens the Beast to 30 HP, just before death."}
        }
    end, "weaken_beast")
end