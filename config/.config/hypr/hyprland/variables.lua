-- App launcher variables
-- Edit these directly - no custom/ override needed

terminal     = "~/.config/hypr/hyprland/scripts/launch_first_available.sh 'kitty -1' 'foot' 'alacritty' 'wezterm' 'konsole' 'kgx' 'uxterm' 'xterm'"
fileManager  = "~/.config/hypr/hyprland/scripts/launch_first_available.sh 'nautilus' 'kitty -1 fish -c yazi' 'dolphin' 'nemo' 'thunar'"
browser      = "~/.config/hypr/hyprland/scripts/launch_first_available.sh 'zen-browser' 'google-chrome-stable' 'firefox' 'brave' 'chromium' 'microsoft-edge-stable' 'opera'"
codeEditor   = "~/.config/hypr/hyprland/scripts/launch_first_available.sh 'code' 'codium' 'zed' 'kate' 'gnome-text-editor' 'emacs' 'command -v nvim && kitty -1 nvim'"
officeSoftware = "~/.config/hypr/hyprland/scripts/launch_first_available.sh 'wps' 'onlyoffice-desktopeditors'"
textEditor   = "~/.config/hypr/hyprland/scripts/launch_first_available.sh 'kate' 'gnome-text-editor' 'emacs'"
settingsApp  = "XDG_CURRENT_DESKTOP=gnome ~/.config/hypr/hyprland/scripts/launch_first_available.sh 'qs -p ~/.config/quickshell/settings.qml' 'systemsettings' 'gnome-control-center' 'better-control'"
taskManager  = "~/.config/hypr/hyprland/scripts/launch_first_available.sh 'gnome-system-monitor' 'plasma-systemmonitor --page-name Processes' 'command -v btop && kitty -1 fish -c btop'"
