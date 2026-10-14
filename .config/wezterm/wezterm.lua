local wezterm = require "wezterm"
local action = wezterm.action
local config = wezterm.config_builder()

-- Original Core Settings
config.font_size = 10
-- config.enable_wayland = false
config.window_background_opacity = 0.8
config.enable_scroll_bar = true
-- config.front_end = "WebGpu"
config.enable_kitty_keyboard = true

config.ssh_domains = wezterm.default_ssh_domains()

-- UI Layout Tweaks
config.use_fancy_tab_bar = true
config.tab_bar_at_bottom = true
-- config.inactive_pane_hsb = {
--     brightness = 0.3, -- Slightly brighter so background panes aren't totally lost
--     saturation = 0.8
-- }

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

-- Fancy tab bar frame, styled to match the retro black/yellow look
config.window_frame = {
    font = wezterm.font { family = "Roboto", weight = "Bold" },
    active_titlebar_bg = "#000000",
    inactive_titlebar_bg = "#000000",
    active_titlebar_fg = "#fff700",
    inactive_titlebar_fg = "#666666",
    active_titlebar_border_bottom = "#fff700",
    button_fg = "#666666",
    button_bg = "#000000",
    button_hover_fg = "#000000",
    button_hover_bg = "#fff700",
}

function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end
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
    local process_name = basename(pane.foreground_process_name or "")
    local cwd = "~"
    local cwd_uri = pane.current_working_dir

    if cwd_uri then
        cwd = cwd_uri.file_path
        cwd = cwd:gsub("[/\\]+$", "")
        cwd = cwd:match("([^/\\]+)$") or cwd
    end

    return string.format(" 󰆍 %s on 󰉋 %s%s", process_name, cwd, pane_count)
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


-- Equalize all panes: each column gets equal width, each row within a column gets
-- equal height. Weights are column/row group counts so mixed split orientations
-- produce the expected N-ary equal-split layout.
--
-- WezTerm's AdjustPaneSize targets the nearest ancestor split in the internal tree,
-- which may differ from our reconstructed tree. We probe with +1 adjustments to
-- discover which boundary each pane actually targets, verifying by checking that
-- panes on BOTH sides of the intended boundary are affected.
local function equalize_tab(window)
    local tab = window:active_tab()
    if not tab then return end

    local initial_panes = tab:panes_with_info()
    if not initial_panes or #initial_panes <= 1 then
        return
    end

    local active_idx = 0
    for _, pi in ipairs(initial_panes) do
        if pi.is_active then
            active_idx = pi.index
        end
        if pi.is_zoomed then
            window:perform_action(action.TogglePaneZoomState, pi.pane)
        end
    end

    -- Reconstruct the binary split tree from pane positions.
    local function build_tree(ps)
        if #ps == 1 then
            return { type = "pane", pane = ps[1], width = ps[1].width, height = ps[1].height }
        end

        local xs = {}
        for _, p in ipairs(ps) do xs[p.left + p.width] = true end
        local xs_sorted = {}
        for x in pairs(xs) do table.insert(xs_sorted, x) end
        table.sort(xs_sorted)
        for _, x in ipairs(xs_sorted) do
            local left_ps, right_ps = {}, {}
            for _, p in ipairs(ps) do
                if p.left + p.width <= x then
                    table.insert(left_ps, p)
                elseif p.left >= x then
                    table.insert(right_ps, p)
                end
            end
            if #left_ps + #right_ps == #ps and #left_ps > 0 and #right_ps > 0 then
                local lc = build_tree(left_ps)
                local rc = build_tree(right_ps)
                return {
                    type = "vsplit",
                    left_child = lc,
                    right_child = rc,
                    width = lc.width + rc.width,
                    height = lc.height,
                }
            end
        end

        local ys = {}
        for _, p in ipairs(ps) do ys[p.top + p.height] = true end
        local ys_sorted = {}
        for y in pairs(ys) do table.insert(ys_sorted, y) end
        table.sort(ys_sorted)
        for _, y in ipairs(ys_sorted) do
            local top_ps, bot_ps = {}, {}
            for _, p in ipairs(ps) do
                if p.top + p.height <= y then
                    table.insert(top_ps, p)
                elseif p.top >= y then
                    table.insert(bot_ps, p)
                end
            end
            if #top_ps + #bot_ps == #ps and #top_ps > 0 and #bot_ps > 0 then
                local tc = build_tree(top_ps)
                local bc = build_tree(bot_ps)
                return {
                    type = "hsplit",
                    top_child = tc,
                    bot_child = bc,
                    width = tc.width,
                    height = tc.height + bc.height,
                }
            end
        end

        return { type = "pane", pane = ps[1], width = ps[1].width, height = ps[1].height }
    end

    local function far_pane(node)
        if node.type == "pane" then return node.pane end
        if node.type == "vsplit" then return far_pane(node.right_child) end
        return far_pane(node.bot_child)
    end

    -- Collect all leaf panes in a subtree.
    local function collect_panes(node, out)
        out = out or {}
        if node.type == "pane" then
            table.insert(out, node.pane)
        elseif node.type == "vsplit" then
            collect_panes(node.left_child, out)
            collect_panes(node.right_child, out)
        elseif node.type == "hsplit" then
            collect_panes(node.top_child, out)
            collect_panes(node.bot_child, out)
        end
        return out
    end

    local function count_columns(node)
        if node.type == "vsplit" then
            return count_columns(node.left_child) + count_columns(node.right_child)
        end
        return 1
    end

    local function count_rows(node)
        if node.type == "hsplit" then
            return count_rows(node.top_child) + count_rows(node.bot_child)
        end
        return 1
    end

    -- Snapshot pane sizes keyed by index.
    local function snapshot()
        local s = {}
        for _, pi in ipairs(tab:panes_with_info()) do
            s[pi.index] = { width = pi.width, height = pi.height }
        end
        return s
    end

    -- Probe from a candidate pane to see if it targets the intended boundary.
    -- Returns "grow"/"shrink"/nil indicating the effect of pos_dir on the
    -- first-child side of the intended boundary.
    local function probe(candidate_idx, pos_dir, neg_dir, prop, verify_idx)
        local before = snapshot()
        window:perform_action(action.ActivatePaneByIndex(candidate_idx), tab:active_pane())
        window:perform_action(action.AdjustPaneSize({ pos_dir, 1 }), tab:active_pane())
        local after = snapshot()

        local cand_delta = after[candidate_idx][prop] - before[candidate_idx][prop]
        local verify_delta = after[verify_idx][prop] - before[verify_idx][prop]

        -- Undo the probe
        window:perform_action(action.AdjustPaneSize({ neg_dir, 1 }), tab:active_pane())

        if cand_delta ~= 0 and verify_delta ~= 0 and cand_delta ~= verify_delta then
            return cand_delta > 0 and "grow" or "shrink"
        end
        return nil
    end

    -- Try to adjust a boundary using probe-and-discover.
    local function try_adjust(candidates, delta, pos_dir, neg_dir, prop)
        for _, c in ipairs(candidates) do
            local result = probe(c.index, pos_dir, neg_dir, prop, c.verify)
            if result then
                window:perform_action(action.ActivatePaneByIndex(c.index), tab:active_pane())
                if c.side == "left" then
                    if result == "grow" then
                        if delta > 0 then
                            window:perform_action(action.AdjustPaneSize({ pos_dir, delta }), tab:active_pane())
                        else
                            window:perform_action(action.AdjustPaneSize({ neg_dir, -delta }), tab:active_pane())
                        end
                    else
                        if delta > 0 then
                            window:perform_action(action.AdjustPaneSize({ neg_dir, delta }), tab:active_pane())
                        else
                            window:perform_action(action.AdjustPaneSize({ pos_dir, -delta }), tab:active_pane())
                        end
                    end
                else
                    if result == "grow" then
                        if delta > 0 then
                            window:perform_action(action.AdjustPaneSize({ neg_dir, delta }), tab:active_pane())
                        else
                            window:perform_action(action.AdjustPaneSize({ pos_dir, -delta }), tab:active_pane())
                        end
                    else
                        if delta > 0 then
                            window:perform_action(action.AdjustPaneSize({ pos_dir, delta }), tab:active_pane())
                        else
                            window:perform_action(action.AdjustPaneSize({ neg_dir, -delta }), tab:active_pane())
                        end
                    end
                end
                return true
            end
        end
        return false
    end

    -- Process one boundary at a time, re-evaluating layout after each adjustment.
    for _ = 1, #initial_panes - 1 do
        local ps = tab:panes_with_info()
        local tree = build_tree(ps)

        local queue = { tree }
        local adjusted = false
        while #queue > 0 and not adjusted do
            local node = table.remove(queue, 1)
            if node.type == "vsplit" then
                local lc, rc = node.left_child, node.right_child
                local l_cols = count_columns(lc)
                local r_cols = count_columns(rc)
                local total = lc.width + rc.width
                local target_l = math.floor(total * l_cols / (l_cols + r_cols))
                local delta = target_l - lc.width
                if delta ~= 0 then
                    local left_panes = collect_panes(lc)
                    local right_panes = collect_panes(rc)
                    local right_far = far_pane(rc)
                    local left_far = far_pane(lc)
                    local candidates = {}
                    for _, p in ipairs(left_panes) do
                        table.insert(candidates, { index = p.index, side = "left", verify = right_far.index })
                    end
                    for _, p in ipairs(right_panes) do
                        table.insert(candidates, { index = p.index, side = "right", verify = left_far.index })
                    end
                    adjusted = try_adjust(candidates, delta, "Right", "Left", "width")
                end
                if not adjusted then
                    table.insert(queue, lc)
                    table.insert(queue, rc)
                end
            elseif node.type == "hsplit" then
                local tc, bc = node.top_child, node.bot_child
                local t_rows = count_rows(tc)
                local b_rows = count_rows(bc)
                local total = tc.height + bc.height
                local target_t = math.floor(total * t_rows / (t_rows + b_rows))
                local delta = target_t - tc.height
                if delta ~= 0 then
                    local top_panes = collect_panes(tc)
                    local bot_panes = collect_panes(bc)
                    local bot_far = far_pane(bc)
                    local top_far = far_pane(tc)
                    local candidates = {}
                    for _, p in ipairs(top_panes) do
                        table.insert(candidates, { index = p.index, side = "left", verify = bot_far.index })
					end
                    for _, p in ipairs(bot_panes) do
                        table.insert(candidates, { index = p.index, side = "right", verify = top_far.index })
                    end
                    adjusted = try_adjust(candidates, delta, "Down", "Up", "height")
                end
                if not adjusted then
                    table.insert(queue, tc)
                    table.insert(queue, bc)
                end
            end
        end
        if not adjusted then break end
    end

    window:perform_action(action.ActivatePaneByIndex(active_idx), tab:active_pane())
end

-- Split and equalize all panes in the current tab
local function split_and_equalize(direction)
    return wezterm.action_callback(function(window, pane)
        if direction == "vertical" then
            window:perform_action(action.SplitPane({ direction = "Down" }), pane)
        else
            window:perform_action(action.SplitPane({ direction = "Right" }), pane)
        end
        equalize_tab(window)
    end)
end

wezterm.on("augment-command-palette", function(window, pane)
    return {
        {
            brief = "Equalize all panes",
            action = wezterm.action_callback(function(win) equalize_tab(win) end),
        },
    }
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
