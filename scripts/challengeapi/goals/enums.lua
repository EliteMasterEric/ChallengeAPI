-- Represents the choices provided when beating Mom and Mom's Heart.
---@enum GoalAltPaths
ChallengeAPI.GoalAltPaths = {
    -- Only the Negative will appear when defeating Mom.
    -- Only the trapdoor to Sheol will appear when defeating Mom's Heart.
    DEVIL = 0,

    -- Only the Polaroid will appear when defeating Mom.
    -- Only the beam to Cathedral will appear when defeating Mom's Heart.
    ANGEL = 1,

    -- Both the Polaroid and the Negative will appear when defeating Mom.
    -- Only the corresponding path's door will appear when defeating Mom's Heart.
    BOTH = 2,

    -- Only the Polaroid will appear when defeating Mom.
    -- Only the trapdoor to Sheol will appear when defeating Mom's Heart (thus forcing the run to stop early).
    DEVIL_INVERSE = 4,

    -- Only the Negative will appear when defeating Mom.
    -- Only the beam to Cathedral will appear when defeating Mom's Heart (thus forcing the run to stop early).
    ANGEL_INVERSE = 5,

    -- Both the Polaroid and the Negative will appear when defeating Mom.
    -- Only the opposite door will appear when defeating Mom's Heart (thus forcing the run to stop early).
    BOTH_INVERSE = 6,

    -- Both the Polaroid and the Negative will appear when defeating Mom.
    -- Both the trapdoor to Sheol and the beam to Cathedral will appear when defeating Mom's Heart.
    -- Thus, the player can choose either path, potentially forcing the run to stop early.
    ANY = 7,
}

-- Represents the choices provided when beating the main basement floors.
---@enum GoalSecretPaths
ChallengeAPI.GoalSecretPaths = {
    -- Only the normal path will appear (Basement/Caves/Depths), preventing the player from accessing Downpour/Mines/Mausoleum.
    NORMAL = 0,

    -- Only the secret path will appear (Downpour/Mines/Mausoleum). Additionally, you can enter them for free.
    SECRET = 1,

    -- Both the normal path and the secret path will appear, and you can switch paths as you like (similar to a normal run).
    -- Since the player may not have visited
    ANY = 2,
}

---@enum GoalHushMode
ChallengeAPI.GoalHushMode = {
    -- The door to Hush may open when completing Womb 2 if the player is quick enough.
    NORMAL = 0,

    -- The door to Hush always opens when completing Womb 2, and stays open regardless of the current timer.
    ALWAYS = 1,

    -- The door to Hush never opens.
    NEVER = 2,

    -- The door to Hush will open when completing Womb 2 if the player is quick enough.
    -- If the player runs out of time, they will die.
    KILL = 3,
}

---@enum GoalBossRushMode
ChallengeAPI.GoalBossRushMode = {
    -- The door to Boss Rush may open when completing Womb 2 if the player is quick enough.
    NORMAL = 0,

    -- The door to Boss Rush always opens when completing Womb 2, and stays open regardless of the current timer.
    ALWAYS = 1,

    -- The door to Boss Rush never opens.
    NEVER = 2,

    -- The door to Boss Rush will open when completing Womb 2 if the player is quick enough.
    -- If the player runs out of time, they will die.
    KILL = 3,
}

