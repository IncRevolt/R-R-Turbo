# R-R-Turbo

**Privacy-first, debloated Windows 11 Pro image** designed to breathe life back into older hardware — while delivering a noticeable performance boost on virtually any machine running Windows 11.

It strips telemetry, Copilot, Recall, Edge bloat, and Microsoft lock-in at the **ISO level** — so future updates cannot restore what was never shipped.  The result: fewer background processes, dramatically lower RAM usage, and resources that stay where they belong — with you, not Microsoft.

(Unless, of course, you enjoy providing your data for free and cheerfully donating your CPU cycles and RAM to support that effort.)

Built and maintained by [Renewable Revolt](https://renewablerevolt.org/), a veteran-owned 501(c)(3) nonprofit (EIN 99-2777606) dedicated to recovering e-waste, reviving hardware, and redeploying privacy-focused systems.  Stable in production for 9+ months.

## Features

* ~25% fewer background processes at idle
* ~50% more available RAM headroom
* No subscriptions, no surveillance, no AI features
* Pre-installed and configured for long-term stability on legacy hardware (X99, X79, Coffee Lake, etc.)

Results may vary by hardware configuration (YMMV).

## Pre-installed Software

The following programs are chosen intentionally for **maximum performance + maximum productivity** on older and low-resource hardware:

* DuckDuckGo Browser (default)
* LibreWolf (hardened with uBlock Origin)
* Office 2019 Pro Plus (unactivated — user must provide license key)
* Fan Control
* OpenRGB
* uPDF
* **DiskGenius Free** — powerful partition management, imaging, and recovery tool (we use this internally at Renewable Revolt; feel free to uninstall if you don't need it)

**Graphics driver tools** (included in the Downloads folder for post-install use):

* **NVCleanstall** — Lightweight NVIDIA driver installer that removes telemetry and bloat (attribution: [TechPowerUp NVCleanstall](https://www.techpowerup.com/nvcleanstall/))
* **Radeon Software Slimmer** — Tool to slim down AMD Radeon Software (attribution: original project on GitHub)

Users can run DDU in Safe Mode first, then use these tools or download fresh drivers directly from NVIDIA/AMD.

**Minimum recommended specifications** for smooth operation:

* 2-core / 4-thread CPU
* 4 GB RAM
* SSD (SATA III works; NVMe performs best)
* Large paging file (3× RAM for 4 GB systems; 1.5× RAM for 8 GB+)

## What's Removed (Permanent at ISO Level)

**Tiny11 Builder + NTLite layers:**

* Copilot, Recall, all telemetry modules
* Microsoft Edge (including auto-updates)
* Consumer Teams, OneDrive, Xbox apps/Game Bar, Store ads, Start menu web search
* Cortana, Clipchamp, Mail/Calendar, Maps, Weather, News, Tips, Feedback Hub, and most preinstalled consumer apps

**Services & Policies:**

* Telemetry set to Security level
* Driver auto-updates disabled
* Delivery Optimization limited to local network
* Location services, advertising ID, and personal content indexing removed

## Requirements

* Valid **Windows 11 Pro retail license** (not included)
* Valid **Office 2019 Pro Plus license** (not included)
* UEFI boot with Secure Boot optional (works on many non-supported legacy CPUs)

## Installation

**You need two free tools: [7-Zip](https://www.7-zip.org/) and [Rufus](https://rufus.ie/) (or [Ventoy](https://www.ventoy.net/)).**

1. Download **all** parts of the split archive from the [Releases page](https://github.com/IncRevolt/R-R-Turbo/releases).
2. Place all parts (`RR-Turbo-v6.7z.001`, `.002`, etc.) in the **same folder**.
3. Right-click the **first file** (`RR-Turbo-v6.7z.001`) → **7-Zip** → **Extract Here**.
4. You will get the full `RR-Turbo-v6.iso` file.
5. **Rufus:** Select the ISO, leave defaults (GPT, UEFI), click Start.  Choose "Write in ISO Image mode" if prompted.
6. **Ventoy:** Copy the ISO to your Ventoy USB drive and select it from the boot menu.
7. Boot from the USB drive and follow standard Windows 11 setup prompts.

**For the full first-boot checklist (time zone, activation, GPU drivers, and more), see [INSTALLATION.md](INSTALLATION.md).**

## Screenshots

All screenshots taken on the same hardware: **Lenovo IdeaPad 1 14ADA05 (82GW)** — a 2021 budget 14" laptop with:

* **AMD Athlon Silver 3050e** (2C/4T, 1.4–2.8 GHz) — officially supported on Microsoft's Windows 11 CPU compatibility list
* **4 GB soldered DDR4-2400 RAM** (non-upgradable)
* Integrated AMD Radeon Vega 3 graphics

**Before** — Stock Windows 11 + Office 365 (full bloat and telemetry):  
53 background processes | 15% CPU | 68% memory | 39% disk

[![Before - Stock Windows 11 + Office 365](screenshots/task-manager-bloat.png)](screenshots/task-manager-bloat.png)

**After** — RR-Turbo v6 + Office 2019 Pro Plus (debloated, with LibreWolf, Renewable Revolt Windows theme, and custom Revolt background):  
40 background processes | 2% CPU | 52% memory | 0% disk

[![After - RR-Turbo v6](screenshots/task-manager-rr-turbo.png)](screenshots/task-manager-rr-turbo.png)

**RR-Turbo v6 Desktop** (LibreWolf as default browser, Renewable Revolt theme and background):

[![RR-Turbo v6 Desktop](screenshots/rr-turbo-v6-desktop.png)](screenshots/rr-turbo-v6-desktop.png)

**Activating Windows 11 License** (after first boot):

[![Activate Windows 11 License](screenshots/activate-windows-license.png)](screenshots/activate-windows-license.png)

**Activating Office 2019 License**:

[![Activate Office 2019 License](screenshots/activate-office-license.png)](screenshots/activate-office-license.png)

These comparisons show how RR-Turbo transforms marginal, officially "compatible" hardware from sluggish to responsive while restoring privacy and performance on refurbished and legacy PCs.

## For Refurbishers & Builders

The build methodology (UUP Dump → Tiny11 Builder → NTLite → oscdimg ISO packaging) is documented in [INSTALLATION.md](INSTALLATION.md).  Post-install: run DDU in Safe Mode to clean GPU drivers before mass deployment.

## Credits

* Tiny11 Builder (NTDEV), UUP Dump, NTLite
* Fan Control (Rem0o), OpenRGB, LibreWolf
* NVCleanstall (TechPowerUp)
* Radeon Software Slimmer (original project maintainers)
* Renewable Revolt team — extending hardware life, one system at a time.

## About Renewable Revolt

We recover enterprise e-waste, perform secure data destruction, upgrade components, and redeploy affordable, high-performance PCs without bloat or subscriptions.  Focused on veterans, students, families, and gamers who refuse planned obsolescence.

Visit [renewablerevolt.org](https://renewablerevolt.org/) to learn more or support the mission.

---

**License**

This repository (methodology, scripts, documentation) is licensed under the [MIT License](LICENSE).  
The Windows image itself is a modified Microsoft product — users must provide their own valid licenses.  No Microsoft trademarks or copyrighted material beyond fair use for modification is claimed.
