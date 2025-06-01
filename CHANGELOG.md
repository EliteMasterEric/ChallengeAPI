# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [0.1.1] - 2025-06-??

Various bug fixes for the Beast challenge goal hooks.

### Changed
- Added a workaround for the issue where a Treasure Room and Planetarium spawn on Depths 2 on custom Beast challenges.
    - This is done by adding a hook which replaces the contents of the Treasure Room with a Poop (and unlocks the door so you don't waste a key).

### Fixed
- Fix an issue where REPENTOGON integration would always be disabled.
- Fix a crash when navigating to the last tab in EID.
- Fix a bug where the MomDoorMode was defaulting to `nil` instead of `Default`, messing up checks.
- Fix a bug where the light beam would be deleted in Mausoleum 2 in the Ascent.
- Fix a bug where "Achievements disabled" icon would be shifted over in starting rooms of the Ascent.

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
