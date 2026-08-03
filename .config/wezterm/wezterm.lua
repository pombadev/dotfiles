local wezterm = require "wezterm"
local action = wezterm.action
local config = wezterm.config_builder()

-- Original Core Settings
config.font_size = 10
config.enable_wayland = false
config.window_background_opacity = 0.8
config.enable_scroll_bar = true
config.front_end = "WebGpu"
config.enable_kitty_keyboard = true

-- UI Layout Tweaks
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.inactive_pane_hsb = {
    brightness = 0.3, -- Slightly brighter so background panes aren't totally lost
    saturation = 0.8
}

-- Slight padding to frame the terminal contents inside the window
config.window_padding = {
    left = 12,
    right = 12,
    top = 8,
    bottom = 8,
}

-- Extended Colors (Using your exact black and yellow)
config.colors = {
    background = "#000000",
    split = '#fff700',
    -- Styling the retro tab bar to match your split color
    tab_bar = {
        background = "#000000",
        active_tab = {
            bg_color = "#fff700", -- High contrast active tab
            fg_color = "#000000",
        },
        inactive_tab = {
            bg_color = "#000000",
            fg_color = "#666666",
        },
        inactive_tab_hover = {
            bg_color = "#222222",
            fg_color = "#fff700",
        },
    }
}

-- Original Tab & Title Formatting
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
    local index = ''
    if #tabs > 1 then
        index = string.format('[%d/%d] ', tab.tab_index + 1, #tabs)
    end
    return index .. tab.active_pane.title
end)

wezterm.on("format-tab-title", function(tab)
    local pane       = tab.active_pane
    local num_panes  = #tab.panes
    local pane_count = num_panes > 1 and string.format(" [%d] ", num_panes) or ""


    local process_name = pane.foreground_process_name or ""
    process_name = process_name:gsub("[/\\]+$", "")
    process_name = process_name:match("([^/\\]+)$") or process_name

    local cwd = "~"
    local cwd_uri = pane.current_working_dir

    if cwd_uri then
        cwd = cwd_uri.file_path
        cwd = cwd:gsub("[/\\]+$", "")
        cwd = cwd:match("([^/\\]+)$") or cwd
    end

    return string.format(" 󰉋 %s 󰆍 %s%s", cwd, process_name, pane_count)
end)

wezterm.on('update-status', function(window, pane)
    local meta = pane:get_metadata() or {}
    local overrides = window:get_config_overrides() or {}
    if meta.password_input then
        overrides.color_scheme = 'Red Alert'
    else
        overrides.color_scheme = nil
    end
    window:set_config_overrides(overrides)
end)

-- Original Keymaps
config.keys = {
    { key = "h",          mods = "CTRL|ALT",   action = action.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "v",          mods = "CTRL|ALT",   action = action.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = action.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'CTRL|SHIFT', action = action.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    mods = 'CTRL|SHIFT', action = action.ActivatePaneDirection 'Up' },
    { key = 'DownArrow',  mods = 'CTRL|SHIFT', action = action.ActivatePaneDirection 'Down' }
}

-- local mux = wezterm.mux

-- local config_dir = wezterm.config_dir
-- local window_size_config_path = config_dir .. "/" .. 'last_window_size'

-- wezterm.on('gui-startup', function()
--     wezterm.log_info "gui-startup"
--     local window_size_config_file = io.open(window_size_config_path, 'r')
--     if window_size_config_file ~= nil then
--         local _, _, width, height = string.find(window_size_config_file:read(), '(%d+),(%d+)')
--         mux.spawn_window { width = tonumber(width), height = tonumber(height) }
--         window_size_config_file:close()
--     else
--         local _, _, window = mux.spawn_window {}
--         window:gui_window():maximize()
--     end
-- end)

-- wezterm.on('window-resized', function(_, pane)
--     wezterm.log_info "window-resized"
--     local window_size_config_file = io.open(window_size_config_path, 'r')
--     if window_size_config_file == nil then
--         local tab_size = pane:tab():get_size()
--         local cols = tab_size['cols']
--         local rows = tab_size['rows'] + 2 -- Without adding the 2 here, the window doesn't maximize
--         local contents = string.format('%d,%d', cols, rows)
--         window_size_config_file = assert(io.open(window_size_config_path, 'w'))
--         window_size_config_file:write(contents)
--         window_size_config_file:close()
--     end
-- end)

return config
