# RR-Turbo AI — Building an 8 GB Edition

The public **12 GB (full)** image contains every model.  To make an **8 GB edition** for a card with 8 GB of video memory, delete the two items the 8 GB tier can't run and ship the 8 GB launcher.  Nothing else changes.

## 1. Delete these

| Delete | From | Why |
| --- | --- | --- |
| `qwen2.5-coder-14b-instruct-q4_k_m.gguf` | `C:\Users\Public\RenewableRevolt\models\` | The 8 GB build uses the 7 B coder instead. |
| the entire `zimage\` folder | `C:\Users\Public\RenewableRevolt\sd\models\` | Z-Image Turbo needs a ~12 GB card. |

That frees about **17 GB**.

## 2. Swap the launcher

On the Public desktop (`C:\Users\Public\Desktop`), keep **`RR-AI-8GB.bat`** and delete **`RR-AI-4GB.bat`** and **`RR-AI-12GB.bat`**.

## 3. What the 8 GB edition keeps

* **Text / vision:** Bonsai 8B, Bonsai 2 27B (+ vision), Qwen2.5-Coder 7B
* **Images:** DreamShaper 8, Realistic Vision (+ its VAE), SDXL base (+ its VAE), Juggernaut XL

That is the full 8 GB menu.  Do **not** delete the `mmproj` file (the vision model needs it) or the `vae` files (Realistic Vision and both SDXL models need them).

## Why tiers exist

The models run on the graphics card's video memory (VRAM), not the system RAM.  A model that doesn't fit the card either won't load or crawls.  The three editions are the same Windows image with different model sets — upgrading a machine is a GPU swap, then re-add the bigger models and swap the launcher.
