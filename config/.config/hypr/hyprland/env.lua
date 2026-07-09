local home_dir = os.getenv("HOME")

-- Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Input method (fcitx)
hl.env("QT_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "ibus")
hl.env("INPUT_METHOD", "fcitx")

-- Themes
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")

-- Virtual environment
hl.env("ILLOGICAL_IMPULSE_VIRTUAL_ENV", home_dir .. "/.local/state/quickshell/.venv")
