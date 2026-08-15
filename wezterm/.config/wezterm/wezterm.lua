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

config.font_size = 14.0
config.line_height = 1.08

-- Slight transparency gives it a modern feel without hurting readability.
config.window_background_opacity = 0.80
config.macos_window_background_blur = 30

config.window_padding = {
  left = 12,
  right = 12,
  top = 10,
  bottom = 10,
}

-- Clean macOS window
config.window_decorations = "RESIZE"

-- Don't ask for confirmation when closing.
config.window_close_confirmation = "NeverPrompt"

-- ─────────────────────────────────────────────────────────────
-- Cursor
-- ─────────────────────────────────────────────────────────────

config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- ─────────────────────────────────────────────────────────────
-- Tabs
-- ─────────────────────────────────────────────────────────────

config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
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
    mods = "CMD",
    action = act.SpawnTab("CurrentPaneDomain"),
  },
  {
    key = "w",
    mods = "CMD",
    action = act.CloseCurrentPane({ confirm = false }),
  },

  -- Splits
  {
    key = "d",
    mods = "CMD",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "d",
    mods = "CMD|SHIFT",
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
    mods = "CMD",
    action = act.IncreaseFontSize,
  },
  {
    key = "-",
    mods = "CMD",
    action = act.DecreaseFontSize,
  },
  {
    key = "0",
    mods = "CMD",
    action = act.ResetFontSize,
  },

  -- Command palette
  {
    key = "p",
    mods = "CMD|SHIFT",
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
    mods = "CMD|SHIFT",
    action = act.Search("CurrentSelectionOrEmptyString"),
  },
}

-- ─────────────────────────────────────────────────────────────
-- Mouse
-- ─────────────────────────────────────────────────────────────

config.mouse_bindings = {
  -- CMD + click opens links.
  {
    event = {
      Up = {
        streak = 1,
        button = "Left",
      },
    },
    mods = "CMD",
    action = act.OpenLinkAtMouseCursor,
  },
}

-- ─────────────────────────────────────────────────────────────
-- Misc
-- ─────────────────────────────────────────────────────────────

-- Faster startup / rendering.
config.front_end = "WebGpu"

-- 120 FPS makes scrolling noticeably smoother on ProMotion displays.
config.max_fps = 120

-- Native macOS fullscreen instead of WezTerm's custom fullscreen.
config.native_macos_fullscreen_mode = true

return config
