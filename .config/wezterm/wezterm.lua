local wezterm = require "wezterm"

local action = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
-- config.initial_cols = 120
-- config.initial_rows = 28

-- -- or, changing the font size and color scheme.
-- config.font_size = 10

config.enable_wayland = false
config.window_background_opacity = 0.9
-- config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.enable_scroll_bar = true
-- config.enable_wayland = true
config.front_end = "WebGpu"
config.enable_kitty_keyboard = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
-- config.enable_tab_bar = true

config.inactive_pane_hsb = {
    brightness = 0.2
}

wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
    local index = ''
    if #tabs > 1 then
        index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
    end

    return index .. tab.active_pane.title
end)

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local tab_index = tab.tab_index + 1

    local process_name = pane.foreground_process_name or ""
    process_name = process_name:gsub('[/\\]+$', '') -- strip trailing slashes
    process_name = process_name:match('([^/\\]+)$') or process_name

    local cwd = ""
    local cwd_uri = pane.current_working_dir
    if cwd_uri then
        cwd = cwd_uri.file_path
        cwd = cwd:gsub('[/\\]+$', '') -- strip trailing slashes (this fixes the full path bug!)
        cwd = cwd:match('([^/\\]+)$') or cwd
    end
    if cwd == "" then
        cwd = "~"
    end

    local title_text = string.format(' %d: %s @ %s ', tab_index, cwd, process_name)

    return title_text
end)

config.colors = {
    background = "#000000",
    split = '#fff700'
}

-- custom keymap
config.keys = {{
    key = "h",
    mods = "CTRL|ALT",
    action = action.SplitHorizontal {
        domain = "CurrentPaneDomain"
    }
}, {
    key = "v",
    mods = "CTRL|ALT",
    action = action.SplitVertical {
        domain = "CurrentPaneDomain"
    }
}, {
    key = 'LeftArrow',
    mods = 'CTRL|SHIFT',
    action = action.ActivatePaneDirection 'Left'
}, {
    key = 'RightArrow',
    mods = 'CTRL|SHIFT',
    action = action.ActivatePaneDirection 'Right'
}, {
    key = 'UpArrow',
    mods = 'CTRL|SHIFT',
    action = action.ActivatePaneDirection 'Up'
}, {
    key = 'DownArrow',
    mods = 'CTRL|SHIFT',
    action = action.ActivatePaneDirection 'Down'
}}

return config
