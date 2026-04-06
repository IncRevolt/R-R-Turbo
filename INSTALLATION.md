# RR-Turbo v6 — Installation Guide

## What You Need

* **7-Zip** (free) — [7-zip.org](https://www.7-zip.org/)
* **Rufus** (recommended) — [rufus.ie](https://rufus.ie/) — OR **Ventoy** — [ventoy.net](https://www.ventoy.net/)
* A **USB drive** (16 GB minimum)
* A valid **Windows 11 Pro retail license key**
* A valid **Office 2019 Pro Plus license key**

## Step 1 — Download

Go to the [Releases page](https://github.com/IncRevolt/R-R-Turbo/releases) and download **all** parts of the split archive:

```
RR-Turbo-v6.7z.001
RR-Turbo-v6.7z.002
RR-Turbo-v6.7z.003
...
```

Place all parts in the **same folder**.  Do not rename any files.

## Step 2 — Extract

1. Install [7-Zip](https://www.7-zip.org/) if you haven't already.
2. Right-click the **first file** (`RR-Turbo-v6.7z.001`).
3. Select **7-Zip → Extract Here**.
4. When prompted for a password, enter: **Revolt**
5. Wait for extraction to complete.  You will get a single file: `RR-Turbo-v6.iso`.

**Troubleshooting:** If extraction fails, re-download any parts that show a different file size than the others on the Releases page.  All parts except the last should be the same size.

## Step 3 — Create Bootable USB

### Option A — Rufus (Recommended)

1. Open Rufus.
2. Select your USB drive under **Device**.
3. Click **SELECT** and choose `RR-Turbo-v6.iso`.
4. Rufus will auto-detect the settings.  Confirm they match the screenshot below:

![Rufus Settings](screenshots/rufus-settings.png)

**Recommended Rufus settings:**

* **Image option:** Standard Windows installation
* **Partition scheme:** GPT
* **Target system:** UEFI (non CSM)
* **File system:** NTFS

5. Click **START**.
6. Rufus will show a **"Windows User Experience"** dialog.  Check all of the following:

* ✅ Remove requirement for 4GB+ RAM, Secure Boot and TPM 2.0
* ✅ Remove requirement for an online Microsoft account
* ✅ Create a local account with username (your choice)
* ✅ Set regional options to the same values as this user's
* ✅ Disable data collection (Skip privacy questions)
* ✅ Disable BitLocker automatic device encryption

7. Click **OK**, then wait for the write to complete.

**Why these matter:** The TPM/Secure Boot bypass is essential if you're running X79, X99, or other legacy hardware.  The local account option lets you skip the Microsoft account requirement entirely.  Disabling BitLocker prevents automatic encryption on refurbished drives where you want full control.

### Option B — Ventoy

1. Install Ventoy on your USB drive (this only needs to be done once).
2. Copy `RR-Turbo-v6.iso` to the Ventoy partition on the USB drive.
3. Boot from the USB drive and select the ISO from the Ventoy menu.

## Step 4 — Install (No Internet Required)

**Do not connect to Wi-Fi or Ethernet during setup.**  RR-Turbo is designed for fully offline installation.

1. Boot from the USB drive (adjust BIOS boot order if needed — typically F2, F12, or DEL during POST).
2. At the **"Select language settings"** screen, confirm English (United States) and click **Next**.
3. Click **Install now**.
4. When asked for a product key, click **"I don't have a product key"** — you'll activate after setup.
5. Select **Windows 11 Pro** from the edition list.
6. Accept the license terms.
7. Choose **"Custom: Install Windows only (advanced)"**.
8. Select your target drive and click **Next**.  Windows will install and reboot.

### Offline Account Setup (OOBE)

After the install reboots, Windows will try to get you online.  Stay offline:

1. **Region:** Select your country, click **Yes**.
2. **Keyboard layout:** Confirm or add layouts, click **Yes** / **Skip**.
3. **Network:** When Windows asks you to connect to a network:
   * If you used the Rufus bypass (recommended), it will skip this step automatically and go straight to local account creation.
   * If you did NOT use the Rufus bypass: press **Shift+F10** to open a command prompt, type `oobe\bypassnro`, press Enter.  The PC will reboot and you'll get an **"I don't have internet"** option at the network screen.  Click it, then click **"Continue with limited setup"**.
4. **Account name:** Enter your preferred username.
5. **Password:** Set your password.
6. **Security questions:** Answer three security questions (required for local accounts).
7. **Privacy settings:** Toggle everything off, click **Accept**.

Windows will finalize setup and boot to the desktop.

## Step 5 — First Boot Checklist

After reaching the desktop, complete these steps in order:

1. **Restart once** — some Group Policy changes require a reboot to fully apply.
2. **Set your time zone** — Settings → Time & Language → Date & Time.  De-select "Set time automatically," set the correct time, then re-select "Set time automatically."
3. **Change your location** — the default location is an Easter egg.  Set it to your actual location if desired.
4. **Activate Windows** — Settings → System → Activation → Change Product Key.  Enter your valid Windows 11 Pro retail key.
5. **Activate Office 2019** — open any Office app (e.g., Excel) → Account → Switch License → enter your valid Pro Plus key.
6. **Install GPU drivers** — no vendor GPU drivers are included (ships with Microsoft Basic Display Adapter).  Use NVCleanstall (NVIDIA) or Radeon Software Slimmer (AMD) from the Downloads folder, or download fresh drivers directly from the manufacturer.  Running DDU in Safe Mode first is recommended.
7. **Configure Fan Control** — pre-configured for Thermalright air coolers.  Click the wrench icon → Assisted Setup to reconfigure for your hardware.  **Save your profile.**
8. **Configure OpenRGB** — pre-configured for Nollie ARGB controllers.  Reconfigure as needed.  Guide at [nolliergb.com](https://nolliergb.com/).  **Save your profile.**
9. **Run Windows Update once** — connect to the internet and run Windows Update to pick up any critical security patches.

## Known Issues

* **Group Policy Editor warning** — you will see a "resource file could not be found" error when opening `gpedit.msc`.  This is harmless and expected — we removed the policy templates for bloat that no longer exists.  Click OK and continue.
* **Adobe Acrobat** — if installed separately, can freeze 4 GB RAM machines when running alongside a browser and Office.  We ship uPDF as the default PDF reader.  Use Ctrl+Alt+Del to close Adobe if it locks up.

## Hardware Minimums

* 2C/4T CPU or better
* 4 GB RAM (SSD required)
* SSD (SATA III works; NVMe recommended)

For 4 GB RAM systems: set a paging file of 3× RAM (12,288 MB).  For 8 GB+, use 1.5× RAM.

System Properties → Advanced → Performance Settings → Advanced → Virtual Memory.

Machines below these specs are better served by a lightweight Linux distribution such as Peppermint OS or Bodhi Linux.

## Licensing

This image does **not** include a Windows or Office license.  Users must provide their own valid retail keys.  Renewable Revolt ships valid licenses on all machines sold through our organization — independent users are responsible for their own licences.

