# RDP Resource Warning Fix

Stops the Remote Desktop warning about access to local resources (clipboard, drives, cameras) that keeps coming back after Windows updates.

[![License: MIT](https://img.shields.io/badge/license-MIT-2f7f5f.svg)](LICENSE)
![Windows 10 and 11](https://img.shields.io/badge/Windows-10%20%7C%2011-1d6ba3.svg)
![Registry fix](https://img.shields.io/badge/type-registry%20fix-b05e14.svg)

> [!WARNING]
> This setting brings back the older, milder RDP dialog. Microsoft added the stricter warning to protect against malicious `.rdp` files, so only use this fix for connections to computers you know and trust. Microsoft has said the setting may be removed in a future update, and then the fix stops working.

## The problem

Since the April 2026 Windows updates, opening a Remote Desktop connection from an unsigned `.rdp` file shows a strict consent dialog. Ticking "Don't ask me again" often does not stick, and later updates can reset it.

## The fix

One registry value restores the older dialog behavior:

| | |
| --- | --- |
| **Key** | `HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client` |
| **Value** | `RedirectionWarningDialogVersion` |
| **Type** | `REG_DWORD` |
| **Data** | `1` |

You can set it once by hand, or let a small startup script set it again at every sign-in, so it also survives updates that reset it.

## Quick start

Writing to `HKLM` needs administrator rights.

### Option A: one command

Open **Windows Terminal (Admin)** or **Command Prompt (Admin)** and run:

```bat
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" /v RedirectionWarningDialogVersion /t REG_DWORD /d 1 /f
```

### Option B: reapply it at every sign-in

1. Click **Code → Download ZIP** at the top of this page and extract it.
2. Open **PowerShell** in the extracted folder and run:

   ```powershell
   New-Item -ItemType Directory -Force C:\scripts | Out-Null
   Copy-Item .\rdp.reg C:\scripts\
   Copy-Item .\RDP_Autostart.bat "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\"
   ```

3. Sign out and back in. The script imports `rdp.reg` automatically. Because the setting lives in `HKLM`, Windows may ask you to confirm administrator rights at each sign-in.

Prefer to do it by hand? Put `rdp.reg` into `C:\scripts\`, press `Win + R`, type `shell:startup` and move `RDP_Autostart.bat` into that folder.

## Check that it worked

```bat
reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" /v RedirectionWarningDialogVersion
```

The output should end with `REG_DWORD    0x1`.

## Undo

Remove the value and the startup script:

```bat
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services\Client" /v RedirectionWarningDialogVersion /f
```

```powershell
Remove-Item "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\RDP_Autostart.bat"
```

## How it works

```mermaid
flowchart LR
    A["Sign in to Windows"] --> B["RDP_Autostart.bat"]
    B --> C["regedit imports<br>C:\scripts\rdp.reg"]
    C --> D["RedirectionWarningDialogVersion = 1"]
    D --> E["Older RDP dialog"]
```

## What is in this repository

| File | Purpose |
| --- | --- |
| [`rdp.reg`](rdp.reg) | The registry value from the table above |
| [`RDP_Autostart.bat`](RDP_Autostart.bat) | Imports `C:\scripts\rdp.reg` silently when you sign in |
| [`extras/usb-redirection.reg`](extras/usb-redirection.reg) | Optional USB redirection policies, not needed for the fix and not applied by the script |

<details>
<summary><b>Optional: USB redirection settings</b></summary>

<br>

The file `extras/usb-redirection.reg` is separate on purpose. It changes which USB devices Remote Desktop can redirect, so import it only if you want that:

- Blocks Windows Portable Devices (`{3376f4ce-…}`), for example phones connected over MTP.
- Allows imaging devices (`{6bdd1fc6-…}`), for example webcams.
- Tunes real-time USB streaming for webcams and audio.

Test it before you rely on it. Double-click the file to import it, and delete the `UsbBlockDeviceBySetupClasses` and `UsbSelectDeviceByInterfaces` keys plus the three `fEnableUsb…` values under the same registry key to remove it.

</details>

## Troubleshooting

| Problem | What to check |
| --- | --- |
| Nothing happens at sign-in | Is `rdp.reg` in `C:\scripts\`? Is `RDP_Autostart.bat` in the startup folder (`Win + R`, `shell:startup`)? |
| "Import failed" in the script window | Administrator rights are missing. Use Option A in an elevated terminal. |
| The warning still appears | Run the check command above. The value should be `0x1`. A Group Policy can overwrite it, and Microsoft may have removed the setting in a newer update. |

## A safer long-term option

Instead of switching the warning off, you can sign your `.rdp` files with a code-signing certificate. Windows then shows your organization instead of "Unknown publisher". The sources below describe this approach.

## Sources

- [Windows April 2026 update: new RDP security warnings and how to fix them (ITP360)](https://itp360.com/insights/windows-april-2026-update-new-rdp-security-warnings-and-how-to-fix-them/)
- [Fix the Remote Desktop security warning (LazyAdmin)](https://lazyadmin.nl/it/fix-remote-desktop-security-warning/)
- [Advanced USB redirection control in RDP using registry policies (Bison)](https://knowledgebase.bison.co.in/view_article.php?id=1148)

## License

Released under the [MIT license](LICENSE).
