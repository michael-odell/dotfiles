return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    opts = function()
        return {
            options = {
                theme = "solarized"
            }
        }
    end,
}
