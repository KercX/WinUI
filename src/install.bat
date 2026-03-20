@echo off
setlocal enabledelayedexpansion
title WinUI Developer Framework Console
color 0b

:menu
cls
echo ======================================================
echo             WINUI FRAMEWORK DEVELOPER TOOLS
echo ======================================================
echo  Current Version: 1.5.0
echo  Status: Professional Environment
echo ======================================================
echo.
echo  [1] Initialize Project Structure (Create Folders)
echo  [2] Start Rojo Sync (VS Code to Studio)
echo  [3] Generate Documentation (API.md from JSON)
echo  [4] Clean Build Directory (Clear /dist)
echo  [5] Exit
echo.
echo ======================================================
set /p choice="Select an option (1-5): "

if "%choice%"=="1" goto :init
if "%choice%"=="2" goto :rojo
if "%choice%"=="3" goto :docs
if "%choice%"=="4" goto :clean
if "%choice%"=="5" exit

:init
echo.
echo [!] Initializing WinUI structure...
mkdir src docs dist assets .github\workflows 2>nul
echo -- WinUI Main > src\main.luau
echo -- WinUI Legacy > src\main.lua
echo { "version": "1.5.0" } > config.json
echo [SUCCESS] Folders and base files created.
pause
goto :menu

:rojo
echo.
echo [!] Starting Rojo Serve...
rojo serve
if %errorlevel% neq 0 (
    echo [ERROR] Rojo not found! Please install Rojo CLI.
)
pause
goto :menu

:docs
echo.
echo [!] Generating API documentation...
rem This is a placeholder for a documentation generator script
echo # WinUI API Documentation > docs\API.md
echo Generated on %date% %time% >> docs\API.md
echo [SUCCESS] API.md has been updated in /docs.
pause
goto :menu

:clean
echo.
echo [!] Cleaning /dist folder...
del /q dist\*
echo [SUCCESS] Build directory is clean.
pause
goto :menu
