# Building v7.7 "Core" — the No-AI, Legacy/Laptop Edition

v7.7 is the **smallest** edition: the debloated Windows base with **no local AI** and none of the desktop-enthusiast tooling.  It's built for laptops and low-spec legacy machines, and it's the only edition that's genuinely **turn-key** — because it needs no post-install GPU driver step to be useful.

This guide is for the refurbisher/builder.  It is **not** a pure offline prune like v7.6 was — part of it has to run inside the booted OS.  Read "Why two stages" before you start.

---

## Why two stages

Deleting files offline is safe for **inert data** (the AI models — that's how v7.6 was made).  It is **not** safe for **installed programs**, because they register services, kernel drivers, and uninstall entries.  Hand-deleting their folders on the offline drive leaves orphaned services and broken drivers that error on boot.

So v7.7 is built in two stages:

* **Stage 1 — boot the clone and uninstall properly** (this doc, "Class-C teardown").  Needs the running OS so the real uninstallers and DDU can tear things down cleanly.
* **Stage 2 — offline prune of the AI stack** (`Make-RR77.ps1`), then sweep and capture.

---

## What v7.7 removes (vs. v7.6)

| Removed | How | Why |
| --- | --- | --- |
| **All local AI** — models, llama.cpp / stable-diffusion.cpp, the UIs, the `.bat` launchers | Stage 2 (offline) | Core has no AI.  This is the defining change. |
| **Fan Control** (+ PawnIO driver) | Stage 1 uninstall | Laptops manage fans via the EC/BIOS. |
| **OpenRGB** (+ OpenAL, + plugins) | Stage 1 uninstall | No RGB on the target hardware. |
| **Python + Python Launcher** | Stage 1 uninstall | Dead weight — the AI stack was native; nothing else needs it. |
| **uPDF** (+ UPDF_Win) | Stage 1 uninstall | Drop the bundled PDF app.  PDFs open in **DuckDuckGo** instead; users who want a dedicated reader install one. |
| **DiskGenius** | Stage 1 uninstall | It's a *build tool* — it should never ship on a customer image. |
| **Clipchamp, Dev Home, Mobile devices** | Stage 1 (Appx) | Store leftovers; Core keeps the app list minimal. |
| **Vendor GPU driver + folders** (NVIDIA / AMD / Intel) | Stage 1 **DDU** | A clean image carries no vendor driver; Windows Update installs the right generic one on the target. |

v7.7 **keeps**: the debloated Windows 11 Pro 25H2 base, Office 2019 Pro Plus (unactivated), LibreWolf (default browser), DuckDuckGo, and the small system utilities.

---

## Stage 0 — Clone (your proven step)

After v7.6 is captured, **clone the v7.6 master to a spare SSD** with DiskGenius, exactly as you did for v7.5.  That clone is your v7.7 work surface; the v7.6 master stays untouched.

---

## Stage 1 — Boot the clone and tear down (Class-C)

Put the **clone** in a machine and boot it.  Do all of the following in the running OS, then shut down.

### 1a. Uninstall the Win32 apps

**Settings → Apps → Installed apps**, uninstall each (use the app's own uninstaller; let it remove its service/driver):

- Fan Control
- OpenRGB  *(and OpenRGB Effects Plugin, OpenRGB Visual Map Plugin, OpenAL)*
- Python 3.11.9  *(and Python Launcher)*
- UPDF  *(and UPDF_Win, UPDF_Win version 1.0.7.0)*
- DiskGenius

> Reboot once after these so the uninstalled services/drivers are fully gone before capture.

### 1b. Remove the Appx leftovers

Admin PowerShell — removes them for all users **and** stops them returning in new accounts:

```powershell
foreach ($p in 'Clipchamp', 'DevHome', 'CrossDevice') {
    Get-AppxPackage -AllUsers "*$p*" | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$p*" |
        ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue }
}
```

*(“Mobile devices” is the `CrossDevice` package.)*

### 1c. Set DuckDuckGo as the default PDF handler

**Settings → Apps → Default apps** → search `.pdf` → set to **DuckDuckGo**.  (LibreWolf stays the default browser.)

### 1d. DDU the GPU driver

Run **Display Driver Uninstaller in Safe Mode** to remove the vendor GPU driver and its NVIDIA/AMD/Intel folders cleanly — do **not** hand-delete those folders, which risks device errors / `INACCESSIBLE_BOOT_DEVICE`.  This leaves the image with no vendor driver; Windows Update installs the right generic one on the customer's machine.

### 1e. Shut down

Shut the clone down and reconnect it to your build PC as an **offline** drive (note its letter — the examples use `E:`).

---

## Stage 2 — Offline prune, sweep, capture

From your build PC, admin PowerShell:

```powershell
cd C:\Users\Revolt\Downloads
.\Make-RR77.ps1 -Target E:
```

`Make-RR77.ps1`:
* confirms the **v7.6 `.wim` exists** (so you can't destroy the 4 GB build before it's captured),
* **checks the Class-C teardown happened** (warns if Fan Control / OpenRGB / Python / uPDF / DiskGenius are still installed),
* deletes the entire `Users\Public\RenewableRevolt` tree and the `RR-AI-*.bat` launchers,
* empties the Recycle Bin,
* prints the sweep + capture commands.

Then the same final two steps as every edition:

```powershell
.\RR-Sweep.ps1 -Target E:
```

Confirm it reads clean (only `Documents and Settings` flagged — the benign junction), then capture:

```
dism /capture-image /imagefile:D:\RR-Turbo-v7.7.wim /capturedir:E:\ /name:"Windows 11 Pro" /description:"RR Turbo v7.7" /compress:maximum /checkintegrity /verify
```

---

## Validate before upload

Same gate as the other editions: **deploy the `.wim` to a spare SSD with `Install-RRTurbo-wimlib.ps1` and boot it** (the teardown changes the OS, so 7.7 must be booted on its own — a 7.6 boot does not vouch for it).  v7.7 should boot to desktop with no AI launchers on the Public desktop, no Fan Control / OpenRGB / DiskGenius in the app list, and PDFs opening in DuckDuckGo.  Only then 7-zip and upload.

---

*v7.7 Core · the clean one · Recover. Revive. Redeploy.*
