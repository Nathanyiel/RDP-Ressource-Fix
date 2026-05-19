@echo off
setlocal
title RDP Autostart Fix - Testversion

:: 1. Pfad zur Registry-Datei festlegen (Hardcoded)
set "regFile=C:\scripts\rdp.reg"

echo ============================================================
echo   RDP AUTOSTART FIX (Manueller Pfad)
echo ============================================================
echo.

:: 2. Überprüfen, ob die Datei existiert
if exist "%regFile%" (
    echo Fuehre Registry-Fix aus: %regFile%
    
    :: regedit /s führt die Datei ohne Bestätigungsdialog aus
    regedit.exe /s "%regFile%"
    
    if %errorlevel% equ 0 (
        echo [OK] Registry-Befehl wurde gesendet.
    ) else (
        echo [!] Hinweis: Fehler beim Importieren. 
        echo     (Wahrscheinlich fehlen Admin-Rechte fuer HKLM)
    )
) else (
    echo [FEHLER] Datei nicht gefunden unter: %regFile%
    echo Bitte stelle sicher, dass der Ordner C:\scripts existiert.
)

echo.
echo ============================================================
echo   Vorgang beendet.
echo ============================================================
:: exit schliesst das Fenster sofort. 
:: Zum Testen kannst du 'pause' statt 'exit' nutzen.
exit