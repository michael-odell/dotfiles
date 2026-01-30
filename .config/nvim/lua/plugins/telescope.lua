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
    }
}
