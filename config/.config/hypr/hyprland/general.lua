-- MONITOR CONFIG (default - auto-detect)
hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1
})

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 5,
        gaps_workspaces = 50,
        border_size = 2,
        col = {
            active_border = "rgba(0DB7D4FF)",
            inactive_border = "rgba(31313600)"
        },
        resize_on_border = true,
        no_focus_fallback = true,
        allow_tearing = true,
        snap = { enabled = true },
    },
    decoration = {
        rounding = 18,
        active_opacity = 1.0,
        inactive_opacity = 0.85,
        dim_inactive = false,
        dim_strength = 0.025,
        dim_special = 0.075,
        blur = {
            enabled = true,
            xray = true,
            special = false,
            new_optimizations = true,
            size = 10,
            passes = 3,
            brightness = 1,
            noise = 0.01,
            contrast = 1,
            popups = true,
            popups_ignorealpha = 0.6,
            input_methods = true,
            input_methods_ignorealpha = 0.8,
        },
        shadow = {
            enabled = true,
            range = 30,
            offset = {0, 2},
            render_power = 4,
            color = "rgba(00000010)",
        },
    },
    animations = { enabled = true },
    dwindle = {
        preserve_split = true,
        smart_split = false,
        smart_resizing = false,
    },
})

-- Curves
hl.curve("expressiveFastSpatial",    { type = "bezier", points = {{0.42, 1.67}, {0.21, 0.90}} })
hl.curve("expressiveSlowSpatial",    { type = "bezier", points = {{0.39, 1.29}, {0.35, 0.98}} })
hl.curve("expressiveDefaultSpatial", { type = "bezier", points = {{0.38, 1.21}, {0.22, 1.00}} })
hl.curve("emphasizedDecel",         { type = "bezier", points = {{0.05, 0.7}, {0.1, 1}} })
hl.curve("emphasizedAccel",         { type = "bezier", points = {{0.3, 0}, {0.8, 0.15}} })
hl.curve("standardDecel",           { type = "bezier", points = {{0, 0}, {0, 1}} })
hl.curve("menu_decel",              { type = "bezier", points = {{0.1, 1}, {0, 1}} })
hl.curve("menu_accel",              { type = "bezier", points = {{0.52, 0.03}, {0.72, 0.08}} })

-- Animations
hl.animation({ leaf = "windowsIn",           enabled = true, speed = 3,  bezier = "emphasizedDecel", style = "popin 80%" })
hl.animation({ leaf = "windowsOut",          enabled = true, speed = 2,  bezier = "emphasizedDecel", style = "popin 100%" })
hl.animation({ leaf = "windowsMove",         enabled = true, speed = 3,  bezier = "emphasizedDecel", style = "slide" })
hl.animation({ leaf = "border",              enabled = true, speed = 10, bezier = "emphasizedDecel" })
hl.animation({ leaf = "layersIn",            enabled = true, speed = 2.7, bezier = "emphasizedDecel", style = "popin 93%" })
hl.animation({ leaf = "layersOut",           enabled = true, speed = 2.4, bezier = "menu_accel",      style = "popin 100%" })
hl.animation({ leaf = "fadeLayersIn",        enabled = true, speed = 0.5, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut",       enabled = true, speed = 2.7, bezier = "menu_accel" })
hl.animation({ leaf = "workspaces",          enabled = true, speed = 7,   bezier = "menu_decel",      style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 2.8, bezier = "emphasizedDecel", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1.2, bezier = "emphasizedAccel", style = "slidevert" })

hl.config({
    input = {
        kb_layout = "br",
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 35,
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor = 0.5,
        },
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 1,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        animate_manual_resizes = false,
        animate_mouse_windowdragging = false,
        enable_swallow = false,
        swallow_regex = "(foot|kitty|allacritty|Alacritty)",
        on_focus_under_fullscreen = 2,
        allow_session_lock_restore = true,
        initial_workspace_tracking = false,
        focus_on_activate = true,
    },
    binds = {
        scroll_event_delay = 0,
        hide_special_on_workspace_change = true,
    },
    cursor = {
        zoom_factor = 1,
        zoom_rigid = false,
    },
})

-- hyprexpo plugin (configured in plugins.conf)
