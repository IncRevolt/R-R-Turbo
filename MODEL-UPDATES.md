# RR-Turbo AI — Updating and Adding Models

## How it works (the 30-second version)

Renewable Revolt AI is two small engines plus a set of model files:

* **Text and vision** run on **llama.cpp** — those models are **`.gguf`** files.
* **Images** run on **stable-diffusion.cpp** — those models are **`.safetensors`** files (Z-Image also uses `.gguf`).

A model is just a file in a folder.  The launcher opens a specific filename, so to update a model you either **keep the same filename** (easiest — drop-in replace) or edit the launcher to point at the new name.

## Where files go

```
C:\Users\Public\RenewableRevolt\
  models\                                  TEXT & VISION  (.gguf)
    Bonsai-8B-Q1_0.gguf
    Ternary-Bonsai-2-27B-PTQ1_0.gguf
    Ternary-Bonsai-2-27B-mmproj-Q8_0.gguf  <- vision needs this companion file
    qwen2.5-coder-7b-instruct-q4_k_m.gguf
    qwen2.5-coder-14b-instruct-q4_k_m.gguf
  sd\models\
    sd15\                                  SD 1.5 images
      DreamShaper_8_pruned.safetensors
      Realistic_Vision_V6.0_NV_B1.safetensors
      vae-ft-mse-840000-ema-pruned.safetensors   <- Realistic Vision needs this
    sdxl\                                  SDXL images
      sd_xl_base_1.0.safetensors
      Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors
      sdxl_vae.safetensors                 <- both SDXL models need this
    zimage\                                Z-Image (three files, all required)
      z_image_turbo-Q5_1.gguf
      ae_bf16.safetensors
      qwen_3_4b-Q8_0.gguf
```

## Finding updates (search Hugging Face)

Go to **huggingface.co**, search, and open the repo's **Files** tab.  Match the file type to the folder it goes in.

| Model | Search | Download |
| --- | --- | --- |
| Bonsai 8B (text) | `Bonsai 8B GGUF` | the `.gguf` |
| Bonsai 2 27B (vision) | `Ternary Bonsai 27B GGUF` | the model `.gguf` **and** its `mmproj` `.gguf` |
| Qwen Coder | `Qwen2.5 Coder GGUF` | the `q4_k_m.gguf` |
| DreamShaper 8 | `DreamShaper 8 safetensors` | the `.safetensors` |
| Realistic Vision | `Realistic Vision V6 safetensors` | the `.safetensors` (keep the SD 1.5 VAE) |
| SDXL base | `SDXL base 1.0 safetensors` | the `.safetensors` |
| Juggernaut XL | `Juggernaut XL safetensors` | the `.safetensors` |
| Z-Image Turbo | `Z-Image Turbo GGUF sdcpp` | all three files from the **wbruna** repo |

## Two rules

1. **Text models must be GGUF; image models are safetensors** (except Z-Image, which is GGUF).  Don't put an image model in the text folder or vice versa.
2. **Keep the filename, or edit the launcher.**  If the new file has a different name, either rename it to exactly what it's replacing, or open the `.bat`, find that model's line, and change the filename there.

## About the "Q" in a filename

`Q8`, `Q5`, `Q4`, `Q1` is the quantization — how compressed the model is.  Higher number = better quality and more VRAM used.  If a model runs out of memory, choose a lower quant; if your card has headroom, go higher.
