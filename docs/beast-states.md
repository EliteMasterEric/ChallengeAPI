## Beast State values

- 0: Immediately sets the value to 16.
- 1: Unused
- 2: Unused
- 3: Idle
- 4: Charging attack with stalagtites
- 5: Unused
- 6: Unused
- 7: Start of fight, rising from lava
    - If 13 happened just before this, will attack from the lava
- 8: Suck attack with the fire
- 9: Big Brimstone after suck attack
- 10: Rare fire/tears spitting attack
- 11: Switching sides from right to left
- 13: Rare ghost attack
- 14: Unused
- 15: Unused
- 16: Pre-fight, waiting for Horsemen

## Beast (951) Entity Variants
- 0: Main Fight
- 1: Stalactite
- 2: Beast Rock Projectile
- 3: Beast Soul
- 10: Ultra Famine
- 11: Ultra Famine Fly
- 20: Ultra Pestilence
- 21: Ultra Pestilence Fly
- 22: Ultra Pestilence Maggot
- 23: Ultra Pestilence Fly Ball
- 30: Ultra War
- 31: Ultra War Bomb
- 40: Ultra Death
- 41: Ultra Death Scythe
- 42: Ultra Death Head
- 100: Background Beast
- 101: Background Ultra Famine
- 102: Background Ultra Pestilence
- 103: Background Ultra War
- 104: Background Ultra Death

```
lua Isaac.FindByType(951, 0)[1]:ToNPC()
```

## Beast Target Positions

If Beast is on the right side, `entity.TargetPosition` will be `520, 320`
If Beast is charging right-to-left,  `entity.TargetPosition` will be `-149.231, 320`
If Beast is on the left,  `entity.TargetPosition` will be `70.7692, 320`
If Beast is charging left-to-right,  `entity.TargetPosition` will be `789.231, 320`