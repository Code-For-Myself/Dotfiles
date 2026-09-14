---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "de,us",
		kb_options = "grp:alt_shift_toggle",
		numlock_by_default = false,
		follow_mouse = 1,
		sensitivity = 0.0,
		scroll_factor = 0.0,
		accel_profile = "flat",
		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
		},
	},
})
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})
