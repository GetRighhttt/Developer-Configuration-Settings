local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ─────────────────────────────────────────────────────────────
-- Appearance
-- ─────────────────────────────────────────────────────────────

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font_with_fallback({
	{
		family = "JetBrains Mono",
		weight = "Bold",
	},
	"Symbols Nerd Font Mono",
})

config.font_size = 16.0
config.line_height = 1.08

-- Slight transparency gives it a modern feel without hurting readability.
config.window_background_opacity = 0.95

config.window_padding = {
	left = 14,
	right = 14,
	top = 10,
	bottom = 10,
}

-- Keep the window chrome minimal.
config.window_decorations = "RESIZE"

-- Don't ask for confirmation when closing.
config.window_close_confirmation = "NeverPrompt"

-- ─────────────────────────────────────────────────────────────
-- Cursor
-- ─────────────────────────────────────────────────────────────

config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 250
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- ─────────────────────────────────────────────────────────────
-- Tabs
-- ─────────────────────────────────────────────────────────────

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false

config.tab_bar_at_bottom = false
config.tab_max_width = 28

-- Custom minimalist tab titles.
wezterm.on("format-tab-title", function(tab)
	local title = tab.active_pane.title

	-- Keep paths/commands from taking over the entire tab bar.
	if #title > 24 then
		title = wezterm.truncate_right(title, 21) .. "..."
	end

	if tab.is_active then
		return {
			{ Text = "  ●  " .. title .. "  " },
		}
	end

	return {
		{ Text = "     " .. title .. "  " },
	}
end)

-- ─────────────────────────────────────────────────────────────
-- Terminal behavior
-- ─────────────────────────────────────────────────────────────

config.scrollback_lines = 10000

config.enable_scroll_bar = false

config.adjust_window_size_when_changing_font_size = false

config.audible_bell = "Disabled"

-- Allow applications such as Neovim to detect more key combinations.
config.enable_kitty_keyboard = true

-- ─────────────────────────────────────────────────────────────
-- Keybindings
-- ─────────────────────────────────────────────────────────────

local act = wezterm.action

config.keys = {
	-- Tabs
	{
		key = "t",
		mods = "CTRL",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		key = "w",
		mods = "CTRL",
		action = act.CloseCurrentPane({ confirm = false }),
	},

	-- Splits
	{
		key = "d",
		mods = "CTRL",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "CTRL|SHIFT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	-- Navigate panes with Ctrl + Shift + hjkl
	{
		key = "h",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "j",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = "k",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = act.ActivatePaneDirection("Right"),
	},

	-- Font size
	{
		key = "=",
		mods = "CTRL",
		action = act.IncreaseFontSize,
	},
	{
		key = "-",
		mods = "CTRL",
		action = act.DecreaseFontSize,
	},
	{
		key = "0",
		mods = "CTRL",
		action = act.ResetFontSize,
	},

	-- Command palette
	{
		key = "p",
		mods = "CTRL|SHIFT",
		action = act.ActivateCommandPalette,
	},

	-- Quick select URLs, hashes, paths, etc.
	{
		key = "Space",
		mods = "CTRL|SHIFT",
		action = act.QuickSelect,
	},

	-- Search terminal history
	{
		key = "f",
		mods = "CTRL|SHIFT",
		action = act.Search("CurrentSelectionOrEmptyString"),
	},
}

-- ─────────────────────────────────────────────────────────────
-- Mouse
-- ─────────────────────────────────────────────────────────────

config.mouse_bindings = {
	-- Ctrl + click opens links.
	{
		event = {
			Up = {
				streak = 1,
				button = "Left",
			},
		},
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

-- ─────────────────────────────────────────────────────────────
-- Misc
-- ─────────────────────────────────────────────────────────────

-- Faster startup / rendering.
-- Avoid the Flatpak Vulkan/WebGPU surface failure seen on this Fedora setup.
config.front_end = "OpenGL"

-- 120 FPS provides smooth scrolling on high refresh rate displays.
config.max_fps = 120

return config
