-- vim-table-mode: map table commands directly via <Plug> mappings so they
-- work without toggling table mode on first. Table mode's always_active
-- option has a bug where it only enables the insert-mode | trigger but
-- skips all other mappings, so we set them up here instead.
--
-- See :help table-mode-mappings for the full list of <Plug> names.
local map = function(lhs, plug, desc)
    vim.keymap.set("n", lhs, plug, { buffer = true, desc = desc })
end

map(",tr",  "<Plug>(table-mode-realign)",              "Table: realign")
map(",tdd", "<Plug>(table-mode-delete-row)",           "Table: delete row")
map(",tdc", "<Plug>(table-mode-delete-column)",        "Table: delete column")
map(",tiC", "<Plug>(table-mode-insert-column-before)", "Table: insert column before")
map(",tic", "<Plug>(table-mode-insert-column-after)",  "Table: insert column after")
map(",ts",  "<Plug>(table-mode-sort)",                 "Table: sort column")

-- init.lua keeps formatoptions '+t' (auto-wrap) for markdown so prose still
-- wraps at textwidth. That breaks table rows, which must stay on one line.
-- Drop 't' while the cursor is on a table row/border, restore it otherwise.
-- table-mode has no hook for this itself (its own auto-align uses CursorHold,
-- which is too late -- wrap-while-typing happens synchronously per
-- keystroke), but its row/border detection is reused here instead of a
-- hand-rolled regex, so it stays correct if table_mode_separator/corner ever
-- change.
vim.api.nvim_create_autocmd({ "InsertEnter", "CursorMovedI" }, {
    buffer = 0,
    callback = function()
        local in_table = vim.fn["tablemode#table#IsTable"](vim.fn.line(".")) == 1
        if in_table then
            vim.opt_local.formatoptions:remove("t")
        else
            vim.opt_local.formatoptions:append("t")
        end
    end,
})
