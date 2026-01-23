return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    opts = function()
        return {
            options = {
                theme = "solarized"
            },
            -- ref: :h lualine or https://github.com/nvim-lualine/lualine.nvim
            sections = {
                lualine_c = {
                    {
                        'filename',
                        path = 1
                    }
                }
            },
            inactive_sections = {
                lualine_c = {
                    {
                        'filename',
                        path = 1
                    }
                }
            },
        }
    end,
}
