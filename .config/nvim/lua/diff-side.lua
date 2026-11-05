-- Make it obvious which side of a fugitive diff each window is.
--
-- A diff window's side comes from its buffer name:
--
-- - `fugitive://<gitdir>//<id>/<path>` is a git object; `<id>` is a commit sha, or a
--   stage: `0` index, `1` merge ancestor, `2` ours, `3` theirs.
-- - A plain file buffer sitting in a diff next to one of those is the worktree.
--
-- Three independent indicators, each switchable in `M.opts` or toggled with
-- `<leader>W` / `<leader>G` / `<leader>S`:
--
-- - `statusline`: a colored label in lualine (see `plugins/status-line.lua`).
-- - `winbar`: the same label as a bar across the top of the window.
-- - `gutter`: tints the sign/number columns.
--
-- Colors are the terminal's ANSI colors, which selenized publishes as
-- `vim.g.terminal_color_N`, so they follow the light/dark colorscheme.
local M = {}

M.opts = { statusline = false, winbar = true, gutter = true }

-- ANSI color index: 1 red, 2 green, 3 yellow, 4 blue, 5 magenta, 6 cyan.
local kinds = {
    worktree = { label = 'WORKTREE', ansi = 2 },
    index = { label = 'INDEX', ansi = 3 },
    commit = { label = 'BASE', ansi = 4 },
    ancestor = { label = 'ANCESTOR', ansi = 6 },
    ours = { label = 'OURS', ansi = 5 },
    theirs = { label = 'THEIRS', ansi = 1 },
}

local stages = { ['0'] = 'index', ['1'] = 'ancestor', ['2'] = 'ours', ['3'] = 'theirs' }

local function fugitive_id(buf)
    return vim.api.nvim_buf_get_name(buf):match('^fugitive://.-//(%w+)/')
end

-- Returns `{ kind = 'worktree', label = 'WORKTREE' }` etc. for a diff window, else nil.
function M.side(win)
    if not win or not vim.api.nvim_win_is_valid(win) or not vim.wo[win].diff then
        return nil
    end
    local id = fugitive_id(vim.api.nvim_win_get_buf(win))
    if id then
        local kind = stages[id] or 'commit'
        local label = kinds[kind].label
        if kind == 'commit' then
            -- `review` knows the name it was given; otherwise show the short sha.
            label = label .. ' ' .. (vim.g.review_base or id:sub(1, 7))
        end
        return { kind = kind, label = label }
    end
    -- Only call it the worktree when the diff really involves a git object.
    for _, other in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_win_get_tabpage(win))) do
        if other ~= win and vim.wo[other].diff and fugitive_id(vim.api.nvim_win_get_buf(other)) then
            return { kind = 'worktree', label = kinds.worktree.label }
        end
    end
    return nil
end

-- Blend `fg` toward `bg` by `amount` (0..1), both as 0xRRGGBB integers.
local function blend(fg, bg, amount)
    local out = 0
    for shift = 16, 0, -8 do
        local a = bit.band(bit.rshift(fg, shift), 0xff)
        local b = bit.band(bit.rshift(bg, shift), 0xff)
        out = out + bit.lshift(math.floor(b + (a - b) * amount + 0.5), shift)
    end
    return out
end

local function define_highlights()
    local normal = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })
    for kind, info in pairs(kinds) do
        local color = vim.g['terminal_color_' .. info.ansi]
        if color and normal.bg then
            local rgb = tonumber(color:sub(2), 16)
            local name = 'DiffSide' .. kind
            -- Label: solid color with the normal background as text, like lualine's mode.
            vim.api.nvim_set_hl(0, name, { fg = normal.bg, bg = rgb, bold = true })
            -- Gutter: dim tint of the color, with the color itself for line numbers.
            vim.api.nvim_set_hl(0, name .. 'Gutter', { fg = rgb, bg = blend(rgb, normal.bg, 0.3) })
        end
    end
end

-- Set window option `name` to `value`, or clear it when `value` is nil -- but only
-- if we set it, so other uses of the option survive.
local function apply(win, name, value)
    local mark = 'diff_side_' .. name
    if value then
        vim.wo[win][name] = value
        vim.w[win][mark] = true
    elseif vim.w[win][mark] then
        vim.wo[win][name] = ''
        vim.w[win][mark] = nil
    end
end

-- Apply (or clear) the winbar and gutter for every window.
local function refresh()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local side = M.side(win)
        local winbar, gutter
        if side and M.opts.winbar then
            -- End on Normal so the rest of the bar isn't WinBar/WinBarNC (black in selenized).
            winbar = ('%%#DiffSide%s# %s %%#Normal#'):format(side.kind, side.label)
        end
        if side and M.opts.gutter then
            local group = 'DiffSide' .. side.kind .. 'Gutter'
            gutter = ('SignColumn:%s,LineNr:%s,CursorLineNr:%s,FoldColumn:%s'):format(group, group, group, group)
        end
        apply(win, 'winbar', winbar)
        apply(win, 'winhighlight', gutter)
    end
end

-- Flip one of `M.opts` and redraw.
function M.toggle(name)
    M.opts[name] = not M.opts[name]
    refresh()
    pcall(function() require('lualine').refresh() end)
    vim.notify(('diff-side %s: %s'):format(name, M.opts[name] and 'on' or 'off'))
end

function M.setup(opts)
    M.opts = vim.tbl_extend('force', M.opts, opts or {})
    define_highlights()
    local group = vim.api.nvim_create_augroup('diff-side', {})
    vim.api.nvim_create_autocmd('ColorScheme', {
        group = group,
        callback = function()
            define_highlights()
            refresh()
        end,
    })
    -- Scheduled: buffer names and 'diff' are still settling when these fire.
    vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter', 'WinClosed', 'OptionSet' }, {
        group = group,
        callback = function(event)
            if event.event == 'OptionSet' and event.match ~= 'diff' then
                return
            end
            vim.schedule(refresh)
        end,
    })

    -- Temporary, while choosing which indicators to keep.
    vim.keymap.set('n', '<leader>W', function() M.toggle('winbar') end, { desc = 'Diff side: toggle winbar' })
    vim.keymap.set('n', '<leader>G', function() M.toggle('gutter') end, { desc = 'Diff side: toggle gutter' })
    vim.keymap.set('n', '<leader>S', function() M.toggle('statusline') end, { desc = 'Diff side: toggle statusline' })
end

return M
