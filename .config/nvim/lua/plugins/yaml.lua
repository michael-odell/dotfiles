return {
    {
        -- ref: https://github.com/someone-stole-my-name/yaml-companion.nvim
        "someone-stole-my-name/yaml-companion.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        ft = { "yaml", "yml" },
        config = function()
            require("telescope").load_extension("yaml_schema")
            require("yaml-companion").setup({})
        end,
    },
}
