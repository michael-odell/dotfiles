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
