---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

local primary_browser = "firefox"
local terminal = "kitty"

hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(primary_browser))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))

hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("pkill wlogout || wlogout"))
hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { repeating = true })
hl.bind(
	mainMod .. " + R",
	hl.dsp.exec_cmd("pkill waybar || waybar -c $HOME/.config/waybar/config.jsonc -s $HOME/.config/waybar/style.css")
)
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("pkill localsend || localsend"), { repeating = false })

hl.bind(mainMod .. " + a", hl.dsp.exec_cmd("pkill rofi || rofi -show drun"))
hl.bind(mainMod .. " + tab", hl.dsp.window.cycle_next(), { repeating = true })

hl.bind(mainMod .. " + I", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + U", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + Down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + Up", hl.dsp.focus({ workspace = "e-1" }))

for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("SUPER + SHIFT + V", function()
	local active = hl.get_active_window()

	if active and active.floating then
		hl.dispatch(hl.dsp.focus({ window = "tiled" }))
	else
		hl.dispatch(hl.dsp.focus({ window = "floating" }))
	end
end)

hl.bind("ALT + G", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + Space", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(
		"wpctl set-volume -l 1.2 @DEFAULT_AUDIO_SINK@ 10%+ && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"
	),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(
		"wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%- && paplay /usr/share/sounds/freedesktop/stereo/audio-volume-change.oga"
	),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = false }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = false }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true, repeating = true })

hl.bind("ALT + V", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("ALT + C", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("ALT + x", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("ALT + B", hl.dsp.exec_cmd("playerctl position 1+"), { locked = true, repeating = true })
hl.bind("ALT + Z", hl.dsp.exec_cmd("playerctl position 1-"), { locked = true, repeating = true })

hl.bind("Print", hl.dsp.exec_cmd("bash ~/.config/Scripts/full_screenshot.sh"), { locked = true, repeating = false })
hl.bind(
	"ALT + Print",
	hl.dsp.exec_cmd("bash ~/.config/Scripts/partial_screenshot.sh"),
	{ locked = true, repeating = false }
)
hl.bind(
	"CTRL + Print",
	hl.dsp.exec_cmd("bash ~/.config/Scripts/screen_recorder.sh"),
	{ locked = true, repeating = false }
)

hl.bind("ALT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(
	"ALT + L",
	hl.dsp.exec_cmd("bash ~/.config/Scripts/random_wall_on_lockscr.sh"),
	{ locked = false, repeating = false }
)
hl.bind(
	"ALT + N",
	hl.dsp.exec_cmd("hyprctl reload && notify-send 'Hyprland' 'Config reloaded'"),
	{ locked = true, repeating = false }
)
hl.bind("ALT + O", hl.dsp.exec_cmd("systemctl poweroff"), { locked = true, repeating = false })
hl.bind("ALT + R", hl.dsp.exec_cmd("systemctl reboot"), { locked = true, repeating = false })
hl.bind(
	"ALT + S",
	hl.dsp.exec_cmd("systemctl suspend ; bash ~/.config/Scripts/random_wall_on_lockscr.sh"),
	{ locked = true, repeating = false }
)
