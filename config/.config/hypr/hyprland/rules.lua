-- ######## Window rules ########

-- Disable blur for xwayland context menus
hl.window_rule({ match = { class = "^()$", title = "^()$" }, no_blur = true })

-- Floating
hl.window_rule({ match = { class = "^(blueberry\\.py)$" },                          float = true })
hl.window_rule({ match = { class = "^(steam)$" },                                    float = true })
hl.window_rule({ match = { class = "^(guifetch)$" },                                 float = true })
hl.window_rule({ match = { class = "^(pavucontrol)$" },                              float = true, size = {"(monitor_w*0.45)", "(monitor_h*0.45)"}, center = true })
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" },               float = true, size = {"(monitor_w*0.45)", "(monitor_h*0.45)"}, center = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" },                     float = true, size = {"(monitor_w*0.45)", "(monitor_h*0.45)"}, center = true })
hl.window_rule({ match = { class = ".*plasmawindowed.*" },                           float = true })
hl.window_rule({ match = { class = "kcm_.*" },                                        float = true })
hl.window_rule({ match = { class = ".*bluedevilwizard" },                            float = true })
hl.window_rule({ match = { title = ".*Welcome" },                                    float = true })
hl.window_rule({ match = { title = "^(illogical-impulse Settings)$" },               float = true })
hl.window_rule({ match = { class = "xdg.desktop.portal.gtk" },                       float = true })
hl.window_rule({ match = { class = "Windscribe" },                                    float = true })

-- No appearance (kde-material-you-colors helper)
hl.window_rule({ match = { class = "^(plasma-changeicons)$" }, float = true, no_initial_focus = true, move = {999999, 999999} })

-- Tiling
hl.window_rule({ match = { class = "^dev\\.warp\\.Warp$" }, tile = true })

-- Picture-in-Picture
hl.window_rule({ match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, float = true, keep_aspect_ratio = true,
    move = {"(monitor_w*0.73)", "(monitor_h*0.72)"}, size = {"(monitor_w*0.25)", "(monitor_h*0.25)"}, pin = true })

-- Dialog windows – float+center
hl.window_rule({ match = { title = "^(Open File)(.*)$" },       center = true, float = true })
hl.window_rule({ match = { title = "^(Select a File)(.*)$" },   center = true, float = true })
hl.window_rule({ match = { title = "^(Select file)(.*)$" },     center = true, float = true })
hl.window_rule({ match = { title = "^(Choose wallpaper)(.*)$" },center = true, float = true })
hl.window_rule({ match = { title = "^(Open Folder)(.*)$" },     center = true, float = true })
hl.window_rule({ match = { title = "^(Save As)(.*)$" },         center = true, float = true })
hl.window_rule({ match = { title = "^(Library)(.*)$" },         center = true, float = true })
hl.window_rule({ match = { title = "^(File Upload)(.*)$" },     center = true, float = true })

-- Tearing
hl.window_rule({ match = { title = ".*\\.exe" },    immediate = true })
hl.window_rule({ match = { title = ".*minecraft.*" }, immediate = true })
hl.window_rule({ match = { class = "^(steam_app)" }, immediate = true })

-- No shadow for tiled windows
hl.window_rule({ match = { float = 0 }, no_shadow = true })

-- ######## Special workspace rules ########
hl.workspace_rule({ workspace = "special:special", gaps_out = 30 })

hl.workspace_rule({ workspace = "special:spotify", gaps_out = 30 })
hl.window_rule({ match = { class = "spotify" }, workspace = "special:spotify" })

hl.workspace_rule({ workspace = "special:ferdium", gaps_out = 30 })
hl.window_rule({ match = { class = "ferdium" }, workspace = "special:ferdium" })

hl.workspace_rule({ workspace = "special:calc", gaps_out = 30 })
hl.window_rule({ match = { class = "qalculate-gtk" }, float = true, center = true, workspace = "special:calc" })

-- ######## Layer rules ########
hl.layer_rule({ match = { namespace = ".*" },                 xray = true })
hl.layer_rule({ match = { namespace = "walker" },             no_anim = true })
hl.layer_rule({ match = { namespace = "selection" },          no_anim = true })
hl.layer_rule({ match = { namespace = "overview" },           no_anim = true })
hl.layer_rule({ match = { namespace = "anyrun" },             no_anim = true })
hl.layer_rule({ match = { namespace = "indicator.*" },        no_anim = true })
hl.layer_rule({ match = { namespace = "osk" },                no_anim = true })
hl.layer_rule({ match = { namespace = "hyprpicker" },         no_anim = true })
hl.layer_rule({ match = { namespace = "gtk4-layer-shell" },   no_anim = true })

-- Quickshell
hl.layer_rule({ match = { namespace = "quickshell:overview" },      animation = "popin 98%", dim_around = true })
hl.layer_rule({ match = { namespace = "quickshell:bar" },           animation = "slide" })
hl.layer_rule({ match = { namespace = "quickshell:screenCorners" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "quickshell:sidebarRight" },  animation = "slide right" })
hl.layer_rule({ match = { namespace = "quickshell:osk" },           animation = "slide bottom" })
hl.layer_rule({ match = { namespace = "quickshell:dock" },          animation = "slide bottom" })
hl.layer_rule({ match = { namespace = "quickshell:notificationPopup" }, animation = "fade" })
hl.layer_rule({ match = { namespace = "quickshell:session" },       blur = true, no_anim = true, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "quickshell:cheatsheet" },    dim_around = true })
