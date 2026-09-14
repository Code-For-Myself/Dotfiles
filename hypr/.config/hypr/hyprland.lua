hl.config({
	decoration = {
		blur = {
			enabled = true,
			size = 8,
			passes = 2,
			ignore_opacity = true,
			new_optimizations = true,
		},
	},
})
hl.animation({ leaf = "global", enabled = false })

require("hyprland_modules/Monitors")
require("hyprland_modules/Input")
require("hyprland_modules/Generals")
require("hyprland_modules/Keybinds")
require("hyprland_modules/Layouts")
require("hyprland_modules/Decorations")
require("hyprland_modules/autostart")
require("hyprland_modules/Rules")
require("hyprland_modules/misc")

hl.env("QS_ICON_THEME", "Papirus-Dark")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
