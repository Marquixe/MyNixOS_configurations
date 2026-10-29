-- hyprland.lua
-- Migrated from legacy/hyprland.conf (Hyprland 0.56.x, Lua API).
-- The old hyprland.conf is kept in legacy/ for reference only (it is not loaded).
-- After every edit:  hyprctl reload && hyprctl configerrors

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "wofi --show drun"
local mainMod     = "SUPER"

-- Super+LMB / Super+RMB window drag/resize.
-- Hyprland 0.56.2 crashed (dwindle addTarget) on drag end; set to false to disable.
local ENABLE_MOUSE_DRAG = true

------------------
---- MONITORS ----
------------------

hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = 1 })

-----------------------------
---- ENVIRONMENT VARIABLES ----
-----------------------------

hl.env("XCURSOR_THEME", "default")
hl.env("XCURSOR_SIZE", "24")
hl.env("GRIMBLAST_EDITOR", "env GTK_THEME=Adwaita:dark swappy -f")

-----------------
---- AUTOSTART ----
-----------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets,pkcs11,ssh")
    hl.exec_cmd("mako")
    hl.exec_cmd("~/.config/mako/battery-notify.sh")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("wl-paste --watch cliphist -max-items 500 store")
    hl.exec_cmd("clipse -listen")
    -- Overlay HUD (two kitty windows)
    hl.exec_cmd("bash ~/.config/hypr/hud/overlay/hud.sh")
end)

---------------------------
---- LOOK, FEEL, INPUT ----
---------------------------

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 8,
        border_size = 1,
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 8,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = { enabled = true },

    -- dwindle.pseudotile no longer exists; pseudo is bound below (Super+P)
    dwindle = { preserve_split = true },
    master  = { new_status = "master" },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = false,
    },

    input = {
        kb_layout = "us,ua",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = true },
    },

    cursor = { zoom_factor = 1.0 },
})

-- Curves
hl.curve("easeOutQuint",   { type = "bezier", points = { { 0.23, 1 },    { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear",         { type = "bezier", points = { { 0, 0 },       { 1, 1 } } })
hl.curve("almostLinear",   { type = "bezier", points = { { 0.5, 0.5 },   { 0.75, 1 } } })
hl.curve("quick",          { type = "bezier", points = { { 0.15, 0 },    { 0.1, 1 } } })

-- Animations
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })

-- 3-finger horizontal swipe switches workspace
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-- Per-device config
hl.device({ name = "epic-mouse-v1", sensitivity = -0.5 })

-----------------------
---- KEYBINDINGS ----
-----------------------

hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())              -- was killactive
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())             -- dwindle
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))       -- dwindle
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("wlogout"))

-- Focus with arrows
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces 1..10 (key 0 = workspace 10)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize with the mouse (was bindm)
if ENABLE_MOUSE_DRAG then
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
end

-- Second screen
hl.bind(mainMod .. " + ALT + M", hl.dsp.exec_cmd("~/.config/hypr/tools/monitor-mirror.sh"))
hl.bind(mainMod .. " + ALT + E", hl.dsp.exec_cmd("~/.config/hypr/tools/monitor-extend.sh"))
hl.bind(mainMod .. " + ALT + S", hl.dsp.exec_cmd("~/.config/hypr/tools/workspaces-split.sh"))

-- Screenshots (grimblast)
hl.bind("Print",                       hl.dsp.exec_cmd("grimblast copysave area ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"))
hl.bind(mainMod .. " + Print",         hl.dsp.exec_cmd("grimblast copysave screen ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"))
hl.bind("CTRL + Print",                hl.dsp.exec_cmd("grimblast save screen ~/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd("grimblast edit area"))

-- Volume / brightness (was bindel = repeat + locked)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("~/.config/mako/vol.sh up"),   { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("~/.config/mako/vol.sh down"), { repeating = true, locked = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("~/.config/mako/vol.sh mute"), { repeating = true, locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { repeating = true, locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("~/dotfiles/home/mako/brightness.sh up"),   { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/dotfiles/home/mako/brightness.sh down"), { repeating = true, locked = true })

-- Media keys (was bindl = locked)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- HUD
hl.bind(mainMod .. " + H",         hl.dsp.workspace.toggle_special("hud-overlay"))
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.exec_cmd("bash ~/.config/hypr/hud/overlay/hud.sh"))

-- Spotify player: Super+Shift+M launches / toggles
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("~/.config/hypr/tools/toggle-player.sh"))

-- Clipboard history, wifi picker, showkeys
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("kitty --class clipse -e clipse"))
hl.bind(mainMod .. " + W",         hl.dsp.exec_cmd("kitty --class wifi-picker -e bash ~/.config/hypr/tools/wifi.sh"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd("~/.config/hypr/tools/toggle-showkeys.sh"))

-- Cursor zoom (zoom.sh uses `hyprctl eval`, see notes)
hl.bind(mainMod .. " + CTRL + mouse_up",   hl.dsp.exec_cmd("~/.config/hypr/tools/zoom.sh 0.2"))
hl.bind(mainMod .. " + CTRL + mouse_down", hl.dsp.exec_cmd("~/.config/hypr/tools/zoom.sh -0.2"))
hl.bind(mainMod .. " + CTRL + mouse:274",  hl.dsp.exec_cmd("hyprctl eval 'hl.config({ cursor = { zoom_factor = 1.0 } })'"))

--------------------
---- WINDOW RULES ----
--------------------

-- Ignore maximize requests from apps
hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix some XWayland dragging issues
hl.window_rule({
    name = "no-focus-empty-windows",
    match = { class = "^$", title = "^$" },
    no_focus = true,
})

-- HUD (old single-kitty HUD)
hl.window_rule({
    name = "hud-kitty",
    match = { class = "hud-kitty" },
    float = true,
    size = { 1920, 1080 },
    center = true,
    opacity = "0.80 0.80",
    workspace = "special:hud silent",
})

-- HUD animation window: fullscreen, opaque
hl.window_rule({
    name = "hud-anim-kitty",
    match = { class = "hud-anim-kitty" },
    float = true,
    size = { 1920, 1080 },
    center = true,
    opacity = "0.95 0.95",
    workspace = "special:hud-overlay silent",
})

-- HUD info overlay: fullscreen, stacked on top of the animation
hl.window_rule({
    name = "hud-info-kitty",
    match = { class = "hud-info-kitty" },
    float = true,
    size = { 1920, 1080 },
    center = true,
    opacity = "1.0 1.0",
    workspace = "special:hud-overlay silent",
})

-- Spotify player (bottom-right on a 1920x1080 screen)
local PLAYER_WIDTH, PLAYER_HEIGHT = 440, 180
local PLAYER_X, PLAYER_Y = 1470, 800

hl.window_rule({
    name = "spotify-player",
    match = { class = "spotify-player" },
    float = true,
    size = { PLAYER_WIDTH, PLAYER_HEIGHT },
    move = { PLAYER_X, PLAYER_Y },
    opacity = "0.85 0.6",        -- was 0.85 0.15 (almost invisible when unfocused)
    pin = true,
    workspace = "special:spotify-player silent",
})

-- Firefox Picture-in-Picture
local PIP_WIDTH, PIP_HEIGHT = 520, 300
local PIP_X, PIP_Y = 1390, 770

hl.window_rule({
    name = "firefox-pip",
    match = { class = "firefox", title = "^Picture-in-Picture$" },
    float = true,
    size = { PIP_WIDTH, PIP_HEIGHT },
    move = { PIP_X, PIP_Y },
    opacity = "1.0 1.0",
    pin = true,
    no_focus = true,
})

-- Clipboard history (clipse)
hl.window_rule({
    name = "clipse",
    match = { class = "clipse" },
    float = true,
    size = { 1100, 652 },
    center = true,
})

-- WiFi picker
hl.window_rule({
    name = "wifi-picker",
    match = { class = "wifi-picker" },
    float = true,
    size = { 900, 480 },
    center = true,
    opacity = "0.95 0.95",
})
