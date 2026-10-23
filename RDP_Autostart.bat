@echo off
setlocal
title RDP Resource Warning Fix

:: Path to the registry file. Change it if you keep rdp.reg somewhere else.
set "regFile=C:\scripts\rdp.reg"

echo ============================================================
echo   RDP Resource Warning Fix
echo ============================================================
echo.

if exist "%regFile%" (
    echo Applying registry fix: %regFile%

    :: regedit /s imports the file without a confirmation dialog
    regedit.exe /s "%regFile%"

    if errorlevel 1 (
        echo [!] The import failed.
        echo     Administrator rights are probably missing ^(needed for HKLM^).
    ) else (
        echo [OK] Registry file imported.
    )
) else (
    echo [ERROR] File not found: %regFile%
    echo Make sure the folder C:\scripts exists and contains rdp.reg.
)

echo.
echo ============================================================
echo   Done.
echo ============================================================
:: "exit" closes the window right away. Use "pause" instead while testing.
exit
