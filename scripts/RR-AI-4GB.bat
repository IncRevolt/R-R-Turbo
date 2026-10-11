@echo off
REM ============================================================
REM  RENEWABLE REVOLT AI  -  4 GB build
REM  Only the models a 4 GB card can run:
REM    Text  : Quick (Bonsai 8B)
REM    Image : SD 1.5 (DreamShaper 8)
REM  No Open WebUI, no Python.  One mode at a time.
REM ============================================================
title Renewable Revolt AI
cd /d "%~dp0"

set "LLAMA=C:\Users\Public\RenewableRevolt\llama\llama-server.exe"
set "M=C:\Users\Public\RenewableRevolt\models"
set "LWEBUI=C:\Users\Public\RenewableRevolt\llama\webui"
set "SDBIN=C:\Users\Public\RenewableRevolt\sd\bin\sd-server.exe"
set "SDM=C:\Users\Public\RenewableRevolt\sd\models"
set "RRUI=C:\Users\Public\RenewableRevolt\sd\rr-image-ui.html"

:menu
cls
echo ===========================================================
echo    RENEWABLE REVOLT AI  (4 GB)      (pick one; close its
echo                                      window before switching)
echo -----------------------------------------------------------
echo    TEXT      (opens 127.0.0.1:8080)
echo      [1] Quick          - Bonsai 8B
echo.
echo    IMAGES    (opens Image Studio menu)
echo      [2] Image Studio   - make images
echo ===========================================================
echo.
choice /c 12 /n /m "Press 1-2: "
if errorlevel 2 goto imagemenu
if errorlevel 1 goto quick

:quick
start /min "RR-Engine" "%LLAMA%" -m "%M%\Bonsai-8B-Q1_0.gguf" --path "%LWEBUI%" --host 127.0.0.1 --port 8080 -ngl 99
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
echo.
echo      [0] Back
echo ===========================================================
echo.
choice /c 10 /n /m "Press 0-1: "
if errorlevel 2 goto menu
if errorlevel 1 goto ds8

:ds8
start /min "RR-ImageEngine" "%SDBIN%" -m "%SDM%\sd15\DreamShaper_8_pruned.safetensors" --diffusion-fa --serve-html-path "%RRUI%" --listen-ip 127.0.0.1 --listen-port 7860
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
