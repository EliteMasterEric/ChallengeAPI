local languageCode = "en_us"

ChallengeAPI.language[languageCode] = {
    EIDCategoryName = "Current Challenge",

    EIDStartingPlayer = "{{Player{1}}} Start as {2}",
    EIDStartingItems = "{{TreasureRoom}} Starting Items:",
    EIDStartingTrinkets = "Starting Trinkets:",

    EIDStartingItem = "{{Collectible{1}}} {2}",
    EIDStartingTrinket = "{{Trinket{1}}} {2}",

    EIDStartingItems_None = "No starting items.",

    EIDStartingCard = "{{Card}} Starting Card: {1}",

    EIDStartingCardTemplate = "{{Card{1}}} {2}",
    EIDStartingCardRandom = "Random",
    EIDStartingCardRandomMultiple = "Random x2",

    EIDStartingPill = "{{Pill}} Starting Pill: {1}",

    EIDStartingPillTemplate = "{{Pill{1}}} {2}",
    EIDStartingPillRandom = "Random",
    EIDStartingPillRandomMultiple = "Random x2",

    EIDHardMode = "{{HardMode}} Hard Mode",
    EIDBlindfolded = "Player is blindfolded",
    EIDFixedDamage = "100 {{Damage}}",
    EIDFixedShotSpeed = "100 {{ShotSpeed}}",
    EIDStartingDamageBonus = "↑ {{Damage}} +{1} Damage",
    EIDStartingDamagePenalty = "↓ {{Damage}} -{1} Damage",
    EIDFixedTearDelay = "{{Tears}} {1} Tears",

    EIDStartingCoinsBonus = "{{Coin}} +{1} Coins",
    EIDStartingCoinsPenalty = "{{Coin}} -{1} Coins",

    EIDStartingSoulHeartsBonus = "↑ {{SoulHeart}} +{1} Soul Hearts",
    EIDStartingSoulHeartsPenalty = "↓ {{SoulHeart}} -{1} Soul Hearts",

    EIDStartingBlackHeartsBonus = "↑ {{BlackHeart}} +{1} Black Hearts",
    EIDStartingBlackHeartsPenalty = "↓ {{BlackHeart}} -{1} Black Hearts",

    EIDStartingMaxHeartsBonus = "↑ {{Heart}} +{1} Hearts",
    EIDStartingMaxHeartsPenalty = "↓ {{Heart}} -{1} Hearts",


    EIDRoomNames = {
        [RoomType.ROOM_NULL] = "Unknown",
        [RoomType.ROOM_DEFAULT] = "Rooms",
        [RoomType.ROOM_SHOP] = "{{Shop}} Shops",
        [RoomType.ROOM_ERROR] = "Error Rooms",
        [RoomType.ROOM_TREASURE] = "{{TreasureRoom}} Treasure Rooms",
        [RoomType.ROOM_BOSS] = "{{BossRoom}} Boss Rooms",
        [RoomType.ROOM_MINIBOSS] = "{{MiniBoss}} Mini Boss Rooms",
        [RoomType.ROOM_SECRET] = "{{SecretRoom}} Secret Rooms",
        [RoomType.ROOM_SUPERSECRET] = "{{SuperSecretRoom}} Super Secret Rooms",
        [RoomType.ROOM_ARCADE] = "{{ArcadeRoom}} Arcades",
        [RoomType.ROOM_CURSE] = "{{CursedRoom}} Curse Rooms",
        [RoomType.ROOM_CHALLENGE] = "{{ChallengeRoom}} Challenge Rooms",
        [RoomType.ROOM_LIBRARY] = "{{Library}} Libraries",
        [RoomType.ROOM_SACRIFICE] = "{{SacrificeRoom}} Sacrifice Rooms",
        [RoomType.ROOM_DEVIL] = "{{DevilRoom}} Devil Rooms",
        [RoomType.ROOM_ANGEL] = "{{AngelRoom}} Angel Rooms",
        [RoomType.ROOM_DUNGEON] = "{{Crawlspace}} Crawlspaces",
        [RoomType.ROOM_BOSSRUSH] = "{{BossRushRoom}} Boss Rush Room",
        [RoomType.ROOM_ISAACS] = "{{IsaacsRoom}} Bedrooms",
        [RoomType.ROOM_BARREN] = "{{BarrenRoomoom}} Barren Bedrooms",
        [RoomType.ROOM_CHEST] = "{{Chest}} Chest Rooms",
        [RoomType.ROOM_DICE] = "{{DiceRoom}} Dice Rooms",
        [RoomType.ROOM_BLACK_MARKET] = "{{Crawlspace}} Black Markets",
        [RoomType.ROOM_GREED_EXIT] = "Greed Exits",
        [RoomType.ROOM_PLANETARIUM] = "{{Planetarium}} Planetariums",
        [RoomType.ROOM_TELEPORTER] = "Teleport Entrances", -- Unused Mausoleum Room
        [RoomType.ROOM_TELEPORTER_EXIT] = "Teleport Exits", -- Unused Mausoleum Room
        [RoomType.ROOM_SECRET_EXIT] = "Secret Paths",
        [RoomType.ROOM_BLUE] = "Blue Rooms", -- Spawned by Blue Key
        [RoomType.ROOM_ULTRASECRET] = "{{UltraSecretRoom}} Ultra Secret Rooms",
    },

    -- Used when a curse always appears
    EIDCurse = {
        [LevelCurse.CURSE_NONE] = "",
        [LevelCurse.CURSE_OF_DARKNESS] = "{{CurseDarkness}} All floors are covered in darkness",
        [LevelCurse.CURSE_OF_LABYRINTH] = "{{CurseLabyrinth}} All compatible floors are XL floors",
        [LevelCurse.CURSE_OF_THE_LOST] = "{{CurseLost}} The map is always hidden",
        [LevelCurse.CURSE_OF_THE_UNKNOWN] = "{{CurseUnknown}} The player's health is always hidden",
        [LevelCurse.CURSE_OF_THE_CURSED] = "{{CurseCursed}} All normal doors are cursed doors",
        [LevelCurse.CURSE_OF_MAZE] = "{{CurseMaze}} Entering a new room occasionally teleports Isaac elsewhere on the floor",
        [LevelCurse.CURSE_OF_BLIND] = "{{CurseBlind}} Items on pedestals are not revealed until picked up",
        [LevelCurse.CURSE_OF_GIANT] = "{{CurseGiant}} All floors are made of large rooms",
    },

    -- Used when a curse is prevented from appearing
    EIDCurseFilter = {
        [LevelCurse.CURSE_NONE] = "",
        [LevelCurse.CURSE_OF_DARKNESS] = "{{CurseDarkness}} Curse of Darkness never appears",
        [LevelCurse.CURSE_OF_LABYRINTH] = "{{CurseLabyrinth}} XL floors never appear",
        [LevelCurse.CURSE_OF_THE_LOST] = "{{CurseLost}} Curse of the Lost never appears",
        [LevelCurse.CURSE_OF_THE_UNKNOWN] = "{{CurseUnknown}} The player's health is never hidden",
        [LevelCurse.CURSE_OF_THE_CURSED] = "",
        [LevelCurse.CURSE_OF_MAZE] = "{{CurseMaze}} Curse of the Maze never appears",
        [LevelCurse.CURSE_OF_BLIND] = "{{CurseBlind}} Curse of the Blind never appears",
        [LevelCurse.CURSE_OF_GIANT] = "",
    },

    EIDCurseAlways = "{1} always appears",
    EIDCurseNever = "{1} never appears"
}
