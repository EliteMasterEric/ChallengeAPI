-- Returns the current language to use for ChallengeAPI.
function ChallengeAPI:GetLanguage()
    -- Lazy dumbass do it right
    if EID == nil then
        return "en_us"
    end
    return EID:getLanguage()
end

function ChallengeAPI:GetLanguageData()
    return ChallengeAPI.language[ChallengeAPI:GetLanguage()]
end

-- Translates a key into a string for the current language.
---@param key string The key to translate.
---@return string The translated string.
function ChallengeAPI:Translate(key)
    if not ChallengeAPI.languageInitialized or ChallengeAPI:GetLanguageData() == nil then
        ChallengeAPI.Log("ERROR: Tried to translate, but ChallengeAPI language data has not been initialized.")
        return "<ERROR>"
    end

    -- Split the key into parts by '.'
    local keyParts = {}
    for part in string.gmatch(key, "[^%.]+") do
        local part = tonumber(part) or part
        table.insert(keyParts, part)
    end

    local currentTable = ChallengeAPI:GetLanguageData()
    for _, part in ipairs(keyParts) do
        if currentTable[part] == nil then
            ChallengeAPI.Log("ERROR: Tried to translate, but key '" .. key .. "' does not exist in the language data.")
            return "<NIL>"
        end
        currentTable = currentTable[part]
    end

    if type(currentTable) ~= "string" then
        ChallengeAPI.Log("ERROR: Tried to translate, but key '" .. key .. "' is not a string.")
        return "<NIL>"
    end

    return currentTable
end

-- Translates a key into a set of strings for the current language.
---@param key string The key to translate.
---@return string[] The translated strings.
function ChallengeAPI:TranslateTable(key)
    if not ChallengeAPI.languageInitialized or ChallengeAPI:GetLanguageData() == nil then
        ChallengeAPI.Log("ERROR: Tried to translate, but ChallengeAPI language data has not been initialized.")
        return {"<ERROR>"}
    end

    -- Split the key into parts by '.'
    local keyParts = {}
    for part in string.gmatch(key, "[^%.]+") do
        local part = tonumber(part) or part
        table.insert(keyParts, part)
    end

    local currentTable = ChallengeAPI:GetLanguageData()
    for _, part in ipairs(keyParts) do
        if currentTable[part] == nil then
            ChallengeAPI.Log("ERROR: Tried to translate, but key '" .. key .. "' does not exist in the language data.")
            return {"<NIL>"}
        end
        currentTable = currentTable[part]
    end

    if type(currentTable) ~= "table" then
        ChallengeAPI.Log("ERROR: Tried to translate, but key '" .. key .. "' is not a table.")
        return {"<NIL>"}
    end

    return currentTable
end

-- Load the contents of each language file in the "languages" directory.
function ChallengeAPI:LoadLanguageData()
    -- ChallengeAPI.Log("Loading language data.")

    ChallengeAPI.languageInitialized = true
    for _, language in ipairs(ChallengeAPI.Languages) do
        -- ChallengeAPI.Log("Loading language data: " .. language)
        -- never use require ong
        include("language." .. language)
    end
end
