require("hyprland.lib")
require("hyprland.variables")

local hyprScripts = "$HOME/.config/hypr/hyprland/scripts"
local qsIpcCall = "qs ipc call"
local qsIsAlive = qsIpcCall .. " TEST_ALIVE"

--! 
---! Shell
hl.bind("SUPER + SUPER_L", hl.dsp.global("quickshell:overviewToggleRelease"),
    { description = "Shell: Toggle overview/launcher", ignore_mods = true })
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd(qsIsAlive .. " || pkill fuzzel || fuzzel"))
hl.bind("CTRL + SUPER_L", hl.dsp.global("quickshell:overviewToggleReleaseInterrupt"))

hl.bind("SUPER_L", hl.dsp.global("quickshell:workspaceNumber"),
    { ignore_mods = true, transparent = true })

hl.bind("SUPER + N", hl.dsp.global("quickshell:sidebarRightToggle"),
    { description = "Shell: Toggle right sidebar" })
hl.bind("SUPER + H", hl.dsp.global("quickshell:cheatsheetToggle"),
    { description = "Shell: Toggle cheatsheet" })
hl.bind("SUPER + K", hl.dsp.global("quickshell:oskToggle"),
    { description = "Shell: Toggle on-screen keyboard" })

hl.bind("SUPER + I", hl.dsp.exec_cmd(settingsApp), { description = "Shell: Settings app" })
hl.bind("SHIFT + SUPER + ALT + Slash",
    hl.dsp.exec_cmd("qs -p $HOME/.config/quickshell/welcome.qml"))

-- Brightness / Volume
hl.bind("XF86MonBrightnessUp",
    hl.dsp.exec_cmd(qsIpcCall .. " brightness increment || brightnessctl s 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",
    hl.dsp.exec_cmd(qsIpcCall .. " brightness decrement || brightnessctl s 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",
    hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"),
    { locked = true, repeating = true })

-- Mute
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("SUPER + SHIFT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SINK@ toggle"),
    { locked = true })
hl.bind("ALT + XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
hl.bind("SUPER + ALT + M", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_SOURCE@ toggle"),
    { locked = true })

-- Wallpaper / Color
hl.bind("SUPER + CTRL + ALT + W",
    hl.dsp.exec_cmd("$HOME/.config/quickshell/scripts/colors/switchwall.sh"),
    { description = "Shell: Change wallpaper" })
hl.bind("SUPER + CTRL + ALT + T",
    hl.dsp.exec_cmd(hyprScripts .. "/random-wallpaper.sh"))
hl.bind("SUPER + CTRL + ALT + Y",
    hl.dsp.exec_cmd("$HOME/.config/quickshell/scripts/colors/applycolor.sh"))

hl.bind("SUPER + CTRL + ALT + R",
    hl.dsp.exec_cmd("killall ags agsv1 gjs ydotool qs quickshell; qs &"),
    { description = "Shell: Restart widgets" })

---! Utilities
--# Screenshot
hl.bind("Print", hl.dsp.exec_cmd("grim - | wl-copy"),
    { locked = true, description = "Utilities: Screenshot to clipboard" })
hl.bind("CTRL + Print",
    hl.dsp.exec_cmd("mkdir -p $(xdg-user-dir PICTURES)/Screenshots && grim $(xdg-user-dir PICTURES)/Screenshots/Screenshot_\"$(date '+%Y-%m-%d_%H.%M.%S')\".png"),
    { locked = true, description = "Utilities: Screenshot to file" })
hl.bind("SUPER + Print", hl.dsp.exec_cmd(hyprScripts .. "/hypr-snip.sh"),
    { description = "Utilities: Screen snip editor" })
hl.bind("SUPER + SHIFT + Print",
    hl.dsp.exec_cmd("grimblast --freeze save area - | wl-copy"),
    { description = "Utilities: Screen snip to clipboard" })

--# Emoji / Clipboard
hl.bind("SUPER + Period", hl.dsp.global("quickshell:overviewEmojiToggle"),
    { description = "Utilities: Emoji >> clipboard" })
hl.bind("SUPER + Period",
    hl.dsp.exec_cmd(qsIsAlive .. " || pkill fuzzel || " .. hyprScripts .. "/fuzzel-emoji.sh copy"))
hl.bind("SUPER + V", hl.dsp.global("quickshell:overviewClipboardToggle"),
    { description = "Utilities: Clipboard history >> clipboard" })
hl.bind("SUPER + V",
    hl.dsp.exec_cmd(qsIsAlive .. " || pkill fuzzel || cliphist list | fuzzel --match-mode fzf --dmenu | cliphist decode | wl-copy"))

---! Screen
--# Zoom
local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 3.0 then
        hl.config({ cursor = { zoom_factor = 3.0 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind("SUPER + Minus", function() zoomfunction(-0.1) end,
    { repeating = true, description = "Screen: Zoom out" })
hl.bind("SUPER + Equal", function() zoomfunction(0.1) end,
    { repeating = true, description = "Screen: Zoom in" })

--! 
---! Window
--# Focusing
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Window: Move" })
hl.bind("SUPER + mouse:274", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Window: Resize" })

hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Window: Close" })
hl.bind("SUPER + SHIFT + ALT + CTRL + Q", hl.dsp.exec_cmd("hyprctl kill"))

--# Positioning mode
hl.bind("SUPER + Space", hl.dsp.window.float({ action = "toggle" }),
    { description = "Window: Float/Tile" })
hl.bind("SUPER + Y", hl.dsp.layout("togglesplit"),
    { description = "Window: Horizontal/Vertical" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
    { description = "Window: Maximize" })
hl.bind("SUPER + SHIFT + F",
    hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }))
hl.bind("SUPER + P", hl.dsp.window.pin())

--# Split ratio
hl.bind("SUPER + Semicolon", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind("SUPER + Slash", hl.dsp.layout("splitratio +0.1"), { repeating = true })

--#/# bind = SUPER + ←/↑/→/↓,, -- Focus in direction
for i = 1, 4 do
    local arrowkey = { "Left", "Right", "Up", "Down" }
    local focusdir = { "l", "r", "u", "d" }
    hl.bind("SUPER + " .. arrowkey[i], hl.dsp.focus({ direction = focusdir[i] }),
        { description = "Window: Focus " .. arrowkey[i] })
end
hl.bind("SUPER + BracketLeft", hl.dsp.focus({ direction = "l" }))
hl.bind("SUPER + BracketRight", hl.dsp.focus({ direction = "r" }))

--#/# bind = SUPER + SHIFT, ←/↑/→/↓,, -- Move in direction
for i = 1, 4 do
    local arrowkey = { "Left", "Right", "Up", "Down" }
    local focusdir = { "l", "r", "u", "d" }
    hl.bind("SUPER + ALT + " .. arrowkey[i],
        hl.dsp.window.move({ direction = focusdir[i] }),
        { description = "Window: Move " .. arrowkey[i] })
end

--#/# bind = SUPER + SHIFT, Hash,, -- Send to workspace #
for i = 1, 10 do
    hl.bind("SUPER + SHIFT + " .. (i % 10),
        hl.dsp.exec_cmd(hyprScripts .. "/workspace_action.sh movetoworkspacesilent " .. i),
        { description = "Window: Send to workspace " .. i })
end

--#/# bind = SUPER + SHIFT, ←/→,, -- Send to workspace left/right
hl.bind("SUPER + SHIFT + Left", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind("SUPER + SHIFT + Right", hl.dsp.window.move({ workspace = "r+1" }))

--# #/# bind = SUPER + SHIFT, Scroll ↑/↓,, -- Send to workspace left/right
hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.move({ workspace = "r+1" }))

--#/# bind = SUPER + SHIFT, Page_↑/↓,, -- Send to workspace left/right
hl.bind("SUPER + ALT + Page_Down", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind("SUPER + ALT + Page_Up", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind("SUPER + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "-1" }))

--# Send to scratchpad
hl.bind("SUPER + SHIFT + S",
    hl.dsp.window.move({ workspace = "special:special", follow = false }),
    { description = "Window: Send to scratchpad" })
hl.bind("SUPER + ALT + S",
    hl.dsp.window.move({ workspace = "special:special", follow = false }))

---! Workspace
--# Switching
--#/# bind = SUPER, Hash,, -- Focus workspace #
for i = 1, 10 do
    hl.bind("SUPER + " .. (i % 10),
        hl.dsp.exec_cmd(hyprScripts .. "/workspace_action.sh workspace " .. i),
        { description = "Workspace: Focus " .. i })
end
hl.bind("SUPER + Tab", hl.dsp.focus({ workspace = "previous" }),
    { description = "Workspace: Focus previous" })

--#/# bind = CTRL + SUPER, ←/→,, -- Focus left/right
hl.bind("CTRL + SUPER + Right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("CTRL + SUPER + Left", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("CTRL + SUPER + ALT + Right", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("CTRL + SUPER + ALT + Left", hl.dsp.focus({ workspace = "m-1" }))

--#/# bind = SUPER, Page_↑/↓,, -- Focus left/right
hl.bind("CTRL + SUPER + Page_Down", hl.dsp.focus({ workspace = "+1" }))
hl.bind("CTRL + SUPER + Page_Up", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "r-1" }))

--#/# bind = SUPER, Scroll ↑/↓,, -- Focus left/right
hl.bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "+1" }))
hl.bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("CTRL + SUPER + ALT + mouse_up", hl.dsp.focus({ workspace = "m+1" }))
hl.bind("CTRL + SUPER + ALT + mouse_down", hl.dsp.focus({ workspace = "m-1" }))

--## Special
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("special"),
    { description = "Workspace: Toggle scratchpad" })
hl.bind("SUPER + mouse:275", hl.dsp.workspace.toggle_special("special"))

hl.bind("CTRL + SUPER + BracketLeft", hl.dsp.focus({ workspace = "-1" }))
hl.bind("CTRL + SUPER + BracketRight", hl.dsp.focus({ workspace = "+1" }))
hl.bind("CTRL + SUPER + Up", hl.dsp.focus({ workspace = "r-5" }))
hl.bind("CTRL + SUPER + Down", hl.dsp.focus({ workspace = "r+5" }))

--! 
---! Session
hl.bind("SUPER + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"),
    { description = "Session: Lock" })
hl.bind("SUPER + ALT + CTRL + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))
hl.bind("SUPER + CTRL + ALT + L",
    hl.dsp.exec_cmd("sleep 0.1 && systemctl suspend || loginctl suspend"),
    { locked = true, description = "Session: Sleep" })
hl.bind("SUPER + CTRL + ALT + Delete",
    hl.dsp.exec_cmd("systemctl poweroff || loginctl poweroff"),
    { description = "Session: Shut down" })

hl.bind("CTRL + ALT + Delete", hl.dsp.global("quickshell:sessionToggle"),
    { description = "Session: Toggle session menu" })
hl.bind("CTRL + ALT + Delete",
    hl.dsp.exec_cmd(qsIsAlive .. " || pkill wlogout || wlogout -p layer-shell"))

hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(taskManager),
    { description = "Session: Task manager" })

---! Media
local mediaNextCommand =
"playerctl next || playerctl position `bc <<< \"100 * $(playerctl metadata mpris:length) / 1000000 / 100\"`"
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(mediaNextCommand), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("SUPER + SHIFT + ALT + mouse:275", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("SUPER + SHIFT + ALT + mouse:276", hl.dsp.exec_cmd(mediaNextCommand))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

---! Apps
hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal), { description = "App: Terminal" })
hl.bind("SUPER + T", hl.dsp.exec_cmd(terminal))
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager), { description = "App: File manager" })
hl.bind("SUPER + W", hl.dsp.exec_cmd(browser), { description = "App: Browser" })
hl.bind("SUPER + C", hl.dsp.exec_cmd(codeEditor), { description = "App: Code editor" })
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(officeSoftware))
hl.bind("SUPER + X", hl.dsp.exec_cmd(textEditor), { description = "App: Text editor" })

--# Custom apps
hl.bind("SUPER + B",
    hl.dsp.exec_cmd("pgrep qalculate && hyprctl dispatch 'hl.dsp.workspace.toggle_special(\"calc\")' || qalculate-gtk"),
    { description = "App: Calculator" })
hl.bind("SUPER + O",
    hl.dsp.exec_cmd("obsidian -enable-features=UseOzonePlatform -ozone-platform=wayland"),
    { description = "App: Obsidian" })
hl.bind("SUPER + A",
    hl.dsp.exec_cmd("claude-desktop-native -enable-features=UseOzonePlatform -ozone-platform=wayland"),
    { description = "App: Claude" })
hl.bind("SUPER + M",
    hl.dsp.exec_cmd("pgrep spotify && hyprctl dispatch 'hl.dsp.workspace.toggle_special(\"spotify\")' || spotify --enable-features=UseOzonePlatform --ozone-platform=wayland"),
    { description = "App: Spotify" })
hl.bind("SUPER + Z",
    hl.dsp.exec_cmd("pgrep -f ferdium && hyprctl dispatch 'hl.dsp.workspace.toggle_special(\"ferdium\")' || ferdium --enable-features=UseOzonePlatform --ozone-platform=wayland"),
    { description = "App: Ferdium" })

---! Testing
--# Testing
hl.bind("SUPER + ALT + F11",
    hl.dsp.exec_cmd(
        "bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | grep -v -i \"nipple\" | grep -v -i \"pussy\" | shuf -n 1); ACTION=$(notify-send \"Test notification with body image\" \"This notification should contain your user account <b>image</b> and <a href=\\\"https://discord.com/app\\\">Discord</a> <b>icon</b>. Oh and here is a random image in your Pictures folder: <img src=\\\"$RANDOM_IMAGE\\\" alt=\\\"Testing image\\\"/>\" -a \"Hyprland keybind\" -p -h \"string:image-path:/var/lib/AccountsService/icons/$USER\" -t 6000 -i \"discord\" -A \"openImage=Open profile image\" -A \"action2=Open the random image\" -A \"action3=Useless button\"); [[ $ACTION == *openImage ]] && xdg-open \"/var/lib/AccountsService/icons/$USER\"; [[ $ACTION == *action2 ]] && xdg-open \"$RANDOM_IMAGE\"'")
) -- # [hidden]
hl.bind("SUPER + ALT + F12",
    hl.dsp.exec_cmd(
        "bash -c 'RANDOM_IMAGE=$(find ~/Pictures -type f | grep -v -i \"nipple\" | grep -v -i \"pussy\" | shuf -n 1); ACTION=$(notify-send \"Test notification\" \"This notification should contain a random image in your <b>Pictures</b> folder and <a href=\\\"https://discord.com/app\\\">Discord</a> <b>icon</b>.\n<i>Flick right to dismiss!</i>\" -a \"Discord (fake)\" -p -h \"string:image-path:$RANDOM_IMAGE\" -t 6000 -i \"discord\" -A \"openImage=Open profile image\" -A \"action2=Useless button\" -A \"action3=Cry more\"); [[ $ACTION == *openImage ]] && xdg-open \"/var/lib/AccountsService/icons/$USER\"'")
)                                                                                                        -- # [hidden]
hl.bind("SUPER + ALT + Equal",
    hl.dsp.exec_cmd("notify-send 'Urgent notification' 'Ah hell no' -u critical -a 'Hyprland keybind'")) -- # [hidden]

---! Cursed stuff
--# Cursed stuff
--## Make window not amogus large
hl.bind("CTRL + SUPER + Backslash", hl.dsp.window.resize({ x = 640, y = 480, "exact" }))
