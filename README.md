# ChallengeAPI

A library mod for providing custom challenge-related functionality, including custom goals, EID descriptions, and more.

## Functionality

- Adds a new category to External Item Descriptions. Hold the MAP button to view the goal, starting items, and restrictions for the current challenge.
    - Vanilla challenges are automatically registered.
    - (REPENTOGON only) Descriptions are automatically generated for custom challenges, and can be edited with a straightforward API.
- Replaces the challenge goal HUD icon with a customizable interface.
    - This allows you to create custom challenge goals and display them in the challenge HUD and in the EID description.
- Built-in fixes for challenge goals which would otherwise have major issues:
    - The Beast (trophy spawning and softlock prevention)
- Built-in fixes for challenge XML attributes which would otherwise have major issues:
    - `startingpill` (properly supports Little Baggy)
    - `roomfilter` (REPENTOGON only, properly supports Devil and Angel rooms)

## Upcoming Features

- Built-in fixes for the following challenge goals:
    - [] Delirium
    - [] Hush
    - [] Boss Rush
    - [] Mausoleum II
- Functionality to force stage types for specific floors
    - 30 floors of Cellar, anyone?
- Functionality to blacklist certain items from appearing
- (REPENTOGON only) Custom challenge XML attributes
    [] startingpocketitems="collectibleId,commaSeparated"
    [] notrinkets=true/false
    [] startinggulpedtrinkets="trinketId,commaSeparated"

## Documentation

See [the API documentation](docs/api.md) for more information on how to use this library to add custom challenge goals and descriptions to your mods.

## Credits

- **EliteMasterEric**: Lead Developer
- **CevaSkullderg**: Playtesting

**Special Thanks**

- **Lizzy**: For being awesome and helping with the code for this
- **MrHeadcrab**: For being awesome and helping with the code for this
- **wofsauge**: For structuring External Item Descriptions well
