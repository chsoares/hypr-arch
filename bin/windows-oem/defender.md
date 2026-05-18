# Defender Notes

This note documents what was required to make `Windows Security` work correctly in the Dockurr Windows VM and how the one-click Defender lab toggles were implemented.

## Context

- Host-side launcher: `bin/windows-vm`
- Guest OEM post-install entrypoint: `bin/windows-oem/install.bat`
- Docker image family in use during this work: `dockurr/windows` with `VERSION="11l"`
- Guest OS observed during troubleshooting: `Windows 11 IoT Enterprise LTSC 2024 Evaluation`

## Problem Summary

The Defender engine was active, but the GUI was broken:

- `WinDefend` was running
- `SecurityHealthService` was running
- `Get-MpComputerStatus` showed Defender enabled
- opening `Windows Security` reported that the program was not installed
- `Set-MpPreference` was not a reliable way to disable Defender because Tamper Protection blocked or reverted changes

This turned out to be a packaging problem, not an engine problem.

## Root Cause

The native `SecHealthUI` package payload existed in the guest, but it was not provisioned/installed.

Important evidence:

- Missing native app registration:

```powershell
Get-AppxPackage -AllUsers Microsoft.SecHealthUI
```

- Native package payload present on disk:

```powershell
Get-Item 'C:\Windows\System32\SecurityHealth\10.0.29510.1001-0\Microsoft.SecHealthUI_8wekyb3d8bbwe.appx'
```

- Store app was unrelated noise and made things worse:

```powershell
Get-AppxPackage -AllUsers Microsoft.6365217CE6EB4
```

The problem was therefore: Defender backend present, native UI payload present, native UI package not provisioned.

## Recovering the Native Windows Security UI

### 1. Remove the Store Defender app if present

The Store `Microsoft Defender` app is not the same thing as the native `Windows Security` UI and caused confusion during testing.

```powershell
Get-AppxPackage -AllUsers Microsoft.6365217CE6EB4 |
  ForEach-Object {
    Remove-AppxPackage -Package $_.PackageFullName -AllUsers -ErrorAction Continue
  }
```

### 2. Provision the native `SecHealthUI` package with DISM

Direct `Add-AppxPackage` attempts were unreliable. The step that actually fixed the problem was provisioning the inbox package with `DISM`:

```powershell
dism /Online /Add-ProvisionedAppxPackage \
  /PackagePath:C:\Windows\System32\SecurityHealth\10.0.29510.1001-0\Microsoft.SecHealthUI_8wekyb3d8bbwe.appx \
  /DependencyPackagePath:C:\Windows\System32\SecurityHealth\10.0.29510.1001-0\Microsoft.UI.Xaml.appx \
  /DependencyPackagePath:C:\Windows\System32\SecurityHealth\10.0.29510.1001-0\Microsoft.VCLibs.appx \
  /SkipLicense
```

### 3. Verify the package is installed and visible

```powershell
Get-AppxPackage -AllUsers -Name 'Microsoft.SecHealthUI' | Format-List Name,PackageFullName,InstallLocation
Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -match 'Microsoft.SecHealthUI' } | Format-List DisplayName,PackageName
Get-StartApps | Where-Object { $_.AppID -match 'Microsoft.SecHealthUI' } | Format-Table -AutoSize
```

Expected results:

- installed package name similar to `Microsoft.SecHealthUI_1000.29510.1001.0_x64__8wekyb3d8bbwe`
- Start menu entry similar to `Segurança do Windows`
- `windowsdefender:` protocol backed by native `SecHealthUI`

## Tamper Protection Note

`Set-MpPreference` is not a trustworthy lab toggle by itself in this VM because Tamper Protection remains enabled.

Example blocked behavior:

```powershell
Set-MpPreference -DisableRealtimeMonitoring $true
```

Observed event evidence:

- Defender event `5013`
- message showing Tamper Protection blocked or reverted the change

Because of that, the reliable no-reboot toggle path used here is UI automation through the native `Windows Security` app.

## One-Click Lab Toggles

### Final file layout inside the guest

- Helper script:
  - `C:\Users\admin\Documents\Defender-Lab-Toggle.ps1`
- Desktop shortcuts:
  - `C:\Users\admin\Desktop\Disable Defender (Lab).lnk`
  - `C:\Users\admin\Desktop\Enable Defender (Lab).lnk`

### What the helper does

The helper script:

1. opens or reuses `Windows Security`
2. navigates to `Virus & threat protection`
3. enters `Manage settings`
4. toggles these runtime settings without reboot:
   - `Real-time protection`
   - `Cloud-delivered protection`
   - `Automatic sample submission`
5. closes the `Windows Security` window

It intentionally does **not** try to turn off `Tamper Protection`.

### Effective results of the shortcuts

`Disable Defender (Lab).lnk` results in:

- `RealTimeProtectionEnabled: False`
- `BehaviorMonitorEnabled: False`
- `IoavProtectionEnabled: False`
- `MAPSReporting: 0`
- `SubmitSamplesConsent: 0`

`Enable Defender (Lab).lnk` restores:

- `RealTimeProtectionEnabled: True`
- `BehaviorMonitorEnabled: True`
- `IoavProtectionEnabled: True`
- `MAPSReporting: 2`
- `SubmitSamplesConsent: 1`

## Logs

The helper writes logs to the current user's temp directory:

- `C:\Users\admin\AppData\Local\Temp\defender-lab-toggle-disable.log`
- `C:\Users\admin\AppData\Local\Temp\defender-lab-toggle-enable.log`

These logs are useful when validating a fresh install or debugging a future UI layout change.

## Shortcut Implementation Notes

The desktop launchers were converted from `.cmd` wrappers to `.lnk` shortcuts for a cleaner desktop.

Current shortcut properties:

- `Disable Defender (Lab).lnk`
  - target: `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
  - icon: `C:\Windows\System32\SHELL32.dll,132`
- `Enable Defender (Lab).lnk`
  - target: `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
  - icon: `C:\Windows\System32\SecurityHealthSystray.exe,0`

Arguments passed by each shortcut:

```powershell
-NoProfile -ExecutionPolicy Bypass -File "C:\Users\admin\Documents\Defender-Lab-Toggle.ps1" -Mode Disable
```

```powershell
-NoProfile -ExecutionPolicy Bypass -File "C:\Users\admin\Documents\Defender-Lab-Toggle.ps1" -Mode Enable
```

## Validation Commands

After rebuilding a machine, use these checks.

### UI recovery validation

```powershell
Get-AppxPackage -AllUsers -Name 'Microsoft.SecHealthUI' | Format-List Name,PackageFullName,InstallLocation
Get-AppxProvisionedPackage -Online | Where-Object { $_.PackageName -match 'Microsoft.SecHealthUI' } | Format-List DisplayName,PackageName
Get-StartApps | Where-Object { $_.AppID -match 'Microsoft.SecHealthUI' } | Format-Table -AutoSize
```

### Defender runtime state validation

```powershell
Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled,BehaviorMonitorEnabled,IoavProtectionEnabled,IsTamperProtected | Format-List
Get-MpPreference | Select-Object DisableRealtimeMonitoring,MAPSReporting,SubmitSamplesConsent | Format-List
```

### Operational event validation

```powershell
Get-WinEvent -LogName 'Microsoft-Windows-Windows Defender/Operational' -MaxEvents 10 |
  Select-Object TimeCreated,Id,Message |
  Format-List
```

Useful event IDs seen during this work:

- `5000` - real-time protection enabled
- `5001` - real-time protection disabled
- `5007` - Defender configuration changed
- `5013` - Tamper Protection reverted or blocked a direct change

## Handoff Notes For Another Agent

If reproducing this on another machine, the order should be:

1. confirm the guest is the same LTSC family/build
2. verify whether `Microsoft.SecHealthUI` is missing but the `SecurityHealth` appx payload exists
3. remove Store `Microsoft Defender` if someone installed it while troubleshooting
4. provision native `SecHealthUI` with `DISM`
5. verify Start menu registration for `Windows Security`
6. place `Defender-Lab-Toggle.ps1` in `Documents`
7. create the two `.lnk` shortcuts on the Desktop
8. validate both `Disable` and `Enable`, then leave the machine with Defender enabled

If the helper ever stops working after a Windows update, the first thing to check is whether the `Windows Security` UI automation tree changed on the `Manage settings` page.
