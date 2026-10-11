Installing RR Turbo (v7.x)
This guide covers all three editions — v7.7 Core, v7.6 Lite, and v7.5 Full.  The steps are identical; only the download size and (for Lite/Full) the AI launch at the end differ.
RR Turbo is written straight to the SSD.  There is no bootable USB and no Windows installer — you deploy the image from any working Windows PC, then move the SSD into the target machine.
> **The deploy uses `wimlib-imagex`, not Windows' own DISM.**  These images are heavily debloated, and a handful of leftover packaged-app files carry security labels that stock Windows tools (DISM / Windows Setup) refuse to apply — they abort with error `0x80070513`.  `wimlib-imagex` applies the image anyway: it warns on those few files and keeps going.  That's why you'll download one small extra tool below, and why **you can't install these images with a normal Windows installer** — only with the method in this guide.
---
Before You Start
On the PC you'll deploy from (any Windows 10/11 machine):
7-Zip installed
wimlib — download the Windows build from wimlib.net/downloads (the `windows-x86_64` `.zip`), and extract it.  Keep `wimlib-imagex.exe` next to its `libwim` DLL — don't separate them.  This is the tool that actually writes the image.
A USB-to-SATA or USB-to-NVMe adapter (or an internal port) for the target SSD
Free space equal to the download plus the extracted `.wim` (budget ~130 GB free for Full, ~45 GB for Lite, ~35 GB for Core)
The target SSD:
256 GB minimum.  Everything on it will be erased.
The target PC:
2-core / 4-thread CPU, UEFI firmware
For local AI: 16 GB system RAM and a GPU with 4 GB+ VRAM (v7.6) or 12 GB (v7.5)
> **Back up first.**  The deploy step erases the entire target SSD.  Double-check the disk number before you type `ERASE`.
---
Step 1 — Download
Download every part of your edition into one folder:
v7.7 Core — ~7 parts, estimated (finalized on release)
v7.6 Lite — 9 parts (`RR-Turbo-v7.6.7z.001` … `.009`)
v7.5 Full — 32 parts (`RR-Turbo-v7.5.7z.001` … `.032`)
7-Zip needs the whole set before it can extract.  A missing part fails the extraction.
Verify the download (optional but recommended):  compare the `SHA256SUMS.txt` published on the release page against your files.  In PowerShell:
```powershell
Get-FileHash .\RR-Turbo-v7.5.7z.001 -Algorithm SHA256
```
---
Step 2 — Extract
Right-click the `.001` file (only the `.001` — not the others).
7-Zip → Extract Here.
Password: `Revolt`
7-Zip stitches the parts back together and produces a single `.wim` file (`RR-Turbo-v7.5.wim` or `RR-Turbo-v7.6.wim`).  That one file is the image.
You can delete the `.7z.0xx` parts once extraction finishes and the `.wim` is in hand.
---
Step 3 — Connect the Target SSD
Connect the SSD to your deploy PC via the adapter.  Windows may prompt to format a new disk — cancel / ignore it.  Don't initialize or format it yourself; the deploy script handles partitioning.
Confirm Windows sees it:
```powershell
Get-Disk | Select-Object Number, FriendlyName, @{n='SizeGB';e={[math]::Round($_.Size/1GB)}}, PartitionStyle
```
Note the disk number of the target SSD.  You'll need it in the next step.
---
Step 4 — Deploy
Open PowerShell as Administrator (right-click → Run as administrator).
Run the deploy script, pointing it at your `.wim` (and, if it isn't under your Downloads folder, at `wimlib-imagex.exe`):
```powershell
.\Install-RRTurbo-wimlib.ps1 -ImagePath .\RR-Turbo-v7.5.wim
```
The script auto-finds `wimlib-imagex.exe` under your Downloads folder.  If you put it elsewhere, add `-WimlibPath "C:\path\to\wimlib-imagex.exe"`.
The script lists every disk and refuses to touch the disk your image is on.  Pick the target SSD's number.
It shows the disk's size one more time, then asks you to type `ERASE` to confirm.
The script then: wipes the disk, creates a clean GPT layout (EFI + MSR + Windows), applies the image with `wimlib-imagex`, clears stale drive mappings, and writes the UEFI boot files with `bcdboot`.  Expect 15–45 minutes depending on the drives.
> **You will see ACL warnings scroll past** — something like *"Could not set security descriptor on 47 files or directories."*  **This is normal and expected.**  Those few packaged-app files get default permissions; everything else applies correctly.  Do **not** re-run as administrator (you already are — it's the security label, not a permissions problem).  The apply still completes, and the image boots fine.
When it finishes ("Deployed … successfully"), safely eject the SSD.
---
Step 5 — Install the SSD and First Boot
Install the SSD in the target PC.
Enter the BIOS/UEFI and set:
Boot mode: UEFI (not Legacy/CSM)
Storage: AHCI — turn off Intel VMD / RST / "RAID" (common on Intel 11th-gen and newer laptops; leaving it on causes `INACCESSIBLE_BOOT_DEVICE`)
Secure Boot: on is fine
Save and boot.
It boots straight to the desktop — no OOBE, no Microsoft account, no setup wizard.  The default account has a blank password; the machine logs in automatically.
> **Set a password if you want one:** Settings → Accounts → Sign-in options → Password.  Or sign in with a Microsoft account / set up Windows Hello.  The blank default is deliberate — the machine is usable the instant it boots, and the owner decides their own security.
---
Step 6 — First-Boot Checklist
[ ] Rename the PC — Settings → System → About → Rename this PC.  (Every install ships with the same name.)
[ ] Set the time zone — location services are off, so Windows can't guess it.
[ ] Install your GPU driver — the image ships with no vendor driver.  Use the clean installers in the Downloads folder: NVCleanstall (NVIDIA) or Radeon Software Slimmer (AMD).  The local AI will not run until the GPU driver is installed.
[ ] Add license keys — Windows 11 Pro (bring your own) and, if you use it, Office 2019 (bring your own).
[ ] Connect to Wi-Fi — only needed for Windows activation and updates; the AI runs fully offline.
---
Step 7 — Launch the AI
Lite and Full only.  v7.7 Core has no local AI — there's nothing to launch, and you're done after Step 6.
Everything is pre-installed at `C:\Users\Public\RenewableRevolt\`.  On the Public desktop, double-click the launcher for your card:
Edition	Launcher
v7.6 Lite (4 GB)	`RR-AI-4GB.bat`
8 GB (DIY)	`RR-AI-8GB.bat`
v7.5 Full (12 GB)	`RR-AI-12GB.bat`
A menu lists the models for your card.  Pick one by number.
The engine loads the model into VRAM (first load takes a few seconds).
Your browser (LibreWolf) opens the interface automatically when the engine is ready:
Text / vision → `http://127.0.0.1:8080`
Image generation → `http://127.0.0.1:7860`
Only one engine runs at a time.  To switch between chat and image generation, close the engine's console window first, then launch the other mode.
Both engines bind to `127.0.0.1` only — nothing is exposed to your network, and nothing leaves the machine.
---
Troubleshooting
Symptom	Fix
"Could not set security descriptor on N files" during apply	Expected and harmless — those packaged-app files get default permissions.  The apply completes; do not re-run as admin.
Error `0x80070513` / the apply aborts	You're using DISM or Windows Setup, not `wimlib-imagex`.  Stock Windows tools can't apply these images — use `Install-RRTurbo-wimlib.ps1` (Step 4).
`wimlib-imagex.exe not found`	Download wimlib from wimlib.net/downloads, extract it under Downloads, or pass `-WimlibPath`.
`INACCESSIBLE_BOOT_DEVICE` on first boot	BIOS: turn off Intel VMD/RST, set storage to AHCI.
BIOS doesn't see the SSD at all	Re-seat it; confirm the port is enabled; try a different M.2/SATA slot.
AI menu loads but the model won't start	GPU driver not installed, or the model is too big for your card's VRAM — pick a smaller model, or install the driver.
Browser doesn't open on launch	The engine still works — manually browse to `http://127.0.0.1:8080` (text) or `:7860` (image).
`gpedit.msc` shows "resource file not found"	Harmless — click OK.  Policy templates for removed features were stripped.
Windows won't activate	You need your own Windows 11 Pro key (Settings → System → Activation).  No key ships with the image.
---
Deploying to Many Machines
The `.wim` is reusable.  Keep it on your deploy PC and run Step 4 for each new SSD — no need to re-extract.  After cloning onto production machines, run DDU in Safe Mode before you image on the master if you've ever installed a vendor driver on it; a clean image carries no GPU driver, and each target installs its own on first boot.
---
Questions or problems:  open an issue on the repo, or renewablerevolt.org.
