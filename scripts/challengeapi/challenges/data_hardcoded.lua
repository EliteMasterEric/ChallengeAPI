-- Registers all vanilla challenges with the ChallengeAPI.
-- If we have REEPENTOGON, we don't have to call this, as we can retrieve all the challenge information from the XML with that.
-- But if we don't, we have to register each base game challenge's info manually.
function ChallengeAPI:RegisterVanillaChallenges()
    ChallengeAPI.Log("Registering vanilla challenges...")

    -- #1: Pitch Black
    local pitchBlack = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_PITCH_BLACK, "Pitch Black",
        PlayerType.PLAYER_ISAAC, "boss-rush")
    pitchBlack:SetRoomFilter({ RoomType.ROOM_SHOP })
    pitchBlack:SetCurse({ LevelCurse.CURSE_OF_DARKNESS, LevelCurse.CURSE_OF_THE_UNKNOWN })
    pitchBlack:SetCurseFilter({ LevelCurse.CURSE_OF_LABYRINTH, LevelCurse.CURSE_OF_THE_LOST })

    -- #2: High Brow
    local highBrow = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_HIGH_BROW, "High Brow",
        PlayerType.PLAYER_ISAAC, "mom")
    highBrow:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_NUMBER_ONE,
        CollectibleType.COLLECTIBLE_E_COLI,
        CollectibleType.COLLECTIBLE_BUTT_BOMBS,
        CollectibleType.COLLECTIBLE_FLUSH
    })
    highBrow:SetStartingTrinkets({ TrinketType.TRINKET_PETRIFIED_POOP })
    highBrow:SetRoomFilter({ RoomType.ROOM_TREASURE })

    -- #3: Head Trauma
    local headTrauma = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_HEAD_TRAUMA, "Head Trauma",
        PlayerType.PLAYER_ISAAC, "mom")
    headTrauma:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_TINY_PLANET, CollectibleType.COLLECTIBLE_SOY_MILK, CollectibleType.COLLECTIBLE_IRON_BAR, CollectibleType.COLLECTIBLE_SMALL_ROCK })
    headTrauma:SetRoomFilter({ RoomType.ROOM_TREASURE })

    -- #4: Darkness Falls
    local darknessFalls = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_DARKNESS_FALLS, "Darkness Falls",
        PlayerType.PLAYER_EVE, "satan")
    darknessFalls:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_RAZOR_BLADE, CollectibleType.COLLECTIBLE_DARK_MATTER, CollectibleType.COLLECTIBLE_PENTAGRAM, CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER })
    darknessFalls:SetRoomFilter({ RoomType.ROOM_TREASURE })

    -- #5: The Tank
    local theTank = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_THE_TANK, "The Tank",
        PlayerType.PLAYER_MAGDALENE, "mom")
    theTank:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_THUNDER_THIGHS, CollectibleType.COLLECTIBLE_BUCKET_OF_LARD, CollectibleType.COLLECTIBLE_INFAMY })
    theTank:SetRoomFilter({ RoomType.ROOM_TREASURE })

    -- #6: Solar System
    local solarSystem = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_SOLAR_SYSTEM, "Solar System",
        PlayerType.PLAYER_ISAAC, "moms-heart")
    solarSystem:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_DISTANT_ADMIRATION, CollectibleType.COLLECTIBLE_FOREVER_ALONE, CollectibleType.COLLECTIBLE_HALO_OF_FLIES, CollectibleType.COLLECTIBLE_TRANSCENDENCE })
    solarSystem:SetRoomFilter({ RoomType.ROOM_TREASURE })
    solarSystem:SetIsBlindfolded(true)

    -- #7: Suicide King
    local suicideKing = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_SUICIDE_KING, "Suicide King",
        PlayerType.PLAYER_LAZARUS, "isaac")
    suicideKing:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_IPECAC, CollectibleType.COLLECTIBLE_MY_REFLECTION, CollectibleType.COLLECTIBLE_MR_MEGA })
    suicideKing:SetRoomFilter({ RoomType.ROOM_TREASURE })
    -- Note: The random pill from this challenge is actually part of Lazarus.

    -- #8: Cat Got Your Tongue
    local catGotYourTongue = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_CAT_GOT_YOUR_TONGUE,
        "Cat Got Your Tongue", PlayerType.PLAYER_ISAAC, "mom")
    catGotYourTongue:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_GUPPYS_TAIL,
        CollectibleType.COLLECTIBLE_GUPPYS_HEAD,
        CollectibleType.COLLECTIBLE_GUPPYS_HAIRBALL
    })
    catGotYourTongue:SetRoomFilter({ RoomType.ROOM_TREASURE })
    catGotYourTongue:SetIsBlindfolded(true)
    catGotYourTongue:SetStartingBlackHearts(6)
    catGotYourTongue:SetStartingSoulHearts(6)
    

    -- #9: Demo Man
    local demoMan = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_DEMO_MAN, "Demo Man",
        PlayerType.PLAYER_ISAAC, "moms-heart")
    demoMan:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_DR_FETUS, CollectibleType.COLLECTIBLE_REMOTE_DETONATOR })
    demoMan:SetStartingTrinkets({ TrinketType.TRINKET_MATCH_STICK })
    demoMan:SetRoomFilter({ RoomType.ROOM_TREASURE })

    -- #10: Cursed!
    local cursed = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_CURSED, "Cursed!",
        PlayerType.PLAYER_MAGDALENE, "mom")
    cursed:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_TREASURE_MAP,
        CollectibleType.COLLECTIBLE_COMPASS,
        CollectibleType.COLLECTIBLE_BLUE_MAP,
        CollectibleType.COLLECTIBLE_RAW_LIVER
    })
    cursed:SetStartingTrinkets({ TrinketType.TRINKET_CHILDS_HEART })
    cursed:SetRoomFilter({})
    cursed:SetCurse({ LevelCurse.CURSE_OF_THE_CURSED })
    cursed:SetCurseFilter({ })

    -- #11: Glass Cannon
    local glassCannon = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_GLASS_CANNON, "Glass Cannon",
        PlayerType.PLAYER_ISAAC, "satan")
    glassCannon:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_EPIC_FETUS, CollectibleType.COLLECTIBLE_LOKIS_HORNS })
    glassCannon:SetRoomFilter({ RoomType.ROOM_TREASURE })

    -- #12: When Life Gives You Lemons
    local whenLifeGivesLemons = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_WHEN_LIFE_GIVES_LEMONS, "When Life Gives You Lemons",
        PlayerType.PLAYER_ISAAC, "mom")
    whenLifeGivesLemons:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_LEMON_MISHAP, CollectibleType.COLLECTIBLE_HABIT, CollectibleType.COLLECTIBLE_9_VOLT })
    whenLifeGivesLemons:SetRoomFilter({ RoomType.ROOM_TREASURE })
    whenLifeGivesLemons:SetStartingPill(PillEffect.PILLEFFECT_LEMON_PARTY)

    -- #13: Beans!
    local beans = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_BEANS, "Beans!",
        PlayerType.PLAYER_ISAAC, "mom")
    beans:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_BUTT_BOMBS, CollectibleType.COLLECTIBLE_PYRO, CollectibleType.COLLECTIBLE_BLACK_BEAN, CollectibleType.COLLECTIBLE_BEAN, CollectibleType.COLLECTIBLE_9_VOLT })
    beans:SetRoomFilter({ RoomType.ROOM_TREASURE })
    beans:SetIsBlindfolded(true)

    -- #14: It's In The Cards
    local itsInTheCards = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_ITS_IN_THE_CARDS, "It's In The Cards",
        PlayerType.PLAYER_ISAAC, "mom")
    itsInTheCards:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_STARTER_DECK, CollectibleType.COLLECTIBLE_DECK_OF_CARDS, CollectibleType.COLLECTIBLE_9_VOLT, CollectibleType.COLLECTIBLE_BATTERY })
    itsInTheCards:SetRoomFilter({ RoomType.ROOM_TREASURE })
    itsInTheCards:SetStartingCard(Card.CARD_RANDOM)

    -- #15: Slow Roll
    local slowRoll = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_SLOW_ROLL, "Slow Roll",
        PlayerType.PLAYER_ISAAC, "mom")
    slowRoll:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_POLYPHEMUS, CollectibleType.COLLECTIBLE_CUPIDS_ARROW, CollectibleType.COLLECTIBLE_MY_REFLECTION })
    slowRoll:SetRoomFilter({ RoomType.ROOM_TREASURE })
    slowRoll:SetIsMaxDamage(true)
    slowRoll:SetMinimumFireRate(60)
    slowRoll:SetIsMinShotSpeed(true)

    -- #16: Computer Savvy
    local computerSavy = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_COMPUTER_SAVY, "Computer Savvy",
        PlayerType.PLAYER_ISAAC, "mom")
    computerSavy:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_TECHNOLOGY, CollectibleType.COLLECTIBLE_TECHNOLOGY_2, CollectibleType.COLLECTIBLE_SPOON_BENDER })
    computerSavy:SetRoomFilter({ RoomType.ROOM_TREASURE })

    -- #17: Waka Waka
    local wakaWaka = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_WAKA_WAKA, "Waka Waka",
        PlayerType.PLAYER_ISAAC, "mom")
    wakaWaka:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_STRANGE_ATTRACTOR, CollectibleType.COLLECTIBLE_ANTI_GRAVITY })

    wakaWaka:SetRoomFilter({ RoomType.ROOM_TREASURE })

    -- #18: The Host
    local theHost = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_THE_HOST, "The Host",
        PlayerType.PLAYER_ISAAC, "mom")
    theHost:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_MULLIGAN, CollectibleType.COLLECTIBLE_SPIDERBABY })
    theHost:SetStartingTrinkets({ TrinketType.TRINKET_TICK })
    theHost:SetRoomFilter({ RoomType.ROOM_TREASURE })

    -- #19: The Family Man
    local theFamilyMan = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_THE_FAMILY_MAN, "The Family Man",
        PlayerType.PLAYER_ISAAC, "isaac")
    theFamilyMan:SetStartingCollectibles({ CollectibleType.COLLECTIBLE_DADS_KEY, CollectibleType.COLLECTIBLE_SISTER_MAGGY, CollectibleType.COLLECTIBLE_BROTHER_BOBBY, CollectibleType.COLLECTIBLE_ROTTEN_BABY, CollectibleType.COLLECTIBLE_BFFS })
    theFamilyMan:SetRoomFilter({ RoomType.ROOM_TREASURE })
    theFamilyMan:SetIsBlindfolded(true)

    -- #20: Purist
    local purist = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_PURIST, "Purist",
        PlayerType.PLAYER_ISAAC, "moms-heart")
    purist:SetStartingCollectibles({})
    purist:SetRoomFilter({ RoomType.ROOM_TREASURE })

    -- #21: XXXXXXXXXXXL
    local xxxxxxxxl = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_XXXXXXXXL, "XXXXXXXXL", PlayerType.PLAYER_ISAAC, "moms-heart")
    xxxxxxxxl:SetStartingCollectibles({})
    xxxxxxxxl:SetRoomFilter({})

    -- #22: SPEED!
    local speed = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_SPEED, "SPEED!", PlayerType.PLAYER_ISAAC, "moms-heart")
    speed:SetStartingCollectibles({})
    speed:SetRoomFilter({})

    -- #23: Blue Bomber
    local blueBomber = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_BLUE_BOMBER, "Blue Bomber",
        PlayerType.PLAYER_BLUEBABY, "satan")
    blueBomber:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_KAMIKAZE,
        CollectibleType.COLLECTIBLE_MR_MEGA,
        CollectibleType.COLLECTIBLE_PYROMANIAC,
        CollectibleType.COLLECTIBLE_BROTHER_BOBBY
    })
    blueBomber:SetRoomFilter({ RoomType.ROOM_TREASURE })
    blueBomber:SetIsBlindfolded(true)

    -- #24: PAY TO PLAY
    local payToPlay = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_PAY_TO_PLAY, "PAY TO PLAY",
        PlayerType.PLAYER_ISAAC, "isaac")
    payToPlay:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_SACK_OF_PENNIES,
        CollectibleType.COLLECTIBLE_MONEY_EQUALS_POWER
    })

    -- #25: Have A Heart
    local haveAHeart = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_HAVE_A_HEART, "Have A Heart",
        PlayerType.PLAYER_ISAAC, "moms-heart")
    haveAHeart:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_CHARM_VAMPIRE
    })
    haveAHeart:SetStartingMaxHearts(18)
    haveAHeart:SetStartingRedHearts(-4)

    -- #26: I RULE!
    local iRule = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_I_RULE, "I RULE!",
        PlayerType.PLAYER_ISAAC, "mega-satan")
    iRule:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_MOMS_KNIFE,
        CollectibleType.COLLECTIBLE_TRINITY_SHIELD,
        CollectibleType.COLLECTIBLE_BOOMERANG,
        CollectibleType.COLLECTIBLE_LADDER
    })
    iRule:SetIsHardMode(true)

    -- #27: BRAINS!
    local brains = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_BRAINS, "BRAINS!",
        PlayerType.PLAYER_BLUEBABY, "blue-baby")
    brains:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_BOBS_BRAIN,
        CollectibleType.COLLECTIBLE_BOBS_BRAIN,
        CollectibleType.COLLECTIBLE_BOBS_BRAIN,
        CollectibleType.COLLECTIBLE_THUNDER_THIGHS
    })
    brains:SetIsBlindfolded(true)

    -- #28: PRIDE DAY!
    local prideDay = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_PRIDE_DAY, "PRIDE DAY!",
        PlayerType.PLAYER_ISAAC, "moms-heart")
    prideDay:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_RAINBOW_BABY,
        CollectibleType.COLLECTIBLE_3_DOLLAR_BILL
    })
    prideDay:SetStartingTrinkets({ TrinketType.TRINKET_RAINBOW_WORM })

    -- #29: Onan's Streak
    local onansStreak = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_ONANS_STREAK, "Onan's Streak",
        PlayerType.PLAYER_JUDAS, "isaac")
    onansStreak:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_CHOCOLATE_MILK
    })
    onansStreak:SetStartingDamageBonus(2)

    -- #30: The Guardian
    local guardian = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_GUARDIAN, "The Guardian",
        PlayerType.PLAYER_ISAAC, "moms-heart")
    guardian:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_PUNCHING_BAG,
        CollectibleType.COLLECTIBLE_ISAACS_HEART,
        CollectibleType.COLLECTIBLE_HOLY_GRAIL,
        CollectibleType.COLLECTIBLE_SPEAR_OF_DESTINY
    })
    guardian:SetIsBlindfolded(true)

    -- #31: Backasswards
    local backasswards = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_BACKASSWARDS, "Backasswards",
        PlayerType.PLAYER_ISAAC, "mega-satan")

    -- #32: Aprils Fool
    local aprilsFool = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_APRILS_FOOL, "Aprils Fool",
        PlayerType.PLAYER_ISAAC, "moms-heart")

    -- #33: Pokey Mans
    local pokeyMans = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_POKEY_MANS, "Pokey Mans",
        PlayerType.PLAYER_ISAAC, "isaac")
    pokeyMans:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_MOMS_EYESHADOW,
        CollectibleType.COLLECTIBLE_FRIEND_BALL
    })

    -- #34: Ultra Hard
    local ultraHard = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_ULTRA_HARD, "Ultra Hard",
        PlayerType.PLAYER_ISAAC, "mega-satan")
    ultraHard:SetCurse({LevelCurse.CURSE_OF_LABYRINTH, LevelCurse.CURSE_OF_BLIND, LevelCurse.CURSE_OF_THE_LOST, LevelCurse.CURSE_OF_MAZE})

    -- #35: Pong
    local pong = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_PONG, "Pong",
        PlayerType.PLAYER_ISAAC, "blue-baby")
    pong:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_CUPIDS_ARROW,
        CollectibleType.COLLECTIBLE_RUBBER_CEMENT
    })
    pong:SetIsMaxDamage(true)
    pong:SetMinimumFireRate(150)
    pong:SetIsBigRange(true)

    -- #36: Scat Man
    local scatMan = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_SCAT_MAN, "Scat Man",
        PlayerType.PLAYER_ISAAC, "mom")
    scatMan:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_9_VOLT,
        CollectibleType.COLLECTIBLE_SKATOLE,
        CollectibleType.COLLECTIBLE_POOP,
        CollectibleType.COLLECTIBLE_E_COLI,
        CollectibleType.COLLECTIBLE_BUTT_BOMBS,
        CollectibleType.COLLECTIBLE_BUTT_BOMBS,
        CollectibleType.COLLECTIBLE_BUTT_BOMBS,
        CollectibleType.COLLECTIBLE_BFFS,
        CollectibleType.COLLECTIBLE_THUNDER_THIGHS,
        CollectibleType.COLLECTIBLE_DIRTY_MIND
    })
    scatMan:SetStartingTrinkets({ TrinketType.TRINKET_MYSTERIOUS_CANDY })
    scatMan:SetIsBlindfolded(true)

    -- #37: Bloody Mary
    local bloodyMary = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_BLOODY_MARY, "Bloody Mary",
        PlayerType.PLAYER_BETHANY, "satan")
    bloodyMary:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL,
        CollectibleType.COLLECTIBLE_BLOOD_BAG,
        CollectibleType.COLLECTIBLE_ANEMIC,
        CollectibleType.COLLECTIBLE_BLOOD_OATH
    })
    bloodyMary:SetRemovedCollectibles({ CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES })
    bloodyMary:SetStartingTrinkets({ TrinketType.TRINKET_CHILDS_HEART })

    -- #38: Baptism By Fire
    local baptismByFire = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_BAPTISM_BY_FIRE, "Baptism By Fire",
        PlayerType.PLAYER_BETHANY, "isaac")
    baptismByFire:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_SULFUR,
        CollectibleType.COLLECTIBLE_GUPPYS_PAW,
        CollectibleType.COLLECTIBLE_IMMACULATE_HEART
    })
    baptismByFire:SetRemovedCollectibles({ CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES })
    baptismByFire:SetStartingTrinkets({ TrinketType.TRINKET_MAGGYS_FAITH })
    baptismByFire:SetIsBlindfolded(true)

    -- #39: Isaac's Awakening
    local isaacsAwakening = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_ISAACS_AWAKENING, "Isaac's Awakening",
        PlayerType.PLAYER_ISAAC, "mother")
    isaacsAwakening:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_SPIRIT_SWORD,
        CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES,
        CollectibleType.COLLECTIBLE_TRINITY_SHIELD
    })

    -- #40: Seeing Double
    local seeingDouble = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_SEEING_DOUBLE, "Seeing Double",
        PlayerType.PLAYER_JACOB, "moms-heart")
    seeingDouble:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_20_20
    })
    seeingDouble:SetStartingCollectiblesEsau({
        CollectibleType.COLLECTIBLE_20_20,
        CollectibleType.COLLECTIBLE_XRAY_VISION
    })

    -- #41: Pica Run
    local picaRun = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_PICA_RUN, "Pica Run",
        PlayerType.PLAYER_ISAAC, "isaac")
    picaRun:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_MOMS_PURSE,
        CollectibleType.COLLECTIBLE_MARBLES,
        CollectibleType.COLLECTIBLE_SMELTER
    })

    -- #42: Hot Potato
    local hotPotato = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_HOT_POTATO, "Hot Potato",
        PlayerType.PLAYER_THEFORGOTTEN_B, "satan")
    hotPotato:SetIsBlindfolded(true)

    -- #43: Cantripped!
    local cantripped = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_CANTRIPPED, "Cantripped!",
        PlayerType.PLAYER_CAIN_B, "mom")

    -- #44: Red Redemption
    local redRedemption = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_RED_REDEMPTION, "Red Redemption",
        PlayerType.PLAYER_JACOB_B, "mother")
    redRedemption:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_DADS_KEY
    })

    -- #45: DELETE THIS
    local deleteThis = ChallengeAPI:RegisterChallenge(Challenge.CHALLENGE_DELETE_THIS, "DELETE THIS",
        PlayerType.PLAYER_ISAAC, "blue-baby")
    deleteThis:SetStartingCollectibles({
        CollectibleType.COLLECTIBLE_TMTRAINER
    })

    ChallengeAPI.Log("Vanilla challenges registered.")
end

-- Make corrections and additions to the vanilla challenge descriptions.
-- These are done separate since they are necessary regardless of whether REEPENTOGON is enabled.
function ChallengeAPI:RegisterChallengeCorrections()
    local xxxxxxxxl = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_XXXXXXXXL)
    if xxxxxxxxl ~= nil then
        xxxxxxxxl:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_XXXXXXXXL))
    end

    local speed = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_SPEED)
    if speed ~= nil then
        speed:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_SPEED))
    end

    local payToPlay = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_PAY_TO_PLAY)
    if payToPlay ~= nil then
        payToPlay:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_PAY_TO_PLAY))
    end

    local haveAHeart = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_HAVE_A_HEART)
    if haveAHeart ~= nil then
        haveAHeart:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_HAVE_A_HEART))
    end

    local prideDay = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_PRIDE_DAY)
    if prideDay ~= nil then
        prideDay:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_PRIDE_DAY))
    end

    local onansStreak = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_ONANS_STREAK)
    if onansStreak ~= nil then
        onansStreak:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_ONANS_STREAK))
    end

    local guardian = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_GUARDIAN)
    if guardian ~= nil then
        guardian:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_GUARDIAN))
    end

    local backasswards = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_BACKASSWARDS)
    if backasswards ~= nil then
        backasswards:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_BACKASSWARDS))
        -- Use custom goal description and graphic
        backasswards:SetGoal(ChallengeAPI:GetGoalById("basement-1"))
    end

    local aprilFool = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_APRILS_FOOL)
    if aprilFool ~= nil then
        aprilFool:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_APRILS_FOOL))
    end

    local pokeyMans = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_POKEY_MANS)
    if pokeyMans ~= nil then
        pokeyMans:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_POKEY_MANS))
    end

    local ultraHard = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_ULTRA_HARD)
    if ultraHard ~= nil then
        ultraHard:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_ULTRA_HARD))
    end

    local seeingDouble = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_SEEING_DOUBLE)
    if seeingDouble ~= nil then
        seeingDouble:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_SEEING_DOUBLE))
    end

    local picaRun = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_PICA_RUN)
    if picaRun ~= nil then
        picaRun:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_PICA_RUN))
    end

    local hotPotato = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_HOT_POTATO)
    if hotPotato ~= nil then
        hotPotato:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_HOT_POTATO))
    end

    local cantripped = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_CANTRIPPED)
    if cantripped ~= nil then
        cantripped:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_CANTRIPPED))
    end

    local redRedemption = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_RED_REDEMPTION)
    if redRedemption ~= nil then
        redRedemption:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_RED_REDEMPTION))
        -- Starting collectibles are wrong
        redRedemption:SetStartingCollectibles({CollectibleType.COLLECTIBLE_DADS_KEY, CollectibleType.COLLECTIBLE_RED_KEY})
    end

    local deleteThis = ChallengeAPI:GetChallengeById(Challenge.CHALLENGE_DELETE_THIS)
    if deleteThis ~= nil then
        deleteThis:SetEIDNotes(ChallengeAPI:TranslateTable("EIDVanillaChallengeNotes." .. Challenge.CHALLENGE_DELETE_THIS))
    end
end
    