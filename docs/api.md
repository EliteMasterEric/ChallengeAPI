# ChallengeAPI Documentation

A list of all the functions and data structures provided by ChallengeAPI to modders.

## ChallengeAPI.Goal

A Goal is a data structure representing the objective of a given challenge. It includes simple information about the challenge goals, and provides additional functions to fine-tune the path the player takes to achieve the goal. It also includes language information (for EID information) as well as an icon (for HUD display).

Aside from functionality provided by the base game, (end stage/boss, choosing Cathedral/Sheol, forcing Downpour, forcing Mega Satan), you can also fine-tune parameters about the challenge. For example, you can force specific stage types to appear on specific floors (e.g. force Basement 1 and 2 to both be Cellar).

Goals will automatically be assigned to vanilla challenges based on the parameters provided in the `challenges.xml` file. If you don't need customize your challenge's goal, you don't have to assign a goal to your challenge.

### ChallengeAPI:SetGoalIcon
Modifies the icon for the given goal. Used in both the HUD and the EID description.

The default icons are 16x16, but larger icons are also supported.

```lua
local sprite = Sprite()
-- Load the sprite's graphics yourself

-- Then apply it to the goal
local goal = ChallengeAPI:GetGoalById("my-custom-goal")
goal:SetGoalIcon(sprite)
```

**Parameters**

* `icon` - The icon to use for the goal. This should be a valid `Sprite` object.

## Goal-related functions

### ChallengeAPI:RegisterGoal
Register a new goal with the ChallengeAPI. ChallengeAPI already defines a set of goals for most combinations of parameters that work by default.

```lua
local goal = ChallengeAPI:RegisterGoal(id, name, endStage, altPath, secretPath, megaSatan)
```

**Parameters**

* `id` - The internal ID for the challenge goal. This should be an (ideally kebab-case) string that is unique to your mod.
    * If another goal with the same ID is registered, the new goal will override the old one.
* `name` - The English readable name of the challenge goal. Used for challenge descriptions.
* `endStage` - The `LevelStage` corresponding to the challenge goal. For example, `LevelStage.STAGE4_2` for Mom's Heart.
* `altPath` - The `ChallengeAPI.Enum.GoalAltPaths` enum value corresponding to the challenge goal.
    * For example, `ChallengeAPI.Enum.GoalAltPaths.DEVIL` to lock the player into Sheol, `ChallengeAPI.Enum.GoalAltPaths.ANGEL` to lock the player into Cathedral, etc.
* `secretPath` - The `ChallengeAPI.Enum.GoalSecretPaths` enum value corresponding to the challenge goal.
    * For example, `ChallengeAPI.Enum.GoalSecretPaths.NORMAL` to lock the player into the normal path, `ChallengeAPI.Enum.GoalSecretPaths.SECRET` to lock the player into the secret Repentance path, etc.
* `megaSatan` - Whether this challenge goal requires you to beat Mega Satan.
    * If `true`, automatically grants the Key Pieces and disables the Lamb/??? fight.

### ChallengeAPI:GetGoalById
Retrieve a challenge goal by its ID.

```lua
local goal = ChallengeAPI:GetGoalById(id)
```

**Parameters**

* `id` - The internal ID for the challenge goal, as defined when it was registered.

**Returns**

* The `Goal` corresponding to the ID, or `nil` if no goal with that ID exists.

### ChallengeAPI:GetGoalByChallengeParams
Retrieve a challenge goal by finding the first one with matching challenge parameters.

```lua
local goal = ChallengeAPI:GetGoalByChallengeParams(endStage, altPath, secretPath, megaSatan)
```

**Parameters**

* `endStage` - The `LevelStage` corresponding to the challenge goal.
* `altPath` - The `ChallengeAPI.Enum.GoalAltPaths` enum value corresponding to the challenge goal.
* `secretPath` - The `ChallengeAPI.Enum.GoalSecretPaths` enum value corresponding to the challenge goal.
* `megaSatan` - Whether this challenge goal requires you to beat Mega Satan.

**Returns**

* The `Goal` corresponding to the challenge parameters, or `nil` if no goal with those parameters exists.

## ChallengeAPI.ChallengeParams

A ChallengeParams is a data structure representing a playable challenge. It provides a set of functions for interacting with the challenge's parameters, including the goal and other information.

If the user has REPENTOGON is installed, ChallengeAPI will automatically register each challenge from the `challenges.xml` file, and define their basic parameters. Otherwise, you will have to register your custom challenges manually in order for them to work with ChallengeAPI.

If you want to change the goal for a challenge, retrieve it using `ChallengeAPI:GetChallengeById` or `ChallengeAPI:GetChallengeByName`, and then use `ChallengeParams:SetGoal` to set a new goal. Don't fetch the goal and modify it directly, or you may mess up other challenges!

### ChallengeParams

### ChallengeParams:SetGoal

Modifies the challenge goal for this challenge. This changes how the challenge is displayed on the HUD as well as certain gameplay parameters.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
local goal = ChallengeAPI:GetGoalById("my-custom-goal")
challenge:SetGoal(goal)
```

**REPENTOGON ONLY:** You can also set the goal for a challenge using the XML file! SetGoal will automatically be called for you. This method is preferred as it helps keep your challenge data self-documenting. *Make sure your mod has Repentogon as a dependency if you plan on using this feature.*

```xml
<!-- Make sure your endstage and other parameters are still correct! -->
<challenge name="My Custom Challenge" startingitems="123,456" endstage="6" chalapigoal="my-custom-goal" />
```

**Parameters**

* `goal` - The `Goal` to set for this challenge.

### ChallengeParams:SetIsHardMode

Modifies whether the given challenge is in Hard Mode. Most challenges aren't.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `difficulty` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetIsHardMode(true)
```

**Parameters**

* `isHardMode` - Whether the challenge should be in Hard Mode. `true` corresponds to `difficulty="1"`, `false` to `difficulty="0"`.

### ChallengeParams:SetStartingCollectibles

Modifies the list of starting collectibles, including passive and active items.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `startingitems` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetStartingCollectibles({
    CollectibleType.COLLECTIBLE_NUMBER_ONE,
    CollectibleType.COLLECTIBLE_E_COLI
})
```

**Parameters**

* `collectibles` - A table of `CollectibleType` values corresponding to the items to start with.

### ChallengeParams:SetStartingPocketActives

Modifies the list of starting pocket active items.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetStartingPocketActives({
    CollectibleType.COLLECTIBLE_RED_KEY
})
```

**Parameters**

* `pocketActives` - A table of `PocketItem` values corresponding to the pocket items to start with.

### ChallengeParams:SetRemovedCollectibles

Modifies the list of removed starting items. This is the list of collectibles which are provided as negative numbers in the `startingitems` field. For example, some challenges remove Book of Virtues from Bethany when starting.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `startingitems` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetRemovedCollectibles({
    CollectibleType.COLLECTIBLE_BOOK_OF_VIRTUES
})
```

**Parameters**

* `removedCollectibles` - A table of `CollectibleType` values corresponding to the items to remove.

### ChallengeParams:SetStartingCollectiblesEsau

Modifies the list of starting items for the second player.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `startingitems2` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetStartingCollectiblesEsau({
    CollectibleType.COLLECTIBLE_NUMBER_ONE,
    CollectibleType.COLLECTIBLE_E_COLI
})
```

**Parameters**

* `collectiblesEsau` - A table of `CollectibleType` values corresponding to the items to start with for the second player.

### ChallengeParams:SetStartingTrinkets

Modifies the list of starting trinkets.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `startingtrinkets` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetStartingTrinkets({
    TrinketType.TRINKET_PETRIFIED_POOP
})
```

**Parameters**

* `trinkets` - A table of `TrinketType` values corresponding to the trinkets to start with.

### ChallengeParams:SetStartingCard

Modifies the starting card.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `startingcard` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetStartingCard(Card.CARD_)
```

**Parameters**

* `card` - The `Card` to set as the starting card. Pass `Card.CARD_RANDOM` to select a randomized card.

### ChallengeParams:SetStartingPills

Modifies the starting pills. Pills beyond the first will be spawned as additional pills by ChallengeAPI.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetStartingPills({PillEffect.PILLEFFECT_})
```

**Parameters**

* `pills` - The `PillEffect` to set as the starting pill. Pass `PillEffect.PILLEFFECT_NULL` to select a randomized pill (there's no `PILLEFFECT_RANDOM`, sorry!)

### ChallengeParams:SetStartingMaxHearts

Modifies the player's starting heart containers.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `maxhp` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetStartingMaxHearts(6)
```

**Parameters**

* `maxHearts` - The number of heart containers to start with. `2` equals one full heart. Can be negative to remove starting heart containers!

### ChallengeParams:SetStartingRedHearts

Modifies the player's starting red hearts. Extra starting heart containers will be empty unless you set this.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `redhp` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetStartingRedHearts(2)
```

**Parameters**

* `redHearts` - The number of red hearts to start with. `2` equals one full heart. Can be negative to empty heart containers!

### ChallengeParams:SetStartingSoulHearts

Modifies the player's starting soul hearts.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `soulhp` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetStartingSoulHearts(2)
```

**Parameters**

* `soulHearts` - The number of soul hearts to start with. `2` equals one full heart. Can be negative to remove starting soul hearts!

### ChallengeParams:SetStartingBlackHearts

Modifies the player's starting black hearts.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `blackhp` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetStartingBlackHearts(2)
```

**Parameters**

* `blackHearts` - The number of black hearts to start with. `2` equals one full heart. Can be negative to remove starting black hearts!

### ChallengeParams:SetStartingCoins

Modifies the player's starting coins.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `coins` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetStartingCoins(2)
```

**Parameters**

* `coins` - The number of coins to start with. Can be negative to remove starting coins!

### ChallengeParams:SetStartingDamageBonus

Modifies the player's starting damage bonus. For example, Onan's Streak gives an internal damage bonus of +2.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `adddamage` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetStartingDamageBonus(2)
```

**Parameters**

* `damageBonus` - The amount of damage to add to the player's starting damage. TODO: Can this be negative?

### ChallengeParams:SetMinimumFireRate

Modifies the player's minimum fire rate. This applies a maximum tear rate to the player, usually used to make the player shoot very slowly.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `minfirerate` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetMinimumFireRate(60)
```

**Parameters**

* `minFireRate` - The minimum fire rate to apply to the player. This is the maximum tear delay.

### ChallengeParams:SetIsBlindfolded

Modifies whether the player is blindfolded. This applies the blindfold costume and prevents the player from shooting.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `canshoot` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetIsBlindfolded(true)
```

**Parameters**

* `isBlindfolded` - Whether the player should be blindfolded. Pass `true` to blindfold the player.

### ChallengeParams:SetIsMaxDamage

Modifies whether the player's damage is forcibly clamped to a maximum value.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `maxdamage` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetIsMaxDamage(true)
```

**Parameters**

* `isMaxDamage` - Whether the player's damage should be forcibly clamped to a maximum value. Pass `true` to clamp the player's damage.

### ChallengeParams:SetIsBigRange

Modifies whether the player's range is forcibly clamped to a maximum value.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `bigrange` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetIsBigRange(true)
```

**Parameters**

* `isBigRange` - Whether the player's range should be forcibly clamped to a maximum value. Pass `true` to clamp the player's range.

### ChallengeParams:SetRoomFilter

Modifies the room filter for the challenge. This prevents certain room IDs from spawning.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value for `roomfilter` in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetRoomFilter({
    RoomType.ROOM_TREASURE,
    RoomType.ROOM_SHOP
})
```

**Parameters**

* `roomFilter` - A table of `RoomType` values corresponding to the room types to prevent from spawning.

### ChallengeParams:SetCurse

Modifies the curses for the challenge. This forces the player to have certain curses on every floor.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetCurse({
    LevelCurse.CURSE_OF_DARKNESS,
    LevelCurse.CURSE_OF_THE_UNKNOWN
})
```

**Parameters**

* `curse` - A table of `LevelCurse` values corresponding to the curses to apply to the challenge.

### ChallengeParams:SetCurseFilter

Modifies the curses that are allowed to spawn. This prevents certain curses from appearing on floors.

Note this parameter only changes how the challenge is displayed on the HUD, and does not modify in-game behavior. Make sure to set the proper value in your `challenges.xml` entry appropriately.

```lua
local challenge = ChallengeAPI:GetChallengeById("my-custom-challenge")
challenge:SetCurseFilter({
    LevelCurse.CURSE_OF_DARKNESS,
    LevelCurse.CURSE_OF_THE_UNKNOWN
})
```

**Parameters**

* `curseFilter` - A table of `LevelCurse` values corresponding to the curses to prevent from appearing on floors.

## Challenge-related functions

### ChallengeAPI:GetChallengeByName
Retrieve a challenge by its English name, as defined in the `challenges.xml` file.

```lua
local challenge = ChallengeAPI:GetChallengeByName(name)
```

**Parameters**

* `name` - The name for the challenge, as defined in the `challenges.xml` file.

**Returns**

* The `ChallengeParams` corresponding to the name, or `nil` if no challenge with that name exists.

### ChallengeAPI:GetChallengeById
Retrieve a challenge by its numeric ID, as auto-generated by the game.

```lua
local challenge = ChallengeAPI:GetChallengeById(id)
```

**Parameters**

* `id` - The numeric ID for the challenge, as defined in the `challenges.xml` file.

**Returns**

* The `ChallengeParams` corresponding to the ID, or `nil` if no challenge with that ID exists.
