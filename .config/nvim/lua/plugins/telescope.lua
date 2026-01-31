return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" }
        },
        opts = {
            defaults = {
                layout_config = {
                    height = 0.9,
                    width = 0.9,
                },
            },
        },
        config = function()
            require('telescope').setup({
                    defaults = {
                        initial_mode = 'normal',
                        layout_strategy = 'vertical',
                        winblend = 5,
                        layout_config = {
                            width = 0.9,
                            height = 0.9,
                            vertical = {
                                preview_cutoff = 20,
                                preview_height = 0.6,
                            },
                        },
                        borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
                    },
                })
        end
    }
}
