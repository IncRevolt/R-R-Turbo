#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Prunes a v7.6 clone down to the v7.7 "Core" build (no AI), ready for capture.

.DESCRIPTION
    Run this AFTER two things are done:
      1. You have captured v7.6 (the safety gate below checks for its .wim).
      2. You BOOTED this clone and did the Class-C teardown from BUILD-77.md
         -- uninstalled Fan Control, OpenRGB, Python, uPDF, DiskGenius; removed
         the Appx leftovers; set DuckDuckGo as the default PDF handler; and ran
         DDU in Safe Mode.  Those steps need the running OS and CANNOT be done
         safely offline.

    This script does only the offline-safe part: it deletes the entire
    Renewable Revolt AI tree and its launchers, empties the Recycle Bin, and
    checks that the Class-C teardown actually happened before you capture.

    SAFETY: it refuses to run unless the v7.6 .wim already exists, so you can't
    destroy the 4 GB build before it's safely captured.

.PARAMETER Target
    Drive letter of the clone's Windows partition.  Default E:

.PARAMETER SixWim
    Path to the already-captured v7.6 image.  Must exist before pruning.
#>
[CmdletBinding()]
param(
    [string]$Target = 'E:',
    [string]$SixWim = 'D:\RR-Turbo-v7.6.wim'
)

$ErrorActionPreference = 'Stop'
$Target = $Target.TrimEnd('\')
$rr = "$Target\Users\Public\RenewableRevolt"

function Write-Step { param([string]$t); Write-Host ''; Write-Host "==> $t" -ForegroundColor Cyan }
function SizeGB { param([string]$p)
    if (-not (Test-Path -LiteralPath $p)) { return 0 }
    $s = (Get-ChildItem -LiteralPath $p -Recurse -File -Force -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
    return [math]::Round(($(if ($s) { $s } else { 0 })) / 1GB, 2)
}

# ---------------------------------------------------------------
# 1. Safety checks
# ---------------------------------------------------------------
Write-Step 'Checks'

if ($Target -ieq $env:SystemDrive) { throw "$Target is the running system drive.  Use the clone's letter." }
if (-not (Test-Path "$Target\Windows\System32\config\SYSTEM")) { throw "$Target is not a Windows drive." }

if (-not (Test-Path -LiteralPath $SixWim)) {
    Write-Host ''
    Write-Warning "The v7.6 image '$SixWim' does not exist."
    Write-Warning 'Pruning now would destroy the 4 GB build before it is captured.'
    $go = Read-Host "Type IHAVE76 only if you captured v7.6 somewhere else; anything else cancels"
    if ($go -cne 'IHAVE76') { Write-Host 'Cancelled.  Capture v7.6 first.'; return }
}
else {
    $wimGB = [math]::Round((Get-Item -LiteralPath $SixWim).Length / 1GB, 1)
    Write-Host "Found v7.6 image: $SixWim ($wimGB GB).  Safe to prune." -ForegroundColor Green
}

# ---------------------------------------------------------------
# 2. Class-C teardown check  (did the boot-time uninstalls happen?)
# ---------------------------------------------------------------
Write-Step 'Class-C teardown check (boot-time uninstalls)'
$leftovers = [ordered]@{
    'Fan Control' = "$Target\Program Files (x86)\FanControl"
    'OpenRGB'     = "$Target\Program Files\OpenRGB"
    'DiskGenius'  = "$Target\Program Files\DiskGenius"
    'uPDF'        = "$Target\Program Files (x86)\UPDF"
    'uPDF_Win'    = "$Target\Program Files (x86)\UPDF_Win"
    'Python'      = "$Target\Users\Revolt\AppData\Local\Programs\Python"
}
$found = @()
foreach ($k in $leftovers.Keys) { if (Test-Path -LiteralPath $leftovers[$k]) { $found += $k } }
if ($found.Count -gt 0) {
    Write-Warning "These Class-C apps are STILL installed: $($found -join ', ')"
    Write-Warning 'They should be uninstalled from the BOOTED clone first (see BUILD-77.md).'
    Write-Warning 'Deleting their folders offline leaves broken services/drivers in the image.'
    if ((Read-Host 'Type GOANYWAY to prune the AI stack regardless, or anything else to stop') -cne 'GOANYWAY') {
        Write-Host 'Stopped.  Boot the clone, run the Class-C teardown, then re-run this.'; return
    }
}
else {
    Write-Host 'Class-C apps look gone -- teardown was done.' -ForegroundColor Green
}

# ---------------------------------------------------------------
# 3. Show what will be deleted
# ---------------------------------------------------------------
Write-Step 'What v7.7 (Core) removes'
$rrGB = SizeGB $rr
Write-Host ("    {0,7:N2} GB   Users\Public\RenewableRevolt   (ALL AI: models, engines, UIs)" -f $rrGB)
$bats = @(Get-ChildItem "$Target\Users\Public\Desktop" -Filter 'RR-AI-*.bat' -ErrorAction SilentlyContinue)
foreach ($b in $bats) { Write-Host "             -   Desktop\$($b.Name)" }
Write-Host ''
Write-Host 'v7.7 keeps: the debloated Windows, Office, LibreWolf, and (unless you removed'
Write-Host 'them in the Class-C teardown) your remaining tools.  It ships with NO local AI.'

Write-Host ''
if ((Read-Host 'Type PRUNE to make these deletions') -cne 'PRUNE') {
    Write-Host 'Cancelled.  Nothing was changed.'; return
}

# ---------------------------------------------------------------
# 4. Delete the AI stack + launchers
# ---------------------------------------------------------------
Write-Step 'Pruning to the Core build'
if (Test-Path -LiteralPath $rr) { Remove-Item -LiteralPath $rr -Recurse -Force; Write-Host "    removed $rr" }
foreach ($b in $bats) { Remove-Item -LiteralPath $b.FullName -Force; Write-Host "    removed $($b.FullName)" }
Remove-Item (Join-Path $Target '$Recycle.Bin') -Recurse -Force -ErrorAction SilentlyContinue
Write-Host '    emptied Recycle Bin'

# ---------------------------------------------------------------
# 5. Verify + report
# ---------------------------------------------------------------
Write-Step 'Result'
$aiGone  = -not (Test-Path -LiteralPath $rr)
$batGone = (@(Get-ChildItem "$Target\Users\Public\Desktop" -Filter 'RR-AI-*.bat' -ErrorAction SilentlyContinue)).Count -eq 0
Write-Host "RenewableRevolt folder removed : $aiGone"
Write-Host "AI launchers removed           : $batGone"
if ($aiGone -and $batGone) { Write-Host 'Clean Core build -- no AI remaining.' -ForegroundColor Green }
else { Write-Warning 'Something is still present above -- check before capturing.' }

Write-Host ''
Write-Host 'Next: final sweep, then capture.' -ForegroundColor Cyan
Write-Host "    .\RR-Sweep.ps1 -Target $Target"
Write-Host "    dism /capture-image /imagefile:D:\RR-Turbo-v7.7.wim /capturedir:$Target\ /name:`"Windows 11 Pro`" /description:`"RR Turbo v7.7`" /compress:maximum /checkintegrity /verify"
