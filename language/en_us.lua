local languageCode = "en_us"

ChallengeAPI.Log("Loading English language data")

ChallengeAPI.language[languageCode] = {
    EIDChallengeUnknown = "Unknown Challenge",
    EIDChallengeUnknownDescription = "No challenge info registered#Install REPENTOGON or ask the mod author to add ChallengeAPI support",

    EIDCategoryName = "Current Challenge",

    EIDGoalTemplate = "{{Trophy}} Goal: {1} {2}",

    EIDGoalSecretPath = "{{MirrorRoom}} Secret path mandatory",
    EIDGoalKnifePieces = "{{Collectible627}} Knife pieces mandatory",

    EIDStartingPlayer = "{{Player{1}}} Start as {2}",

    EIDStartingItems = "{{TreasureRoomChance}} Starting Items:",

    EIDStartingItem = "{{Collectible{1}}} {2}",
    EIDStartingItemMultiple = "{{Collectible{1}}} {2} (x{3})",
    EIDStartingTrinket = "{{Trinket{1}}} {2}",

    EIDStartingCard = "{{Card}} {1}",
    EIDStartingCardRandom = "{{Card}} Random",
    EIDStartingCardRandomMultiple = "{{Card}} Random x2",

    EIDStartingPill = "{{Pill}} {1}",
    EIDStartingPillRandom = "{{Pill}} Random",
    EIDStartingPillRandomMultiple = "{{Pill}} Random x2",

    EIDHardMode = "{{HardMode}} Hard Mode",
    -- Use Blind Rage to represent the blindfold
    EIDBlindfolded = "{{Trinket81}} Player is blindfolded",
    EIDFixedDamage = "Fixed {{Damage}} 100 Damage",
    EIDFixedShotSpeed = "Fixed {{Shotspeed}} 1.0 Shot Speed",
    EIDStartingDamageBonus = "↑ +{1} {{Damage}} Damage",
    EIDStartingDamagePenalty = "↓ -{1} {{Damage}} Damage",
    EIDFixedTearDelay = "Fixed {{Tears}} {1} Tears",

    EIDStartingCoinsBonus = "{{Coin}} +{1} Coins",
    EIDStartingCoinsPenalty = "{{Coin}} -{1} Coins",

    EIDStartingSoulHeartsBonus = "↑ +{1}{{SoulHeart}} Soul Hearts",
    EIDStartingSoulHeartsPenalty = "↓ -{1}{{SoulHeart}} Soul Hearts",

    EIDStartingBlackHeartsBonus = "↑ +{1}{{BlackHeart}} Black Hearts",
    EIDStartingBlackHeartsPenalty = "↓ -{1}{{BlackHeart}} Black Hearts",

    EIDStartingMaxHeartsBonus = "↑ +{1} {{EmptyHeart}} Hearts",
    EIDStartingMaxHeartsPenalty = "↓ -{1} {{EmptyHeart}} Hearts",

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

    -- Default length is ~24 characters.
    EIDVanillaChallengeNotes = {
        [Challenge.CHALLENGE_XXXXXXXXL] = {
            "{{CurseLabyrinth}} "
            .. "Each floor is the size of "
            .. "an XL Womb floor"
        },
        [Challenge.CHALLENGE_SPEED] = {
            "{{Collectible337}} "
            .. "Everything is 40% faster",

            "{{Warning}} "
            .. "After 16 minutes, Isaac "
            .. "is damaged every ten "
            .. "seconds"
        },
        [Challenge.CHALLENGE_PAY_TO_PLAY] = {
            "{{Collectible380}} "
            .. "Each door costs 1 cent to "
            .. "enter",

            "{{ArrowDown}} "
            .. "Isaac drops coins on hit",

            "{{Warning}} "
            .. "If Isaac runs out of "
            .. "coins, he dies"
        },
        [Challenge.CHALLENGE_HAVE_A_HEART] = {

            "{{ArrowDown}} "
            .. "{{Coin}} Pennies drop instead of "
            .. "{{Heart}} Red Hearts",

            "{{Warning}} "
            .. "Healing items like {{Collectible45}} Yum "
            .. "Heart have no effect"
        },
        [Challenge.CHALLENGE_PRIDE_DAY] = {
            "{{Warning}} "
            .. "Rainbow Worm can't be "
            .. "dropped or replaced"
        },
        [Challenge.CHALLENGE_ONANS_STREAK] = {
            "{{Throwable}} "
            .. "Missing a shot damages "
            .. "Judas"
        },
        [Challenge.CHALLENGE_GUARDIAN] = {
            "{{Collectible276}} "
            .. "Isaac's Heart will "
            .. "follow {{Collectible281}} Punching Bag "
            .. "instead of Isaac"
        },
        [Challenge.CHALLENGE_BACKASSWARDS] = {
            "{{Warning}} "
            .. "Start with 8-10 random "
            .. "items in the {{MegaSatanSmall}} Mega "
            .. "Satan fight",

            ""
            .. "Start each floor in the "
            .. "{{BossRoom}} Boss Room and return "
            .. "to the starting room"
        },
        [Challenge.CHALLENGE_APRILS_FOOL] = {
            "{{Room}} "
            .. "Map layout is inaccurate",

            "{{CurseUnknown}} "
            .. "Health is inaccurate",

            "{{Collectible405}} " -- GB Bug icon
            .. "Items/pickups display "
            .. "the wrong graphic",

            "{{Collectible488}} " -- Metronome icon
            .. "Active items and "
            .. "consumables have "
            .. "randomized effects",

            "{{BossRoom}} "
            .. "Every boss is The Bloat",

            ""
            .. "Stonies have a chance to be replaced with Cross Stonies that shoot"
        },
        [Challenge.CHALLENGE_POKEY_MANS] = {
            "{{Collectible382}} " 
            .. "Friendly Ball now spawns a random Charmed monster on use, instead of its normal effect",

            "{{ArrowUp}} "
            .. "Friendly Ball instantly recharges whenever a spawned monster is killed"
        },
        [Challenge.CHALLENGE_ULTRA_HARD] = {
            "{{EmptyHeart}} "
            .. "No heart pickups appear",

            "{{Trinket5}} " -- Purple Heart
            .. "All enemies are Champions",

            "{{BossRoom}} "
            .. "All Boss Fights are "
            .. "Double Trouble"
        },
        [Challenge.CHALLENGE_SEEING_DOUBLE] = {
            "{{Collectible631}} All enemies and Bosses are doubled"
        },
        [Challenge.CHALLENGE_PICA_RUN] = {
            "{{Trinket}} "
            .. "Items are replaced with "
            .. "random Trinkets",

            "{{Collectible538}} "
            .. "Marbles activates every "
            .. "time Isaac is hit"
        },
        [Challenge.CHALLENGE_HOT_POTATO] = {
            "{{Player35}} "
            .. "The Forgotten cannot attack, and explodes every 2.5 seconds"
        },
        [Challenge.CHALLENGE_CANTRIPPED] = {
            "{{Card}} "
            .. "Replace cards and pills with active item cards",
            "{{Collectible710}} "
            .. "Bag of Crafting can hold up to 3 active item cards",
            "{{Collectible710}} "
            .. "Consuming a card activates its effect",
            "{{BossRoom}} "
            .. "Bosses drop {{Collectible251}} Starter Deck, which drops cards and increases Bag capacity"
        },
        [Challenge.CHALLENGE_RED_REDEMPTION] = {
            "{{CurseLabyrinth}} "
            .. "Floors generate in separated clusters, with one {{Shop}} Shop, two {{BossRoom}} Boss Rooms, and two {{TreasureRoom}} Treasure Rooms",

            "{{Collectible580}} "
            .. "Red Key starts as a pocket active with infinite charges.",

            "{{Collectible580}} "
            .. "Red Key spawns Dark Esau after 20 uses on a single floor, and every 5 additional uses."
        },
        [Challenge.CHALLENGE_DELETE_THIS] = {
            "{{Collectible721}} "
            .. "All collectibles are Glitched items",

            "{{Collectible324}} "
            .. "Each stage's environment, music, and graphics are randomized"
        }
    },

    -- Used when a curse always appears
    EIDCurse = {
        [LevelCurse.CURSE_NONE] = "",
        [LevelCurse.CURSE_OF_DARKNESS] = "{{CurseDarkness}} All floors are covered in darkness",
        [LevelCurse.CURSE_OF_LABYRINTH] = "{{CurseLabyrinth}} All floors are XL floors",
        [LevelCurse.CURSE_OF_THE_LOST] = "{{CurseLost}} The map is always hidden",
        [LevelCurse.CURSE_OF_THE_UNKNOWN] = "{{CurseUnknown}} The player's health is always hidden",
        [LevelCurse.CURSE_OF_THE_CURSED] = "{{CurseCursed}} All normal doors are cursed doors",
        [LevelCurse.CURSE_OF_MAZE] = "{{CurseMaze}} Switching rooms may teleport Isaac",
        [LevelCurse.CURSE_OF_BLIND] = "{{CurseBlind}} Items pedestals aren't revealed until picked up",
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
    }
}
