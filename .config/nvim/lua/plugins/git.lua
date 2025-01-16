return {
    { "tpope/vim-fugitive" },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            -- ref: https://github.com/lewis6991/gitsigns.nvim?tab=readme-ov-file#installation--usage
            require('gitsigns').setup {
                signs = {
                    add = { text = '+' },
                    change = { text = '~' },
                },
                signs_staged = {
                    add = { text = '+' },
                    change = { text = '~' },
                },
                numhl = true,
                linehl = false,
                word_diff = true,
            }
        end,
    },
}
