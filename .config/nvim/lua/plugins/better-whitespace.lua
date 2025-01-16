return {{
    "ntpeters/vim-better-whitespace",
    init = function()
        vim.g.show_spaces_that_precede_tabs = 1
        vim.g.better_whitespace_enabled = 1
    end,
}}
