hl.config({
    general = {
        col = {
            active_border   = "rgba(978e98AA)",
            inactive_border = "rgba(4b444dAA)",
        },
    },
    misc = {
        background_color = "rgba(161217FF)",
    },
})

-- pinned windows
hl.window_rule({
    match        = { pin = 1 },
    border_color = "rgba(e1b7f5AA) rgba(e1b7f577)",
})

-- fullscreen windows
hl.window_rule({
    match        = { fullscreen = 1 },
    border_color = "rgba(8CD2F3AA)",
    border_size  = 3,
})

-- hyprbars plugin (configured in plugins.conf)
