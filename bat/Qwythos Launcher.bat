@echo off
setlocal EnableDelayedExpansion

chcp 936 >nul
title LingDu AI - Qwythos Launcher
color 0A

cd /d "%~dp0"

:: =====================================================
:: 自动查找模型
:: =====================================================

set MODEL=
set MMPROJ=

for %%F in (models\Qwythos*.gguf) do (
    echo %%~nxF | find /I "mmproj" >nul
    if errorlevel 1 (
        set MODEL=%%F
    )
)

for %%F in (models\mmproj*.gguf) do (
    set MMPROJ=%%F
)

:MENU
cls

echo.
echo ============================================================
echo.
echo             LingDu AI - Qwythos Launcher
echo.
echo          Claude Mythos 5 Distilled Vision Model
echo.
echo ============================================================
echo.

if defined MODEL (
    echo Model Found:
    echo   !MODEL!
) else (
    echo Model Found:
    echo   NOT FOUND
)

echo.

if defined MMPROJ (
    echo Vision Projector:
    echo   !MMPROJ!
) else (
    echo Vision Projector:
    echo   NOT FOUND
)

echo.
echo ============================================================
echo.
echo Select Your GPU VRAM
echo.
echo [1] 4GB VRAM
echo     Recommended Context: 16K
echo.
echo [2] 6GB VRAM
echo     Recommended Context: 32K
echo.
echo [3] 8GB VRAM
echo     Recommended Context: 64K
echo.
echo [4] 12GB VRAM
echo     Recommended Context: 128K
echo.
echo [5] 16GB VRAM
echo     Recommended Context: 256K
echo.
echo [6] 24GB VRAM
echo     Recommended Context: 512K
echo.
echo ------------------------------------------------------------
echo.
echo OpenAI Compatible API
echo.
echo http://127.0.0.1:8080/v1
echo.
echo ------------------------------------------------------------
echo.
echo Supported Clients
echo.
echo OpenWebUI
echo Cherry Studio
echo Claude Code
echo OpenAI Codex
echo OpenClaw
echo.
echo ------------------------------------------------------------
echo.
echo [0] Exit
echo.
echo ============================================================

set /p choice=Select Option:

if "%choice%"=="1" (
    set CTX=16384
    set MODE=4GB
    goto START
)

if "%choice%"=="2" (
    set CTX=32768
    set MODE=6GB
    goto START
)

if "%choice%"=="3" (
    set CTX=65536
    set MODE=8GB
    goto START
)

if "%choice%"=="4" (
    set CTX=131072
    set MODE=12GB
    goto START
)

if "%choice%"=="5" (
    set CTX=262144
    set MODE=16GB
    goto START
)

if "%choice%"=="6" (
    set CTX=524288
    set MODE=24GB
    goto START
)

if "%choice%"=="0" exit

goto MENU

:START
cls

echo.
echo ============================================================
echo.
echo Starting Qwythos...
echo.
echo Mode:
echo   %MODE%
echo.
echo Context:
echo   %CTX%
echo.
echo Model:
echo   !MODEL!
echo.
echo Vision:
echo   !MMPROJ!
echo.
echo API:
echo   http://127.0.0.1:8080/v1
echo.
echo ============================================================
echo.

if not defined MODEL (
    echo ERROR:
    echo No Qwythos model found in models folder.
    echo.
    pause
    goto MENU
)

if not defined MMPROJ (
    echo WARNING:
    echo No mmproj found.
    echo Starting as text-only model.
    echo.

    llama-server.exe ^
    -m "!MODEL!" ^
    -ngl 999 ^
    -c %CTX% ^
    -n 8192 ^
    -fa on ^
    --cont-batching ^
    --host 127.0.0.1 ^
    --port 8080

    pause
    goto MENU
)

llama-server.exe ^
-m "!MODEL!" ^
--mmproj "!MMPROJ!" ^
-ngl 999 ^
-c %CTX% ^
-n 8192 ^
-fa on ^
--cont-batching ^
--host 127.0.0.1 ^
--port 8080

pause
goto MENU