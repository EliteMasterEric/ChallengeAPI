-- Define tables for storing different types of data.

---@class DataTable
local DataTable = {}
DataTable.__index = DataTable

function DataTable.new()
    local self = setmetatable({}, DataTable)
    return self
end

function DataTable:GetLength()
    local result = 0
    for _ in pairs(self) do
        result = result + 1
    end
    return result
end

function DataTable:Clear()
    for k, v in pairs(self) do
        self[k] = nil
    end
end

function DataTable:__tostring()
    local result = "DataTable{"
    for k, v in pairs(self) do
        result = result .. k .. " = " .. v .. ", "
    end
    return result .. "}"
end

ChallengeAPI.language = DataTable.new()
ChallengeAPI.challenges = DataTable.new()
ChallengeAPI.goals = DataTable.new()

ChallengeAPI.languageInitialized = false
ChallengeAPI.challengesInitialized = false
ChallengeAPI.goalsInitialized = false

-- Clear the language data.
-- This is not intended for external use, and may break the mod if used improperly.
function ChallengeAPI:ClearLanguageData()
    ChallengeAPI.language:Clear()
end

-- Clear the list of goals.
-- This is not intended for external use, and may break the mod if used improperly.
function ChallengeAPI:ClearGoalData()
    ChallengeAPI.goals:Clear()
end

-- Clear the list of challenges.
-- This is not intended for external use, and may break the mod if used improperly.
function ChallengeAPI:ClearChallengeData()
    ChallengeAPI.challenges:Clear()
end

-- Clear all data.
-- This is not intended for external use, and may break the mod if used improperly.
function ChallengeAPI:ClearAllData()
    ChallengeAPI:ClearLanguageData()
    ChallengeAPI:ClearGoalData()
    ChallengeAPI:ClearChallengeData()
end
