@echo off
REM ============================================================
REM  RENEWABLE REVOLT AI  -  12 GB build (full)
REM  Text & vision -> llama-server built-in UI  (port 8080)
REM  Images        -> sd-server built-in UI     (port 7860)
REM  No Open WebUI, no Python.  Only one mode runs at a time.
REM ============================================================
title Renewable Revolt AI
cd /d "%~dp0"

set "LLAMA=C:\Users\Public\RenewableRevolt\llama\llama-server.exe"
set "M=C:\Users\Public\RenewableRevolt\models"
set "LWEBUI=C:\Users\Public\RenewableRevolt\llama\webui"
set "SDBIN=C:\Users\Public\RenewableRevolt\sd\bin\sd-server.exe"
set "SDM=C:\Users\Public\RenewableRevolt\sd\models"
set "ZVAE=%SDM%\zimage\ae_bf16.safetensors"
set "ZLLM=%SDM%\zimage\qwen_3_4b-Q8_0.gguf"
set "RRUI=C:\Users\Public\RenewableRevolt\sd\rr-image-ui.html"

:menu
cls
echo ===========================================================
echo    RENEWABLE REVOLT AI       (pick one; close its window
echo                                to stop before switching)
echo -----------------------------------------------------------
echo    TEXT and VISION   (opens 127.0.0.1:8080)
echo      [1] Quick              - Bonsai 8B  (lightest, fastest)
echo      [2] Assistant + Vision - Bonsai 2 27B  (reads images)
echo      [3] Coding             - Qwen2.5-Coder 14B
echo.
echo    IMAGES            (opens Image Studio menu)
echo      [4] Image Studio       - make images
echo ===========================================================
echo.
choice /c 1234 /n /m "Press 1-4: "
if errorlevel 4 goto imagemenu
if errorlevel 3 goto coder14
if errorlevel 2 goto assistant
if errorlevel 1 goto quick

:quick
start /min "RR-Engine" "%LLAMA%" -m "%M%\Bonsai-8B-Q1_0.gguf" --path "%LWEBUI%" --host 127.0.0.1 --port 8080 -ngl 99
goto open8080
:coder14
start /min "RR-Engine" "%LLAMA%" -m "%M%\qwen2.5-coder-14b-instruct-q4_k_m.gguf" --path "%LWEBUI%" --host 127.0.0.1 --port 8080 -ngl 99
goto open8080
:assistant
start /min "RR-Engine" "%LLAMA%" -m "%M%\Ternary-Bonsai-2-27B-PTQ1_0.gguf" --mmproj "%M%\Ternary-Bonsai-2-27B-mmproj-Q8_0.gguf" --path "%LWEBUI%" --host 127.0.0.1 --port 8080 -ngl 99 -fa on -c 16384 --no-mmproj-offload --jinja --temp 1.0 --top-p 0.95 --top-k 20 --min-p 0.05 --image-max-tokens 1024
goto open8080

:open8080
echo.
echo  Starting, please wait...
set /a tries=0
:w8
set /a tries+=1
curl.exe -s -o nul http://127.0.0.1:8080
if not errorlevel 1 goto r8
if %tries% geq 60 goto r8
timeout /t 1 /nobreak >nul
goto w8
:r8
where librewolf.exe >nul 2>nul
if %errorlevel%==0 (
    start "" librewolf.exe "http://127.0.0.1:8080"
) else (
    start "" "http://127.0.0.1:8080"
)
exit

REM ====================  IMAGE STUDIO  ====================
:imagemenu
cls
echo ===========================================================
echo    RENEWABLE REVOLT AI  -  IMAGE STUDIO   (opens 127.0.0.1:7860)
echo    Pick an image model.  (The page sets the right options.)
echo.
echo    SD 1.5   (fast):
echo      [1] DreamShaper 8      versatile all-rounder
echo      [2] Realistic Vision   photoreal
echo    SDXL     (high detail):
echo      [3] SDXL base          balanced, all-purpose
echo      [4] Juggernaut XL      photoreal
echo    Z-Image Turbo  (premium):
echo      [5] Z-Image            best quality, slower
echo.
echo      [0] Back
echo ===========================================================
echo.
choice /c 123450 /n /m "Press 0-5: "
if errorlevel 6 goto menu
if errorlevel 5 goto zq51
if errorlevel 4 goto jugg
if errorlevel 3 goto sdxl
if errorlevel 2 goto realvis
if errorlevel 1 goto ds8

:ds8
start /min "RR-ImageEngine" "%SDBIN%" -m "%SDM%\sd15\DreamShaper_8_pruned.safetensors" --diffusion-fa --serve-html-path "%RRUI%" --listen-ip 127.0.0.1 --listen-port 7860
goto open7860
:realvis
start /min "RR-ImageEngine" "%SDBIN%" -m "%SDM%\sd15\Realistic_Vision_V6.0_NV_B1.safetensors" --vae "%SDM%\sd15\vae-ft-mse-840000-ema-pruned.safetensors" --diffusion-fa --serve-html-path "%RRUI%" --listen-ip 127.0.0.1 --listen-port 7860
goto open7860
:sdxl
start /min "RR-ImageEngine" "%SDBIN%" -m "%SDM%\sdxl\sd_xl_base_1.0.safetensors" --vae "%SDM%\sdxl\sdxl_vae.safetensors" --offload-to-cpu --diffusion-fa --serve-html-path "%RRUI%" --listen-ip 127.0.0.1 --listen-port 7860
goto open7860
:jugg
start /min "RR-ImageEngine" "%SDBIN%" -m "%SDM%\sdxl\Juggernaut-XL_v9_RunDiffusionPhoto_v2.safetensors" --vae "%SDM%\sdxl\sdxl_vae.safetensors" --offload-to-cpu --diffusion-fa --serve-html-path "%RRUI%" --listen-ip 127.0.0.1 --listen-port 7860
goto open7860
:zq51
start /min "RR-ImageEngine" "%SDBIN%" --diffusion-model "%SDM%\zimage\z_image_turbo-Q5_1.gguf" --vae "%ZVAE%" --llm "%ZLLM%" --offload-to-cpu --diffusion-fa --serve-html-path "%RRUI%" --listen-ip 127.0.0.1 --listen-port 7860
goto open7860

:open7860
echo.
echo  Loading the image model, please wait (first run is slower)...
set /a tries=0
:wi
set /a tries+=1
curl.exe -s -o nul http://127.0.0.1:7860
if not errorlevel 1 goto ri
if %tries% geq 90 goto ri
timeout /t 2 /nobreak >nul
goto wi
:ri
where librewolf.exe >nul 2>nul
if %errorlevel%==0 (
    start "" librewolf.exe "http://127.0.0.1:7860"
) else (
    start "" "http://127.0.0.1:7860"
)
exit
