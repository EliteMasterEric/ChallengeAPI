# ChallengeAPI

A mod for providing custom challenge-related functionality, including custom goals.

## Functionality

[] Refactor curse data to specify Curse descriptions instead of names
[] Add secret path under goal description
[] Display removed items
[] Fix "random pill" description line not displaying (#6 King)
[] Display Esau starting items
[] Fix specific pill description line being wrong (#12 Live gives lemons)
[] Fix random card description line displaying wrong (#14 In the cards)
[] Fix error with +coins (#24 PAY TO PLAY)
[] Fix error with onans streak (#29)

[] XXXXXXXXL manual description
[] SPEED! manual description
[] PAY TO PLAY manual description
[] Have a Heart manual description
[] Pride Day manual description
[] Onans Streak manual description
[] The Guardian manual description
[] Backasswards manual description
[] Aprils Fool manual description
[] Pokey mans manual description
[] Ultra Hard manual description
[] Seeing Double manual description
[] Pica Run manual description
[] Hot Potato manual description
[] Cantripped manual description
[] Red Redemption manual description
[] DELETE THIS manual description


- Built-in fixes for the following challenge conditions:
    - Beast
    - [] Delirium
    - [] Hush
    - [] Boss Rush
    - [] Mausoleum II
- Ability to register custom challenge goal icons.

    [] notrinkets

## Available Functions
- `ChallengeAPI.RegisterChallengeGoal(integer challengeGoalId, string readableName, Sprite spriteObject)`
    - Register a new challenge goal which uses the provided icon.
    - Registering a goal with the same ID as another will replace the name and icon, so keep your custom goals unique.
- `ChallengeAPI.ExcludeChallenge(Challenge challengeId)`
    - Disables the built-in fixes for a given challenge. Use this if you've already implemented custom functionality yourself.
