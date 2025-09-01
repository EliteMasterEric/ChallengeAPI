# Goals

In ChallengeAPI, goals are identified using a string ID. You can use `ChallengeAPI:GetGoalById` to retrieve a goal by its string ID, and fetch its properties, or use `ChallengeAPI:GetGoalByChallengeParams` to retrieve a goal with matching parameters.

Goals are used to determine the icon and description of associated challenges in EID; they can additionally enable custom behavior, such as 

All the vanilla challenge goals are registered with ChallengeAPI:

- `mom`: Defeat Mom in Depths 2
- `moms-heart`: Defeat Mom's Heart in Womb 2
- `satan`: Defeat Satan in Sheol
- `isaac`: Defeat Isaac in Cathedral
- `blue-baby`: Defeat ??? (Blue Baby) in Chest
- `the-lamb`: Defeat The Lamb in Dark Room
- `mega-satan`: Defeat Mega Satan in Dark Room
- `mother`: Defeat Mother in Corpse

ChallengeAPI also includes the following custom challenge goals:

- `beast`: Defeat The Beast in Home

You can also create your own custom challenge goals, see the [Goal documentation](api.md#ChallengeAPI.Goal) for more information.