# 🚀 RDP-Resource-Warning-Fix

A minimalist solution to fix the persistent Windows security prompts during Remote Desktop (RDP) connections (e.g., access prompts for clipboard, cameras, or drives) that frequently reappear after Windows Updates.

## ❓ The Problem
Recent Windows Updates enforce a strict "consent dialog" for unsigned RDP connections. Even if users check "Don't ask me again," the decision is often ignored or wiped out by subsequent system updates.

## ✨ The Solution
This script automates the application of the `RedirectionWarningDialogVersion` registry policy. Placing the script inside the Windows Startup folder ensures that the fix automatically reapplies itself, even if a Windows Update resets the registry path.

## 🛠️ Setup Guide

1. **Create the Folder:** Create the path `C:\scripts\` on your PC.
2. **Copy the Files:** * Place the `rdp.reg` file inside `C:\scripts\`.
   * Download the `RDP_Autostart.bat` script.
3. **Configure Startup:**
   * Press `Win + R`, type `shell:startup`, and hit Enter.
   * Move the `RDP_Autostart.bat` file into this folder.
