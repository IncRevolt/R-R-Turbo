#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Prunes the offline master (currently the full v7.5 build) down to the
    4 GB v7.6 build, ready for capture.

.DESCRIPTION
    Run AFTER you have captured v7.5.  It keeps only the two models the 4 GB
    tier uses -- Bonsai 8B (text) and DreamShaper 8 (image) -- deletes every
    other model, keeps only RR-AI-4GB.bat on the Public desktop, empties the
    Recycle Bin, and prints the v7.6 capture command.

    SAFETY: it refuses to run unless the v7.5 .wim already exists, so you
    can't prune the master before the full image is safely captured.

.PARAMETER Target
    Drive letter of the master SSD's Windows partition.  Default E:

.PARAMETER FullWim
    Path to the already-captured v7.5 image.  Must exist before pruning.
#>
[CmdletBinding()]
param(
    [string]$Target  = 'E:',
    [string]$FullWim = 'D:\RR-Turbo-v7.5.wim'
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

if ($Target -ieq $env:SystemDrive) { throw "$Target is the running system drive.  Use the master SSD's letter." }
if (-not (Test-Path "$rr\models\Bonsai-8B-Q1_0.gguf")) { throw "Doesn't look like the full RR master at $Target." }

if (-not (Test-Path -LiteralPath $FullWim)) {
    Write-Host ''
    Write-Warning "The v7.5 image '$FullWim' does not exist."
    Write-Warning 'Pruning now would destroy the full build before it is captured.'
    $go = Read-Host "Type IHAVE75 only if you captured v7.5 somewhere else; anything else cancels"
    if ($go -cne 'IHAVE75') { Write-Host 'Cancelled.  Capture v7.5 first.'; return }
}
else {
    $wimGB = [math]::Round((Get-Item -LiteralPath $FullWim).Length / 1GB, 1)
    Write-Host "Found v7.5 image: $FullWim ($wimGB GB).  Safe to prune." -ForegroundColor Green
}

# ---------------------------------------------------------------
# 2. Build keep / delete lists
# ---------------------------------------------------------------
Write-Step 'What the 4 GB (v7.6) build keeps'
Write-Host '    models\Bonsai-8B-Q1_0.gguf                     (text)'
Write-Host '    sd\models\sd15\DreamShaper_8_pruned.safetensors (image)'
Write-Host '    Desktop\RR-AI-4GB.bat'

$deleteFiles = @(
    "$rr\models\Ternary-Bonsai-2-27B-PTQ1_0.gguf",
    "$rr\models\Ternary-Bonsai-2-27B-mmproj-Q8_0.gguf",
    "$rr\models\qwen2.5-coder-7b-instruct-q4_k_m.gguf",
    "$rr\models\qwen2.5-coder-14b-instruct-q4_k_m.gguf",
    "$rr\sd\models\sd15\Realistic_Vision_V6.0_NV_B1.safetensors",
    "$rr\sd\models\sd15\vae-ft-mse-840000-ema-pruned.safetensors"
)
$deleteDirs = @(
    "$rr\sd\models\sdxl",
    "$rr\sd\models\zimage"
)
$deleteBats = @(
    "$Target\Users\Public\Desktop\RR-AI-8GB.bat",
    "$Target\Users\Public\Desktop\RR-AI-12GB.bat"
)

Write-Step 'What it will delete'
$freed = 0
foreach ($p in ($deleteFiles + $deleteDirs + $deleteBats)) {
    if (Test-Path -LiteralPath $p) {
        $gb = SizeGB $p; $freed += $gb
        '{0,7:N2} GB   {1}' -f $gb, ($p.Substring($Target.Length + 1)) | Write-Host
    }
}
Write-Host ('Frees about {0:N1} GB.' -f $freed)

Write-Host ''
if ((Read-Host 'Type PRUNE to make these deletions') -cne 'PRUNE') {
    Write-Host 'Cancelled.  Nothing was changed.'; return
}

# ---------------------------------------------------------------
# 3. Delete
# ---------------------------------------------------------------
Write-Step 'Pruning to the 4 GB build'
foreach ($p in $deleteFiles + $deleteBats) {
    if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Force; Write-Host "    removed $p" }
}
foreach ($p in $deleteDirs) {
    if (Test-Path -LiteralPath $p) { Remove-Item -LiteralPath $p -Recurse -Force; Write-Host "    removed $p" }
}
Remove-Item (Join-Path $Target '$Recycle.Bin') -Recurse -Force -ErrorAction SilentlyContinue

# ---------------------------------------------------------------
# 4. Verify + report
# ---------------------------------------------------------------
Write-Step 'Result'
$leftText  = @(Get-ChildItem "$rr\models" -File -Filter *.gguf -ErrorAction SilentlyContinue).Name
$leftImage = @(Get-ChildItem "$rr\sd\models" -Recurse -File -ErrorAction SilentlyContinue |
               Where-Object { $_.Extension -in '.safetensors', '.gguf' }).Name
$leftBats  = @(Get-ChildItem "$Target\Users\Public\Desktop" -Filter *.bat -ErrorAction SilentlyContinue).Name

Write-Host "Text models left  : $($leftText -join ', ')"
Write-Host "Image models left : $($leftImage -join ', ')"
Write-Host "Launchers left    : $($leftBats -join ', ')"
Write-Host ('RenewableRevolt folder now: {0:N1} GB' -f (SizeGB $rr))

$ok = ($leftText -contains 'Bonsai-8B-Q1_0.gguf') -and
      ($leftImage -contains 'DreamShaper_8_pruned.safetensors') -and
      ($leftBats -contains 'RR-AI-4GB.bat') -and ($leftBats.Count -eq 1) -and
      ($leftText.Count -eq 1)
if ($ok) { Write-Host 'Clean 4 GB build.' -ForegroundColor Green }
else { Write-Warning 'Unexpected leftovers above -- check before capturing.' }

Write-Host ''
Write-Host 'Now capture v7.6 (admin command prompt):' -ForegroundColor Cyan
Write-Host "    dism /capture-image /imagefile:D:\RR-Turbo-v7.6.wim /capturedir:$Target\ /name:`"Windows 11 Pro`" /description:`"RR Turbo v7.6`" /compress:maximum /checkintegrity /verify"
