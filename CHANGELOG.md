# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.3.0] - 2025-09-??

A few new challenge-related features.

### Added
- Added the `ChallengeParams:SetRequiresRepentogon(bool)` function.
    - If enabled, a black screen will cover the screen and prevent the player from playing the challenge, as long as REPENTOGON is not installed.
    - Great in combination with the REPENTOGON-only `hidden` XML flag, or if your challenge utilizes hooks that only function with REPENTOGON.
- Added built-in fixes for the `roomfilter` XML attribute.
    - Values `14` (Devil Room) and `15` (Angel Room) will now negate your Devil and Angel chance as expected.
    - Value `16` (Crawlspace) will now prevent Crawlspaces from spawning.
        - This currently doesn't discriminate between Crawlspaces and Black Markets.


## [0.2.0] - 2025-08-19

Various bug fixes for the Beast challenge goal hooks.

### Changed
- Added a workaround for the issue where a Treasure Room and Planetarium spawn on Depths 2 on custom Beast challenges.
    - This is done by adding a hook which removes the door, hides the room on the map, and teleports the player out of the room as soon as they enter.

### Fixed
- Fix an issue where REPENTOGON integration would always be disabled.
- Fix a crash when navigating to the last tab in EID.
- Fix a bug where the MomDoorMode was defaulting to `nil` instead of `Default`, messing up checks.
- Fix a bug where the light beam would be deleted in Mausoleum 2 in the Ascent.
- Fix a bug where "Achievements disabled" icon would be shifted over in starting rooms of the Ascent.
- Fix a bug where two boss doors would appear in Depths 2.
- Fix a bug where boss doors would appear in the Death Certificate area.
- Fix a bug where the goal icon would not shake with the HUD properly.

### Known Issues
- "Achievements disabled" icon gets shifted over in the starting room of Depths 2. This is a minor visual glitch that only happens in one room.
- In challenges targeting The Beast, Depths is forced to never be XL. This doesn't affect gameplay too much since the floor will still generate properly.


## [0.1.0] - 2025-05-19

Initial private beta release.

### Added
- Added EID integration.
- Added the custom challenge goal HUD icon.
- Applied hooks for challenge goals targeting The Beast
- Applied hooks for XML attribute: `startingpill`
