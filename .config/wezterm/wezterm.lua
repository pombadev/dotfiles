local wezterm = require "wezterm"

local config = {
  default_prog = {"zsh", "-l"},
  window_background_opacity = 0.9,
  font_size = 10,
  cursor_thickness = 0.1,
  enable_scroll_bar = true
}

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
