return {
    "mhinz/vim-signify",
    init = function()
        vim.g.signify_vcs_list = { 'hg', 'git' }
    end,
}
