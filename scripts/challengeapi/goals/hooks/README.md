# challengeapi.goals.hooks

This folder contains hooks for challenges. These are specialized code, specific to certain challenges, which ensure the challenge plays out as intended.

For example, on challenges where the player must fight The Beast:
- The Srange Door will spawn in Depths 2.
- Both the Polaroid and the Negative will be spawned after defating Mom.
- The trapdoor to The Womb will not spawn.
- The door out of the Mom fight will stay open, even if the room is re-entered.
- The player will be automatically taken to Mausoleum 2 if they enter the Genesis or I AM ERROR special rooms and use the beam of light to travel to the next floor.
- Defeating the Beast will spawn a trophy without triggering the cutscene, allowing you to successfully complete the challenge.

These behaviors are determined by properties on the current challenge goal, and can be disabled on a per-challenge basis by calling `ChallengeAPI:GetChallengeById(id):SetEnableHooks(false)`.
