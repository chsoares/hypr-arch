-- Hyprland main entry point
-- Sources config files in hyprland/ subdirectory

require("hyprland.lib")
require("hyprland.env")
require("hyprland.variables")
require("hyprland.execs")
require("hyprland.general")
require("hyprland.rules")
require("hyprland.colors")
require("hyprland.keybinds")

-- Per-machine configs (copy from monitors-example.lua / workspaces-example.lua)
if is_file_exists(HOME .. "/.config/hypr/hyprland/monitors.lua") then
    require("hyprland.monitors")
end
if is_file_exists(HOME .. "/.config/hypr/workspaces.lua") then
    require("workspaces")
end
if is_file_exists(HOME .. "/.config/hypr/monitors.lua") then
    require("monitors")
end
