R-R-Turbo
Debloated Windows 11 Pro with private, local AI — text, vision, and image generation that run entirely on your own graphics card.
Win 11 Pro [RR Turbo]
A Privacy-First Windows 11 Pro Image by Renewable Revolt, Incorporated
Version: v7.5 (Full) · v7.6 (Lite)  
Base: Windows 11 Pro 25H2, build 26200.9550 — security and feature updates through October 2026  
Built with: UUP Dump · Tiny11 Builder (NTDEV) · NTLite · llama.cpp · stable-diffusion.cpp  
Status: Stable — in production since June 2025  
License: MIT (methodology and scripts)
---
> *"Reports of this hardware's death were greatly exaggerated."*  
> Renewable Revolt, Inc. · Hammond, Indiana · 501(c)(3) · EIN: 99-2777606  
> [renewablerevolt.org](https://renewablerevolt.org) · Veteran Owned & Operated
---
What This Is
RR Turbo is a custom Windows 11 Pro image for refurbished and legacy hardware.  It ships on every machine we build, and we publish it so anyone else can use it.
The goal is simple: a Windows installation that works for the person in front of it, not for Microsoft's data-collection pipeline, advertising network, or upsell funnel.  Everything removed is removed at the image level — before the OS ever touches the drive — so Windows updates don't bring it back.
v7 added private AI.  We removed Microsoft's Copilot and Recall because they watch what you do and send it to the cloud.  In their place: open-source AI models that run entirely on your own graphics card — no account, no subscription, no internet connection, and nothing leaves the machine.
---
Three Downloads — Small, Medium, Large
The local AI runs in your graphics card's video memory (VRAM), so the right download depends on your GPU.  Pick one:
Download	Size class	For a GPU with	Local AI	Download
v7.7 — Core	Small	any (incl. laptop / iGPU)	none — the clean, turn-key build	~12 GB (est.)
v7.6 — Lite	Medium	4 GB VRAM	Bonsai 8B · DreamShaper 8	~16 GB
v7.5 — Full	Large	12 GB VRAM	Bonsai 8B, Bonsai 2 27B (+vision), Qwen2.5-Coder 14B · DreamShaper 8, Realistic Vision, SDXL base, Juggernaut XL, Z-Image Turbo	~60 GB
Not sure?  No discrete graphics card, or a laptop → Core.  A 4 GB card → Lite.  A 12 GB card → Full.  Running an 8 GB card?  Download Full and follow BUILD-8GB.md to trim it.
v7.7 Core is the leanest: debloated Windows, Office, and LibreWolf with no AI stack and none of the desktop-only tooling (no Fan Control, OpenRGB, or bundled PDF app).  It's the right pick for older laptops and low-spec machines, and the only edition that needs no post-install driver step to be fully usable.
Lite and Full add the private local AI — same Windows base, different model sets.  Upgrading a machine from Lite to Full is a GPU swap, then re-add the bigger models.
The debloated Windows, Office, and LibreWolf are identical across all three.
---
The Local AI
In Lite and Full only.  Core (v7.7) ships without the AI stack — skip this section for that edition.
	
Text / vision engine	llama.cpp (Vulkan) on `127.0.0.1:8080`
Image engine	stable-diffusion.cpp (Vulkan) on `127.0.0.1:7860`
Interface	A dark, Renewable-Revolt chat page and image studio, served by the engines in your browser
Privacy	Web search and browsing tools are off.  Both engines bind to `127.0.0.1` only — nothing is exposed to the network.  Chat history is stored in your browser, on your PC.
Launch	Double-click the launcher for your card (`RR-AI-4GB` / `-8GB` / `-12GB`), pick a model from the menu, and the browser opens when the engine is ready.
What it's good for: writing and editing, summarizing, explaining, brainstorming, reading images (vision), coding, and generating images from a text prompt.
What it isn't: a news source.  Local models don't know recent events.  For current events, use a web search.
No Python, no accounts, no cloud.  The whole stack is two small native Windows programs plus static HTML.  One engine runs at a time; close its window before switching modes.
---
Performance
Measured at idle on two very different machines (v6 baseline; the AI runs only when you launch it, so idle is unchanged):
25–38% fewer background processes
24–47% less RAM in use
CPU and disk activity at idle drop to near zero
	Lenovo IdeaPad 1 14ADA05	HP Laptop 17-by0xxx
CPU	AMD Athlon Silver 3050e (2C/4T)	Intel Core i3-8130U (2C/4T)
RAM	4 GB DDR4-2400	32 GB DDR4-2400
Background processes	53 → 40 (−25%)	73 → 45 (−38%)
Memory in use	68% → 52% (−24%)	19% → 10% (−47%)
Results may vary by hardware configuration (YMMV).
---
Install (overview)
You need 7-Zip, wimlib (the small tool that writes the image — see below), a Windows 10/11 PC, and a USB-to-SATA or USB-to-NVMe adapter for the target SSD.  There is no bootable USB and no Windows installer — the image is written straight to the SSD.
Download all parts of your chosen edition into one folder.
Right-click the `.001` file → 7-Zip → Extract.  Password: Revolt
Connect the target SSD and run `Install-RRTurbo-wimlib.ps1` in PowerShell as administrator.  Pick the SSD, type ERASE.  (ACL warnings during the apply are normal — see below.)
Install the SSD in the target PC (BIOS: UEFI, AHCI) and turn it on.
It boots straight to the desktop.  Add your license keys, install your GPU driver, and launch the AI.
> **Why wimlib, and why no plain installer?**  These images are heavily debloated, and a few leftover packaged-app files carry security labels that stock Windows tools (DISM, Windows Setup) refuse to apply — they fail with `0x80070513`.  `wimlib-imagex` applies the image anyway, warning on those few files and continuing.  So the deploy is open and fully documented, but it's a deliberate, hands-on process — not a double-click installer.
Full step-by-step, BIOS settings, first-boot checklist, and AI launch: INSTALLATION.md.
Minimum specs: 2-core/4-thread CPU, UEFI firmware, 256 GB SSD.  For local AI: 16 GB system RAM and a GPU with 4 GB+ of VRAM (tested on AMD Radeon).
---
What's Removed (Permanent at Image Level)
Surveillance & cloud AI: Microsoft Copilot, Windows Recall, all telemetry modules.  
Lock-in: Microsoft Edge (incl. update services), Consumer Teams, OneDrive, Cortana, Xbox/Game Bar, Start-menu web search, advertising ID.  
Background data collection: DiagTrack, Data Collection and Publishing, CEIP, Watson error reporting, Activity History.  
Apps: Clipchamp, Mail/Calendar, Maps, Weather, News, Tips, Feedback Hub, and most preinstalled consumer apps.
Telemetry is locked to Security level, Delivery Optimization is limited to the local network, and location/advertising/indexing services are removed.
---
What's Included
Software	Notes
Office 2019 Pro Plus	Pre-installed, unactivated.  Bring your own key.  Permanent, no subscription.
LibreWolf	Default browser.  Firefox fork, telemetry removed, uBlock Origin pre-installed.
Renewable Revolt AI	llama.cpp + stable-diffusion.cpp + models, configured and ready.  See above.
Fan Control v226	Open source, pre-configured for Thermalright coolers.
OpenRGB	Open source, vendor-neutral ARGB control.
uPDF	Lightweight PDF reader, default.  No background services.
Graphics driver tools in the Downloads folder: NVCleanstall (NVIDIA), Radeon Software Slimmer (AMD).  The image ships with no vendor GPU driver — install yours after first boot; the AI needs it.
Optional installers in Downloads (not pre-installed): DuckDuckGo Browser, DiskGenius Free.
---
Licensing
No Windows license is included — bring your own Windows 11 Pro key.
Office 2019 Pro Plus is pre-installed but unactivated — bring your own key.
AI models are covered by their own licenses, included under `C:\Users\Public\RenewableRevolt\...\licenses\`.  Several use OpenRAIL-style terms; review them before redistributing.
Renewable Revolt ships licensed machines.  Independent users are responsible for their own compliance.
This repository (methodology, scripts, docs) is MIT.  The Windows image is a modified Microsoft product; no Microsoft trademarks or copyrighted material beyond fair use for modification is claimed.
---
Known Issues
Same computer name on every install.  Rename the PC after first boot (Settings → System → About → Rename this PC).  The shared internal security ID doesn't matter for home or small-office PCs that aren't joined to a company domain.
Won't start / `INACCESSIBLE_BOOT_DEVICE` — turn off Intel VMD/RST and set storage to AHCI in the BIOS (common on Intel 11th-gen and newer laptops).
Group Policy Editor warning — opening `gpedit.msc` shows a "resource file could not be found" message.  Harmless; we removed the policy templates for features that no longer exist.  Click OK.
Time zone — set it once on first boot (location services are off by design).
---
Updating and Adding Models
See MODEL-UPDATES.md — how the backend works in 30 seconds, where each model file goes, Hugging Face search terms, and the two rules for drop-in replacement.
---
For Refurbishers and Builders
The methodology is published so you can replicate it.  Build, cleanup, capture, and test are in the internal build runbook; the field guides are BUILD-8GB.md (make an 8 GB edition from Full), BUILD-77.md (make the no-AI Core edition), and MODEL-UPDATES.md.
> **Run DDU in Safe Mode before cloning.**  A clean image has no vendor GPU driver; each machine installs its own on first boot.
---
Version History
Windows base by release: v1–v5 spanned 21H2 → 24H2, v6 was 24H2, v7 is 25H2.
v1–v3 (21H2 / 22H2 era): Post-install tweaks (reversed by Windows updates — lessons learned)
v4: First NTLite image-level pass
v5 (through 24H2): Stable — shipped on all production builds since June 2025
v6 (24H2): LibreWolf, Renewable Revolt theme, performance verified, debloat-only (archived docs)
v7.5 (Full) (25H2, build 26200.9550): Current — private local AI (llama.cpp + stable-diffusion.cpp; text, vision, and image generation), all updates through October 2026, direct-to-SSD install
v7.6 (Lite) (25H2, build 26200.9550): Current — the 4 GB edition: Bonsai 8B + DreamShaper 8, same everything else
v7.7 (Core) (25H2, build 26200.9550): Current — the no-AI, legacy/laptop edition: debloated Windows + Office + LibreWolf, stripped of the AI stack and desktop-only tooling; the turn-key build (build guide)
---
Credits
Project	For
Tiny11 Builder — NTDEV	The debloat foundation.  Support him: Ko-fi / Patreon
UUP Dump	Clean, verifiable Microsoft ISOs
NTLite	Permanent image-level customization
llama.cpp — ggml-org	The text/vision engine
stable-diffusion.cpp — leejet	The image engine
Hugging Face	Where the open models live
PrismML · Qwen (Alibaba) · Lykon · SG161222 · Stability AI · RunDiffusion	The AI models
OpenRGB · Fan Control (Rem0o) · LibreWolf · Nollie RGB	Bundled open-source tools
NVCleanstall (TechPowerUp) · Radeon Software Slimmer	Clean GPU driver installs
---
About Renewable Revolt
We recover enterprise hardware from e-waste streams and rebuild it into optimized, privacy-first computers for veterans, students, and underserved families.
Below $800, there are zero new gaming desktops with capable GPUs at any major US retailer.  We fill that gap — starting at $349.
renewablerevolt.org · eBay Store — 100% positive feedback  
501(c)(3) · EIN: 99-2777606 · Hammond, Indiana · Veteran Owned & Operated
---
Recover. Revive. Redeploy.
