return {
    {
        "hrsh7th/cmp-nvim-lsp"
    },
    -- At some point, this looks like a successor to nvim-cmp: https://github.com/saghen/blink.cmp?tab=readme-ov-file
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
        }
    },
}
