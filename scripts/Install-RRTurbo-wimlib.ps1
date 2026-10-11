#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Deploy an RR Turbo WIM to an SSD using wimlib-imagex instead of DISM's
    Expand-WindowsImage.

.WHY
    DISM aborts the whole apply with 0x80070513 / STATUS_INVALID_LABEL when one
    file's security descriptor carries a label SID the fresh volume won't accept
    (the packaged-app folders in this image lineage do).  wimlib-imagex is
    non-strict on ACLs by default: it warns on a descriptor it can't set and
    keeps going, so the apply completes.  The few affected files get default
    inherited ACLs, which is fine for this debloated image.

.SETUP
    1. On this PC, download wimlib from  https://wimlib.net/downloads/
       (the "windows-x86_64" .zip).
    2. Extract it anywhere under your Downloads folder (keep wimlib-imagex.exe
       next to its libwim DLL -- don't separate them).
    3. Run this script as Administrator.

.PARAMETER ImagePath
    The .wim to deploy, e.g.  D:\RR-Turbo-v7.6.wim

.PARAMETER WimlibPath
    Full path to wimlib-imagex.exe.  Auto-detected under Downloads if omitted.
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)] [string]$ImagePath,
    [string]$WimlibPath
)
$ErrorActionPreference = 'Stop'
function Die($m) { Write-Host "ERROR: $m" -ForegroundColor Red; exit 1 }

# --- locate wimlib-imagex.exe ---
if (-not $WimlibPath) {
    $WimlibPath = Get-ChildItem "$env:USERPROFILE\Downloads" -Recurse -Filter 'wimlib-imagex.exe' -ErrorAction SilentlyContinue |
                  Select-Object -First 1 -ExpandProperty FullName
}
if (-not $WimlibPath -or -not (Test-Path $WimlibPath)) {
    Die "wimlib-imagex.exe not found.  Get it from https://wimlib.net/downloads/ , extract under Downloads, or pass -WimlibPath."
}
if (-not (Test-Path $ImagePath)) { Die "Image not found: $ImagePath" }
Write-Host "wimlib : $WimlibPath" -ForegroundColor Cyan
Write-Host "image  : $ImagePath"  -ForegroundColor Cyan

# --- sanity: wimlib can read the image ---
Write-Host "`n==> Image info (wimlib)" -ForegroundColor Cyan
& $WimlibPath info "$ImagePath" 1 | Out-Host
if ($LASTEXITCODE -ne 0) { Die "wimlib could not read the image." }

# --- which disk holds the image? (so we never erase it) ---
$imgLetter  = (Get-Item $ImagePath).PSDrive.Name
$imgDiskNum = (Get-Partition -DriveLetter $imgLetter -ErrorAction SilentlyContinue).DiskNumber

Write-Host "`n==> Disks" -ForegroundColor Cyan
Get-Disk | Sort-Object Number | Format-Table Number, FriendlyName,
    @{n='SizeGB';e={[math]::Round($_.Size/1GB)}}, BusType, PartitionStyle -AutoSize

$target = Read-Host "`nEnter the Disk NUMBER to ERASE and deploy to (Enter cancels)"
if ($target -eq '') { Write-Host 'Cancelled.'; exit }
$disk = Get-Disk -Number $target -ErrorAction Stop
if ($disk.Number -eq $imgDiskNum) { Die "Disk $target holds the image.  Pick a different disk." }

Write-Host ("`nDisk {0}: {1}, {2} GB, {3}" -f $disk.Number, $disk.FriendlyName, [math]::Round($disk.Size/1GB), $disk.BusType) -ForegroundColor Yellow
Write-Host "EVERYTHING on this disk will be permanently erased." -ForegroundColor Yellow
if ((Read-Host "Type ERASE to continue") -cne 'ERASE') { Write-Host 'Cancelled.'; exit }

# --- partition: GPT = EFI(260MB) + MSR(16MB) + Windows(rest) ---
Write-Host "`n==> Partitioning disk $target (S: = EFI, W: = Windows)" -ForegroundColor Cyan
@"
select disk $target
clean
convert gpt
create partition efi size=260
format quick fs=fat32 label=System
assign letter=S
create partition msr size=16
create partition primary
format quick fs=ntfs label=Windows
assign letter=W
exit
"@ | diskpart | Out-Host

# --- apply with wimlib (the step DISM couldn't finish) ---
Write-Host "`n==> Applying image with wimlib-imagex" -ForegroundColor Cyan
Write-Host "    (ACL warnings on packaged-app files are EXPECTED and harmless)" -ForegroundColor DarkGray
& $WimlibPath apply "$ImagePath" 1 "W:\"
if ($LASTEXITCODE -ne 0) { Die "wimlib apply returned exit code $LASTEXITCODE." }

# --- clear stale drive-letter mappings so the deployed OS assigns fresh ---
Write-Host "`n==> Clearing stale drive-letter mappings" -ForegroundColor Cyan
$loaded = $false
try {
    reg load HKLM\RR_SYS "W:\Windows\System32\config\SYSTEM" *>$null; $loaded = $true
    reg delete HKLM\RR_SYS\MountedDevices /f *>$null
    Write-Host "    cleared"
} catch { Write-Warning "MountedDevices clear skipped (non-fatal)." }
finally { if ($loaded) { [gc]::Collect(); Start-Sleep 1; reg unload HKLM\RR_SYS *>$null } }

# --- UEFI boot files ---
Write-Host "`n==> Writing UEFI boot files (bcdboot)" -ForegroundColor Cyan
& bcdboot W:\Windows /s S: /f UEFI
if ($LASTEXITCODE -ne 0) { Die "bcdboot returned exit code $LASTEXITCODE." }

Write-Host "`nDeployed $ImagePath to disk $target successfully." -ForegroundColor Green
Write-Host "Move the SSD into a machine (UEFI, AHCI, Intel VMD off) and boot it." -ForegroundColor Green
