hl.workspace_rule({ workspace = "1", monitor = "eDP-1", default = true })

hl.workspace_rule({
	workspace = "1",
	monitor = "eDP-1",
	default = true,
})

-- Workspace 2 opens Neovim in Kitty when created empty
hl.workspace_rule({
	workspace = "2",
	on_created_empty = "kitty -e nvim",
})

-- ===================================================================
-- 2. WINDOW RULES (Fastfetch Terminal on Bottom-Left)
-- ===================================================================

hl.window_rule({
	match = {
		class = "kitty-fastfetch",
	},
	workspace = "1",
	float = true,
	size = { 1100, 750 },
	move = { 700, 400 }, -- Adjust Y coordinate (650) to match your screen resolution
})

hl.window_rule({
	name = "rofi-float",
	match = {
		class = "^[Rr]ofi$",
	},
	float = true,
})

hl.window_rule({
	name = "rofi-opacity",
	match = {
		class = "^[Rr]ofi$",
	},
	opacity = "0.6",
})

hl.layer_rule({
	name = "rofi-layer-effects",
	match = {
		namespace = "rofi",
	},
	blur = true,
	blur_popups = true,
})

hl.window_rule({
	name = "no-border-when-only-window",
	match = {
		float = false,
		workspace = "w[tv1]",
	},
	border_size = 0,
})
