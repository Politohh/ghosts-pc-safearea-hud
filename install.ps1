[CmdletBinding()]
param(
    [string]$GamePath
)

$ErrorActionPreference = "Stop"

$source = Join-Path $PSScriptRoot "safearea_hud"
if (-not (Test-Path (Join-Path $source "__init__.lua"))) {
    throw "safearea_hud/__init__.lua was not found next to install.ps1."
}

if (-not $GamePath) {
    $candidates = @("C:\Games\ghosts_game_files")
    if (${env:ProgramFiles(x86)}) {
        $candidates += Join-Path ${env:ProgramFiles(x86)} "Steam\steamapps\common\Call of Duty Ghosts"
    }
    $candidates += @(
        "D:\SteamLibrary\steamapps\common\Call of Duty Ghosts",
        "E:\SteamLibrary\steamapps\common\Call of Duty Ghosts",
        "F:\SteamLibrary\steamapps\common\Call of Duty Ghosts"
    )

    foreach ($candidate in $candidates) {
        $hasExe = (Test-Path (Join-Path $candidate "iw6x.exe")) -or (Test-Path (Join-Path $candidate "iw6mp64_ship.exe"))
        if ($hasExe -and (Test-Path (Join-Path $candidate "data"))) {
            $GamePath = $candidate
            break
        }
    }
}

if (-not $GamePath) {
    throw "Could not find a Ghosts install. Run: .\install.ps1 -GamePath 'C:\path\to\Call of Duty Ghosts'"
}

$GamePath = (Resolve-Path -LiteralPath $GamePath).Path
$hasExe = (Test-Path (Join-Path $GamePath "iw6x.exe")) -or (Test-Path (Join-Path $GamePath "iw6mp64_ship.exe"))
if (-not $hasExe) {
    throw "No iw6x.exe or iw6mp64_ship.exe in $GamePath"
}

$uiScripts = Join-Path $GamePath "data\ui_scripts"
if (-not (Test-Path $uiScripts)) {
    throw "data\ui_scripts was not found in $GamePath"
}

$target = Join-Path $uiScripts "safearea_hud"
if (Test-Path $target) {
    $backupRoot = Join-Path $GamePath "data\ui_scripts_backups"
    New-Item -ItemType Directory -Path $backupRoot -Force | Out-Null
    $backup = Join-Path $backupRoot ("safearea_hud-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
    Move-Item -LiteralPath $target -Destination $backup
    Write-Host "Backed up the existing install to $backup"
}

Copy-Item -LiteralPath $source -Destination $target -Recurse
Write-Host "Installed safearea_hud to $target"
Write-Host "Set safeArea_adjusted_horizontal and safeArea_adjusted_vertical to 0.85 in players2\config_mp.cfg."
Write-Host "Restart Ghosts, or type lui_restart in the IW6 console."
