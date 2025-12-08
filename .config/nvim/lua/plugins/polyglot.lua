return {
    "sheerun/vim-polyglot",
    init = function()
        vim.g.vim_json_syntax_conceal = 0
        vim.g.polyglot_disabled = { 'yaml', 'bash', 'ruby', 'cue' }

        vim.g.show_spaces_that_precede_tabs = 1
        vim.g.better_whitespace_enabled = 1
    end,
}
