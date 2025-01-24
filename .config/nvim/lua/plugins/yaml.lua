return {
    {
        -- ref: https://github.com/someone-stole-my-name/yaml-companion.nvim
        "someone-stole-my-name/yaml-companion.nvim",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            { "nvim-lua/plenary.nvim" },
            { "nvim-telescope/telescope.nvim" },
        },
        config = function()
            require("telescope").load_extension("yaml_schema")
            local cfg = require("yaml-companion")
            cfg.setup({
                -- ref: https://github.com/someone-stole-my-name/yaml-companion.nvim?tab=readme-ov-file#%EF%B8%8F--configuration
                })
            require("lspconfig")["yamlls"].setup(cfg)
        end,
    }
}

