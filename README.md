# ChallengeAPI

A library mod for providing custom challenge-related functionality, including custom goals, EID descriptions, and more.

## Functionality

- Adds a new category to External Item Descriptions. Hold the MAP button to view the goal, starting items, and restrictions for the current challenge.
    - Vanilla challenges are automatically registered.
    - (REPENTOGON only) Descriptions are automatically generated for custom challenges, and can be edited with a straightforward API.
- Replaces the challenge goal HUD icon with a customizable interface.
    - This allows you to create custom challenge goals and display them in the challenge HUD and in the EID description.

## Upcoming Features

- Built-in fixes for the following challenge goals:
    - [] Beast
    - [] Delirium
    - [] Hush
    - [] Boss Rush
    - [] Mausoleum II
- (REPENTOGON only) Custom challenge XML attributes
    [] startingpocket="collectibleId,commaSeparated"
    [] notrinkets=true/false
    [] startingsmeltedtrinkets="trinketId,commaSeparated"

goto x.itemdungeon.666

## Documentation

See [the API documentation](docs/api.md) for more information on how to use this library to add custom challenge goals and descriptions to your mods.

## Credits

- **EliteMasterEric**: Lead Developer
- **CevaSkullderg**: Playtesting

**Special Thanks**

- **Lizzy**: For being awesome
- **wofsauge**: For structuring External Item Descriptions well
