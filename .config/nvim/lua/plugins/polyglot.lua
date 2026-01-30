return {
    "sheerun/vim-polyglot",
    init = function()
        vim.g.vim_json_syntax_conceal = 0
        vim.g.polyglot_disabled = { 'yaml', 'bash', 'ruby', 'cue' }
    end,
}
