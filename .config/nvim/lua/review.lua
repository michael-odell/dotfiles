-- Review mode for the `review` script (~/bin/review).
--
-- Every file in the argument list is shown as a fugitive diff against the base
-- (`$REVIEW_BASE`), working tree on the right.  `<leader>n` / `<leader>p` step
-- through the files (`<leader>p` shadows the `diffput` mapping; `dp` still works).
-- The first visit to a file starts at the top; revisits keep the cursor.
local M = {}

local seen = {}

-- Replace all windows with a diff of the current buffer against the base, then put
-- the cursor in the `side` pane (`'left'` is the base, `'right'` the worktree).
local function open(side)
    local buf = vim.api.nvim_get_current_buf()
    if not seen[buf] then
        seen[buf] = true
        vim.cmd('1')
    end
    vim.cmd.diffoff({ bang = true })
    vim.cmd.only()
    vim.cmd('leftabove Gvdiffsplit ' .. vim.g.review_base)
    -- Gvdiffsplit doesn't reliably leave the cursor in either pane.
    local win = side == 'left' and vim.fn.win_getid(1) or vim.fn.bufwinid(buf)
    if win ~= -1 then
        vim.api.nvim_set_current_win(win)
    end
end

-- Move through the argument list with `cmd` (`next` or `previous`), then diff,
-- staying in the pane the cursor was in.
local function step(cmd)
    local side = vim.api.nvim_buf_get_name(0):match('^fugitive:') and 'left' or 'right'
    local ok, err = pcall(vim.cmd, cmd)
    if not ok then
        -- e.g. "E165: Cannot go beyond last file"
        vim.notify(err:match('E%d+:.*') or err, vim.log.levels.WARN)
        return
    end
    open(side)
end

function M.start()
    vim.g.review_base = vim.env.REVIEW_BASE or 'main'
    -- Gutter signs relative to the base, not the index (second argument: all buffers).
    require('gitsigns').change_base(vim.g.review_base, true)
    vim.keymap.set('n', '<leader>n', function() step('next') end, { desc = 'Review: next file' })
    vim.keymap.set('n', '<leader>p', function() step('previous') end, { desc = 'Review: previous file' })
    open('right')
end

return M
