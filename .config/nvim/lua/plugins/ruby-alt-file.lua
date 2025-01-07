return {{
    "tpope/vim-projectionist",
    init = function()
        vim.cmd('noremap <A-o> <esc>:A<CR>')
        vim.cmd('map <leader>o <esc>:A<CR>')
    end,
}, {
    "tpope/vim-rake",
}}
