
-- From https://github.com/folke/which-key.nvim?tab=readme-ov-file#lazynvim
return {{
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {{
        "<leader>?",
        function()
            require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
    }},
}}
