hl.on("hyprland.start", function ()
    -- Cursor & initial workspace
    hl.exec_cmd("hyprctl dispatch workspace 1")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")

    -- Bar, wallpaper
    hl.exec_cmd("sleep 0.5 && [ \"$(hyprctl monitors -j | jq 'length')\" -eq 1 ] && awww-daemon --format xrgb --no-cache || awww-daemon --format xrgb")
    hl.exec_cmd("$HOME/.config/quickshell/scripts/colors/applycolor.sh")
    hl.exec_cmd("qs &> /tmp/quickshell_log.txt")

    -- Input method
    hl.exec_cmd("fcitx5")

    -- Core components
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 || /usr/libexec/polkit-gnome-authentication-agent-1 || /usr/lib/polkit-kde-authentication-agent-1 || /usr/libexec/polkit-kde-authentication-agent-1")
    hl.exec_cmd("hypridle &> /tmp/hypridle.log")
    hl.exec_cmd("dbus-update-activation-environment --all")
    hl.exec_cmd("sleep 1 && dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("hyprpm reload")

    -- Audio
    hl.exec_cmd("easyeffects --gapplication-service")

    -- Clipboard history
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Apps
    hl.exec_cmd("[workspace special:ferdium silent] ferdium --enable-features=UseOzonePlatform --ozone-platform=wayland")
end)
