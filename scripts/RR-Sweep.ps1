#Requires -RunAsAdministrator
# ============================================================
#  RR-Turbo  -  Final capture-prep sweep   (run as Administrator)
#  Concentrates on the failure-mode files: root-level Store / Xbox /
#  packaged-app folders whose security labels broke WIM apply with
#  0x80070513.  Idempotent and safe -- fine to run even if clean.
#  Default target E:  (override with  .\RR-Sweep.ps1 -Target F:)
# ============================================================
param([string]$Target = 'E:')
$Target = $Target.TrimEnd('\')

if ($Target -ieq $env:SystemDrive) { throw "$Target is the running system drive -- use the master SSD's letter." }
if (-not (Test-Path "$Target\Windows\System32\config\SYSTEM")) { throw "$Target is not a Windows drive." }

function Remove-Hard([string]$p) {
    if (-not (Test-Path -LiteralPath $p)) { return $false }
    try { Remove-Item -LiteralPath $p -Recurse -Force -ErrorAction Stop }
    catch {
        & takeown.exe /f $p /r /d y *> $null
        & icacls.exe  $p /grant Administrators:F /t /c *> $null
        Remove-Item -LiteralPath $p -Recurse -Force -ErrorAction SilentlyContinue
    }
    return $true
}

Write-Host "`n=== FAILURE-MODE FOLDERS  (root-level Store / Xbox / packaged-app) ===" -ForegroundColor Cyan
foreach ($name in 'WindowsApps', 'XboxGames', 'WpSystem', 'WUDownloadCache') {
    if (Remove-Hard "$Target\$name") { Write-Host "  removed  $Target\$name" -ForegroundColor Yellow }
}
Remove-Item "$Target\.GamingRoot" -Force -ErrorAction SilentlyContinue

Write-Host "`n=== BUILD / TRANSIENT LEFTOVERS ===" -ForegroundColor Cyan
foreach ($name in 'AMD', 'DRIVERS', 'ISO_Build', 'SWTOOLS', 'DiskGenius_WinPE', 'Windows.old', '$WinREAgent', '$SysReset', '$GetCurrent') {
    if (Remove-Hard "$Target\$name") { Write-Host "  removed  $Target\$name" -ForegroundColor Yellow }
}
Remove-Item "$Target\DumpStack.log", "$Target\DumpStack.log.tmp", "$Target\audio.txt" -Force -ErrorAction SilentlyContinue

Write-Host "`n=== CACHES + RECYCLE BIN ===" -ForegroundColor Cyan
Remove-Hard (Join-Path $Target '$Recycle.Bin') | Out-Null
$do = "$Target\Windows\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Cache"
if (Test-Path $do) { Get-ChildItem $do -Force -ErrorAction SilentlyContinue | ForEach-Object { Remove-Hard $_.FullName | Out-Null } }
Remove-Item "$Target\Windows\SoftwareDistribution\Download\*" -Recurse -Force -ErrorAction SilentlyContinue
Write-Host "  cleared"

Write-Host "`n=== HUNT: anything else at the root that can carry bad labels ===" -ForegroundColor Cyan
$standard = 'Windows', 'Program Files', 'Program Files (x86)', 'ProgramData', 'Users', 'PerfLogs', 'Recovery', 'inetpub', '$Recycle.Bin', 'System Volume Information'
$flag = 0
Get-ChildItem "$Target\" -Force | ForEach-Object {
    $reparse = [bool]($_.Attributes -band [IO.FileAttributes]::ReparsePoint)
    if ($reparse) { Write-Warning "reparse point at root (can carry bad labels): $($_.Name)"; $flag++ }
    elseif ($_.PSIsContainer -and $standard -notcontains $_.Name) { Write-Warning "unexpected root folder (review): $($_.Name)"; $flag++ }
}
if ($flag -eq 0) { Write-Host "  clean -- only standard Windows folders remain" -ForegroundColor Green }
else { Write-Host "  review the $flag item(s) above before capturing" -ForegroundColor Yellow }

Write-Host "`n=== ROOT OF $Target NOW ===" -ForegroundColor Cyan
Get-ChildItem "$Target\" -Force | Select-Object Name,
    @{ n = 'Reparse'; e = { [bool]($_.Attributes -band [IO.FileAttributes]::ReparsePoint) } },
    @{ n = 'Hidden';  e = { [bool]($_.Attributes -band [IO.FileAttributes]::Hidden) } } | Format-Table -AutoSize
