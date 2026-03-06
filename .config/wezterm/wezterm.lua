local wezterm = require "wezterm"

-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28

-- -- or, changing the font size and color scheme.
-- config.font_size = 10

config.enable_wayland = false
config.window_background_opacity = 0.7
config.window_decorations = "NONE"


-- custom keymap
config.keys = {
  {
    key = "h",
    mods = "CTRL|ALT",
    action = wezterm.action.SplitHorizontal {domain = "CurrentPaneDomain"}
  },
  {
    key = "v",
    mods = "CTRL|ALT",
    action = wezterm.action.SplitVertical {domain = "CurrentPaneDomain"}
  },
  {
    key = "d",
    mods = "CTRL|ALT",
    action = wezterm.action.PopKeyTable
  }
}

return config
