# Ghosts PC Safe Area Fix

Fixes the dark HUD rectangle when Ghosts PC uses a smaller safe area. HUD corners stay at the screen edges; the minimap and ammo stay inset.

## Install

Copy `safearea_hud` to `<Ghosts folder>/data/ui_scripts/` and restart the game. Requires [IW6 Mod](https://git.alterware.dev/AlterWare/iw6-mod).

Set `safeArea_adjusted_horizontal` and `safeArea_adjusted_vertical` to `0.85` in your game config.

Tested at 2560×1440 borderless. The fix survived a full game restart. Remove the `safearea_hud` folder to uninstall.
