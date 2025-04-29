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

-- Load the contents of each language file in the "languages" directory.
function ChallengeAPI:LoadLanguageData()
    for _, language in ipairs(ChallengeAPI.Languages) do
        require("language." .. language)
    end
end

-- We have to do this immediately because Isaac Lua is dumb.
ChallengeAPI:LoadLanguageData()
