function ChallengeAPI:EID_ApplyLanguageData()
    if EID == nil then
        ChallengeAPI.Log("ERROR: Tried to apply EID language data, but EID is not enabled.")
        return
    end

    if not ChallengeAPI.languageInitialized then
        ChallengeAPI.Log("ERROR: Tried to apply EID language data, but ChallengeAPI language data has not been initialized.")
        return
    end

    for _, language in ipairs(ChallengeAPI.Languages) do
        EID.descriptions[language].ItemReminder.CategoryNames.ChallengeAPI = ChallengeAPI.language[language].EIDCategoryName
    end
end