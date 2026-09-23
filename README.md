# Ghosts PC safe-area corner fix

An IW6 Mod LUI add-on for Call of Duty: Ghosts Multiplayer on PC. It moves the four dark HUD corner-vignette images to the actual screen edges when the adjusted safe area is inset. The minimap, scoreboard, ammo, and other HUD elements still follow Ghosts' normal adjusted safe-area settings.

The issue is most visible at 2560×1440 borderless with both `safeArea_adjusted_horizontal` and `safeArea_adjusted_vertical` set to `0.85`: the bottom-right vignette ends at the inset safe-area boundary, leaving a large, hard-edged dark rectangle beside the ammo HUD. The stock [Ghosts LUI HUD script](https://git.alterware.dev/AlterWare/iw6-lui) creates this vignette in `fourCornersHudDef`. This add-on changes only that container's geometry, leaving other HUD constructors untouched.

## Install

Requires an IW6 client that loads custom LUI scripts from `data/ui_scripts`, such as [AlterWare IW6 Mod](https://git.alterware.dev/AlterWare/iw6-mod).

1. Copy `safearea_hud` into `<Ghosts game folder>/data/ui_scripts/` so the file is `<Ghosts game folder>/data/ui_scripts/safearea_hud/__init__.lua`.
2. Set `safeArea_adjusted_horizontal` and `safeArea_adjusted_vertical` to `0.85` in the usual game configuration.
3. Restart Ghosts. To uninstall, remove only the `safearea_hud` add-on directory and restart.

## Validation

Tested on IW6 Mod v0.0.4 at 2560×1440 borderless, with both adjusted safe-area values at `0.85`. The user confirmed the hard-edged rectangle was gone and spawning still worked, then fully restarted Ghosts and confirmed the fix persisted. The installed file matched this repository file by SHA-256 (`0A1CF8936DF643DE7FAD7057D0CDEE484FFBCA2D7D6094E90546B6AE51E3F07A`) after that restart. Other resolutions, clients, and game modes have not been tested.
