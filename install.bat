@echo off
echo ========================================
echo ServePass Installation Script
echo ========================================
echo.

echo Checking FiveM server structure...
if not exist "server.cfg" (
    echo ERROR: server.cfg not found!
    echo Please run this script from your FiveM server root directory.
    pause
    exit /b 1
)

echo.
echo Creating resources directory if it doesn't exist...
if not exist "resources" mkdir resources
if not exist "resources\[local]" mkdir "resources\[local]"

echo.
echo Copying ServePass files...
if not exist "resources\[local]\serve-pass" mkdir "resources\[local]\serve-pass"

echo Copying configuration files...
copy "config.lua" "resources\[local]\serve-pass\" >nul
copy "fxmanifest.lua" "resources\[local]\serve-pass\" >nul
copy "server.lua" "resources\[local]\serve-pass\" >nul
copy "client.lua" "resources\[local]\serve-pass\" >nul
copy "connection_client.lua" "resources\[local]\serve-pass\" >nul
copy "README.md" "resources\[local]\serve-pass\" >nul

echo Copying server modules...
if not exist "resources\[local]\serve-pass\server" mkdir "resources\[local]\serve-pass\server"
copy "server\*.lua" "resources\[local]\serve-pass\server\" >nul

echo Copying HTML/CSS/JS files...
if not exist "resources\[local]\serve-pass\html" mkdir "resources\[local]\serve-pass\html"
copy "html\*.html" "resources\[local]\serve-pass\html\" >nul
copy "html\*.css" "resources\[local]\serve-pass\html\" >nul
copy "html\*.js" "resources\[local]\serve-pass\html\" >nul

echo.
echo Checking server.cfg for ServePass entry...
findstr /i "serve-pass" server.cfg >nul
if %errorlevel% equ 0 (
    echo ServePass already exists in server.cfg
) else (
    echo Adding ServePass to server.cfg...
    echo. >> server.cfg
    echo # ServePass - Server Password Protection >> server.cfg
    echo ensure serve-pass >> server.cfg
    echo ServePass added to server.cfg
)

echo.
echo ========================================
echo Installation Complete!
echo ========================================
echo.
echo IMPORTANT: Please edit the following files:
echo 1. resources\[local]\serve-pass\config.lua - Set your password and preferences
echo 2. server.cfg - Make sure 'ensure serve-pass' is at the top of your resource list
echo.
echo Default password is: kosnnt
echo Change it in config.lua before starting your server!
echo.
echo To start using ServePass:
echo 1. Edit config.lua with your settings
echo 2. Restart your FiveM server
echo 3. Use console commands: servepass:status, servepass:kickunauthenticated
echo.
pause