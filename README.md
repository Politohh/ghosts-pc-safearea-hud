# Ghosts PC Safe Area Fix

Fixes hard edges on the HUD corners, blood effect, and killcams when Ghosts PC uses a smaller safe area. HUD content stays inset.

## Install

1. Close Ghosts.
2. Run `.\install.ps1 -GamePath "C:\path\to\Call of Duty Ghosts"` or copy `safearea_hud` to `<Ghosts folder>/data/ui_scripts/`.
3. Set `safeArea_adjusted_horizontal` and `safeArea_adjusted_vertical` to `0.85` in `players2/config_mp.cfg`.
4. Start Ghosts through IW6x / IW6 Mod.

Requires [IW6 Mod](https://git.alterware.dev/AlterWare/iw6-mod). Use the folder that contains `iw6x.exe` (or `iw6mp64_ship.exe`) and the live `data` folder. A leftover Steam install folder can exist without the game files and will not load the mod.

If the game is already running, type `lui_restart` in the IW6 console after copying the folder. The console should print `Loading LUI script '.../data/ui_scripts/safearea_hud'`; if it does not, the files are in the wrong Ghosts folder.

Tested with IW6x 0.0.5 at 2560x1440 borderless. Remove the `safearea_hud` folder to uninstall.
