# R-R-Turbo

Debloated Windows 11 Image

# Win 11 Pro [RR Turbo]

### A Privacy-First Windows 11 Pro Image by Renewable Revolt, Incorporated

**Version:** v6  
**Base:** Windows 11 Pro (24H2)  
**Built with:** UUP Dump · Tiny11 Builder (NTDEV) · NTLite  
**Status:** Active production deployment — shipped on every Renewable Revolt build  
**License:** MIT (build methodology and scripts)

---

> *"If extending the lifespan of electronics is cool...consider us Miles Davis."*  
> Renewable Revolt, Inc. · Hammond, Indiana · 501(c)(3) · EIN: 99-2777606  
> [renewablerevolt.org](https://renewablerevolt.org) · Veteran Owned & Operated  
> On X — [@IncRevolt](https://x.com/IncRevolt)

---

## What This Is

RR Turbo is a custom Windows 11 Pro image built for refurbished and legacy hardware.  
It ships on every machine we build — and we're publishing it so anyone else can use it.

The goal is simple: a Windows installation that works *for the person sitting in front of it*, not for Microsoft's data collection pipeline, advertising network, or upsell funnel.

This is not a debloat script that gets reversed on the next update.  Everything removed is removed **at the ISO level** — before the OS ever touches the drive.  Windows updates do not bring it back.  We proved this over multiple production deployment cycles across dozens of machines on multiple hardware platforms.  Five versions over four years, culminating in v6.

---

## Verified Performance

Measured on: **Lenovo IdeaPad 1 14ADA05 · AMD Athlon Silver 3050e · 4GB DDR4-2400**

| Metric | Result |
|---|---|
| Background processes vs. stock Win 11 Home | **~25% fewer** |
| Available RAM headroom vs. stock Win 11 Home | **~50% more** |

On a constrained 4GB system, that headroom is the difference between smooth operation and constant disk swapping.  On 16GB, it's the margin that keeps your game from hitting the page file the moment Discord opens.

---

## License Requirements

> ⚠️ **This image does not include a Windows license.**

Users must provide their own valid **Windows 11 Pro** retail license.  
Apply it after installation:

```
slmgr /ipk XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
```

> ⚠️ **This image includes Office 2019 Pro Plus pre-installed.**

Users must provide their own valid **Office 2019 Pro Plus** license.  
The suite is ready to use — activation requires your own key.

Purchase licenses only from authorized Microsoft resellers.

We ship this image on machines sold through Renewable Revolt.  Our customers receive valid licenses as part of their purchase.  If you are using this image independently, licensing compliance is your responsibility.

---

## How It's Built

We focus on dependencies and stability — the same way you'd approach a slimmed-down Linux distribution.  Remove what you don't need.  Don't break what you do.  Test it until you're sure it holds.

### Layer 1 — Clean ISO Source

Windows 11 Pro ISOs sourced directly from Microsoft via **[UUP Dump](https://uupdump.net)**.  
No third-party pre-built ISOs.  You can verify the source yourself — and you should.

**ISO build command (oscdimg):**
```
oscdimg -m -o -u2 -udfver102 -bootdata:2#p0,e,b[UUP_folder]\boot\etfsboot.com#pEF,e,b[UUP_folder]\efi\microsoft\boot\efisys.bin [UUP_folder] RR-Turbo-v6.iso
```
Flash with **Rufus** in GPT / UEFI mode.  Do not use MBR.  Do not use Balena Etcher.  
See [INSTALLATION.md](INSTALLATION.md) for the full flashing and activation workflow.

### Layer 2 — Base Reduction (Tiny11 Builder)

**[Tiny11 Builder](https://github.com/ntdevlabs/tiny11builder)** by NTDEV performs the initial image reduction via PowerShell script operating on the official Microsoft ISO.

Full credit to NTDEV — this project stands on that foundation.  Go support him: [Ko-fi](https://ko-fi.com/ntdev) · [Patreon](https://patreon.com/ntdev)

We use the **standard builder** — not Core.  The standard builder preserves Windows Update serviceability.  Tiny11 Core is described by its author as "not suitable for daily use."  We agree.

### Layer 3 — Permanent ISO-Level Customization (NTLite)

**[NTLite](https://www.nliteos.com)** makes removals permanent at the image level, configures services, applies Group Policy, and hardens the OS before installation ever occurs.

This layer is why v6 holds.  v1–v3 applied tweaks post-install — settings, services, Configuration Manager, Group Policy Editor.  Windows 24H2 and subsequent updates reversed most of them.  NTLite at the ISO level does not have this problem.

### Layer 4 — Post-Install Configuration

Applied on first boot:

- Windows Spotlight → off
- Transparency effects → off
- Widgets → off
- Suggested content and tips → off

---

## What's Removed

### Removed by Tiny11 Builder

- Microsoft Teams (consumer)
- OneDrive
- Microsoft Edge *(app removed — some Settings page remnants remain, cosmetic only)*
- Cortana
- Xbox apps and related services
- Clipchamp
- Mail and Calendar
- Maps
- Mixed Reality Portal
- Skype
- Solitaire Collection
- Sticky Notes
- Weather
- Phone Link
- News
- Tips
- Feedback Hub
- Get Help
- Power Automate
- To Do
- Camera
- Dev Home
- New Outlook client

### Removed by NTLite — ISO Level, Permanent

**Surveillance & AI**

- Microsoft Copilot — screen monitoring AI, runs at startup
- Windows Recall — screenshots your screen every few seconds and indexes content
- All telemetry modules — cannot be fully disabled through standard Settings; we remove the modules entirely

**Microsoft Ecosystem Lock-In**

- Microsoft Edge — complete removal including update services and Bing integration
- Microsoft Teams (additional complete pass)
- Start menu web search (Bing)
- Advertising ID services
- Windows Search indexing of personal content

**Background Data Collection**

- Diagnostic data collection services
- Connected User Experiences and Telemetry (DiagTrack)
- Data Collection and Publishing service
- Customer Experience Improvement Program (CEIP)
- Error Reporting services (Watson)
- Activity History and Timeline

**Noise**

- Xbox Game Bar background services
- Microsoft Store push notification services
- Suggested app install notifications
- Location tracking services *(see Known Issues — this has a side effect)*

### Services Disabled or Set to Manual

| Service | Reason |
|---|---|
| SysMain (Superfetch) | Reduces disk thrashing on SSD builds |
| Windows Error Reporting | Eliminates data transmission to Microsoft |
| Connected User Experiences and Telemetry | Core telemetry service |
| Diagnostic Policy Service | Feeds diagnostic data collection |
| Remote Registry | Attack surface reduction |
| Windows Insider Service | No insider builds on production hardware |
| Geolocation Service | Privacy — see Known Issues |
| Xbox services (×8) | Not needed on gaming-capable hardware with a real GPU |

### Group Policy Applied at ISO Level

- Telemetry locked to minimum (Security level)
- Automatic driver updates from Windows Update disabled *(prevents driver conflicts on refurbished hardware with specific GPU configurations)*
- Windows tips, tricks, and suggested content disabled
- Consumer experience features disabled
- Cortana disabled
- Bing search in Start disabled
- Windows Spotlight disabled
- Lock screen advertisements disabled
- Delivery Optimization restricted to LAN only — no uploading to Microsoft's CDN

---

## What's Included

| Software | Notes |
|---|---|
| **Office 2019 Pro Plus** | Pre-installed.  License required — see above.  Permanent, no subscription. |
| **DuckDuckGo Browser** | Default browser.  Privacy-first, no Google tracking. |
| **LibreWolf** | Firefox fork with telemetry removed, uBlock Origin pre-installed, privacy hardened.  Handles the small number of sites that need a full-featured browser engine. |
| **Fan Control v250** | Open source.  Pre-configured for Thermalright cooling hardware.  [GitHub](https://github.com/Rem0o/FanControl.Releases) |
| **OpenRGB** | Open source, vendor-neutral ARGB control.  Pre-configured for Nollie RGB controllers.  [openrgb.org](https://openrgb.org) |
| **uPDF** | Lightweight PDF viewer, configured as default.  No background services.  No Adobe.  For documents requiring Adobe features, right-click → Open With → Adobe (install separately as needed). |
| **DiskGenius (Free)** | Disk management and partition tool.  Developed by Eassos Ltd.  Legitimate, widely used.  Substitute your preferred tool. |

---

## A Note on Browser History

**v1–v3: Firefox**  
Firefox is a fine browser — not a serious privacy risk.  We found DuckDuckGo to be lighter and less resource-intensive as a primary browser.  Mozilla is a nonprofit, Firefox is open source, and it's one of the most audited browsers available.  The real concerns (telemetry on by default, Pocket integration, sponsored tiles) are real but configurable.

**v4–v5 initial: Opera Air**  
Opera has been owned by a Chinese investment consortium (Golden Brick Capital Private Equity) since 2016.  For a privacy-first image, that ownership is a structural problem you can't configure away.  We should have caught this sooner.  We didn't.  It's gone.

**v5–v6 current: DuckDuckGo + LibreWolf**  
DuckDuckGo handles 95% of use cases.  LibreWolf handles the rest.  Both are open source, both have clean ownership, and together they cover the full surface better than either browser alone.

---

## A Note on Signal RGB

Early builds included Signal RGB for ARGB control.  A community member correctly called it out.  Signal RGB is closed-source, requires a cloud account, and runs persistent background services — the opposite of everything this image is trying to be.  OpenRGB replaced it.  Open source, vendor-neutral, no account required, pre-configured before it ships.

OpenRGB is easy to use, but has a "Windows 95" feel and takes a few minutes to configure properly.  Best setup guide we've found is on the Nollie RGB website:  
<https://nolliergb.com/how-to-setup-openrgb-effects-engine-plugin/>

Being corrected publicly is how open source is supposed to work.  Credit to the person who spotted it.

---

## Known Issues

### Time Zone — Set Manually on First Boot

After installation, set your time zone once:  
**Settings → Time & Language → Date & Time → Time Zone**

After the first manual set, automatic updates work correctly.  This appears to be a side effect of location services being disabled at the ISO level.  We have not found a workaround that doesn't require re-enabling location tracking.  One manual set on first boot is the current solution.

**On the subject of default location:**  
The image ships with a default location set.  If you're in the Chicago area, you're already pointed at the right neighborhood.  If you're not, update it: **Settings → Privacy & Security → Location → Default Location → Set Default.**  We're in Chicagoland, so we use the address on Elwood Blues' driver's licence.

---

## For Refurbishers and Builders

This methodology is published so you can replicate it — not just use the output.

If you're rebuilding hardware for distribution and cloning this image using DiskGenius or similar:

> **Run DDU (Display Driver Uninstaller) in Safe Mode before cloning.**  
> GPU drivers baked into the image will cause problems on different GPU hardware.  
> A clean image has no GPU drivers.  Each machine installs its own on first boot.

Full build documentation:

- [INSTALLATION.md](INSTALLATION.md) — Flashing workflow, Rufus settings, activation steps
- [BUILD_WALKTHROUGH.md](BUILD_WALKTHROUGH.md) — Full ISO build methodology, NTLite configuration, Layer 3 settings
- [RELEASE_NOTES.md](RELEASE_NOTES.md) — Version history, what changed in each build

Platform-specific notes (X79, X99, Coffee Lake) are in progress.

---

## Roadmap

- Custom Android ROMs for tablets and phones *(hardware selection in progress)*
- Platform-specific optimization notes — X79 ECC, X99 quad-channel DDR4, Coffee Lake LGA 1151v2
- Automated benchmark tooling for measuring process count and available RAM headroom on new hardware
- Fan Control profiles for additional cooler hardware

---

## Credit Where It's Due

This image would not exist without:

| Project | Credit |
|---|---|
| **[Tiny11 Builder](https://github.com/ntdevlabs/tiny11builder)** — NTDEV | The foundation.  Support him: [Ko-fi](https://ko-fi.com/ntdev) / [Patreon](https://patreon.com/ntdev) |
| **[UUP Dump](https://uupdump.net)** | Clean, verifiable Microsoft ISOs |
| **[NTLite](https://www.nliteos.com)** | The tool that made permanence possible |
| **[OpenRGB](https://openrgb.org)** | Open source, vendor-neutral RGB.  The right way. |
| **[Fan Control](https://github.com/Rem0o/FanControl.Releases)** — Rem0o | Open source fan curve software that actually works |
| **[LibreWolf](https://librewolf.net)** | Firefox, fixed |
| **[Nollie RGB](https://nolliergb.com)** | RISC-V ARGB controllers.  The hardware OpenRGB talks to. |

---

## About Renewable Revolt

We recover enterprise hardware from e-waste streams and rebuild it into optimized, privacy-first computers for veterans, students, and underserved families.

Below $800, there are zero new gaming desktops with capable GPUs at any major US retailer.  
We fill that gap — starting at $399.

**[renewablerevolt.org](https://renewablerevolt.org)** · **[eBay Store](https://ebay.us/m/KgGZ0K)** — 100% positive feedback  
501(c)(3) · EIN: 99-2777606 · Hammond, Indiana · Veteran Owned & Operated

---

*Recover.  Revive.  Redeploy.*
