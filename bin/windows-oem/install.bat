@echo off
:: Post-install script for Windows VM (executed by dockur after installation)
:: Enables OpenSSH Server for remote management

echo [*] Installing and configuring OpenSSH Server...

:: Install OpenSSH Server (available as optional feature in Windows 11)
powershell -Command "Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0"

:: Start the service and set to automatic
powershell -Command "Start-Service sshd"
powershell -Command "Set-Service -Name sshd -StartupType Automatic"

:: Set PowerShell as default SSH shell
powershell -Command "New-ItemProperty -Path 'HKLM:\SOFTWARE\OpenSSH' -Name DefaultShell -Value 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' -PropertyType String -Force"

:: Allow SSH through Windows Firewall
powershell -Command "New-NetFirewallRule -Name 'OpenSSH-Server' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22" 2>nul

echo [+] OpenSSH Server installed and running.
