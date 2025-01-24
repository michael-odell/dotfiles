return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" }
        },
        opts = {
            layout = {
                height = {
                    min = 30,  -- the default
                    max = 100
                },
                width = {
                    min = 30,  -- the default
                    max = 90,
                }

            },
        },

    }
}
