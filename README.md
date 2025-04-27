# ChallengeAPI

A mod for providing custom challenge-related functionality, including custom goals.

## Functionality

- Ability to register custom challenge goal icons.
- Built-in fixes for the following challenge conditions:
    - Delirium
    - Hush
    - Boss Rush
    - Mausoleum II

## Available Functions
- `ChallengeAPI.RegisterChallengeGoal(integer challengeGoalId, string readableName, Sprite spriteObject)`
    - Register a new challenge goal which uses the provided icon.
    - Registering a goal with the same ID as another will replace the name and icon, so keep your custom goals unique.
- `ChallengeAPI.ExcludeChallenge(Challenge challengeId)`
    - Disables the built-in fixes for a given challenge. Use this if you've already implemented custom functionality yourself.
