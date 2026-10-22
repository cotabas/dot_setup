-- ============================================================================
-- Environment Variables (Must be set before anything else initializes)
-- ============================================================================
hl.env("AQ_DRM_DEVICES", "/dev/dri/card1")
hl.env("AQ_NO_MODIFIERS", "1") -- External monitor breaks without this
hl.env("__EGL_VENDOR_LIBRARY_FILENAMES", "/usr/share/glvnd/egl_vendor.d/50_mesa.json")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "mesa")
hl.env("__NV_PRIME_RENDER_OFFLOAD", "0")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XCURSOR_SIZE", "24")

-- ============================================================================
-- Autostart (Replaces exec-once)
-- ============================================================================
hl.on("hyprland.start", function()
    hl.exec_cmd("env DRI_PRIME=0 hyprpaper")
    hl.exec_cmd("xrandr --setprovideroutputsource 1 0")
    hl.exec_cmd("waybar & dunst & hypridle & udiskie &")
    hl.exec_cmd("env DRI_PRIME=0 GSK_RENDERER=ngl swayosd-server")
end)

-- ============================================================================
-- Monitors
-- ============================================================================
hl.monitor({ output = "eDP-1", mode = "3840x2400", position = "auto", scale = 2 })
hl.monitor({ output = "DP-1", mode = "3840x2160", position = "auto", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- ============================================================================
-- Core Configuration Options
-- ============================================================================
hl.config({
    debug = {
        disable_logs = true,
        vfr = true, -- Crucial for laptop battery life
    },
    general = {
        gaps_in = 5,
        gaps_out = 5,
        border_size = 0,
        layout = "dwindle",
        col = {
            active_border = "rgba(ff8800ee)",
            inactive_border = "rgba(595959aa)",
        },
    },
    input = {
        kb_layout = "us",
        repeat_delay = 300,
        repeat_rate = 50,
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
        },
    },
    cursor = {
        no_hardware_cursors = false,
        inactive_timeout = 5,
    },
    decoration = {
        blur = {
            enabled = false,
        },
        shadow = {
            enabled = false,
        },
    },
    animations = {
        enabled = false,
    },
    dwindle = {
        preserve_split = true,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})

-- ============================================================================
-- Gestures & Window Rules
-- ============================================================================
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.window_rule({
    name = "tile-webapps",
    match = { class = "^(webApp)$" },
    tile = true,
})

-- ============================================================================
-- Keybindings
-- ============================================================================
local mainMod = "SUPER"

-- Screenshot
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp)"'))

-- Webapps (Fixed --new-window typos)
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("chromium --app=https://claude.ai/ --new-window --class=webApp"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("chromium --app=https://gemini.google.com/app --new-window --class=webApp"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("chromium --app=https://gmail.google.com/ --new-window --class=webApp"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("chromium --app=https://music.youtube.com/ --new-window --class=webApp"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("chromium --app=https://calendar.google.com/ --new-window --class=webApp"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("chromium --app=https://word.cloud.microsoft/ --new-window --class=webApp"))

-- Applications
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("foot"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("env DRI_PRIME=0 chromium"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("firejail --noprofile --blacklist=/dev/nvidia* obsidian"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("foot -e btop"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("dunstctl history-pop"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("firejail --noprofile --blacklist=/dev/nvidia* discord"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("wofi --show drun"))

-- Compositor & Window Management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + Escape", hl.dsp.exit())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Move Focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Switch & Move to Workspaces (1-10 via loop)
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = tostring(i) }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = tostring(i) }))
end

-- Scroll Workspaces with Mouse Wheel
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/Resize Windows with Mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Audio & Media
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { repeating = true })
hl.bind(mainMod .. " + XF86MonBrightnessUp", hl.dsp.exec_cmd("echo 400 > /sys/class/backlight/intel_backlight/brightness"), { repeating = true })
hl.bind(mainMod .. " + XF86MonBrightnessDown", hl.dsp.exec_cmd("echo 10 > /sys/class/backlight/intel_backlight/brightness"), { repeating = true })
