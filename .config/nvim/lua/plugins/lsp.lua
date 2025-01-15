return {
    {
        "williamboman/mason.nvim"
    },
    {
        "williamboman/mason-lspconfig.nvim"
    },
    {
        "neovim/nvim-lspconfig"
    },
    {
        "hrsh7th/cmp-nvim-lsp"
    },
    {
        "hrsh7th/nvim-cmp"
    },
--    {
--        "williamboman/mason.nvim",
--        config = function()
--            require("mason").setup()
--        end
--    },
--    {
--        "williamboman/mason-lspconfig.nvim",
--
--        -- ref: help mason-lspconfig-automatic-server-setup
--        config = function()
--            require("mason-lspconfig").setup {
--                ensure_installed = { "shfmt", "shellcheck", "bashls"}
--            }
--
--            require("mason-lspconfig").setup_handlers {
--                function (server_name) -- default handler
--                    require("lspconfig")[server_name].setup {}
--                end,
--            }
--
--        end
--    },
}


