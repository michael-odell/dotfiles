return {
    'nathanaelkane/vim-indent-guides',
    init = function()
        vim.g.indent_guides_auto_colors = 1
        --" The plugin claims to only have 'very basic' support for term.  But it also seems to think my
        --" full-gui-color terminal uses gui colors.
        --autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=grey22
        --autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd guibg=grey25
        vim.g.indent_guides_color_change_percent = 3 --"default is 10
        -- vim.g.indent_guides_guide_size = 1
        vim.g.indent_guides_start_level = 1
        vim.g.indent_guides_enable_on_vim_startup = 1

    end,
}
