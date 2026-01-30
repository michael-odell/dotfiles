-- ref: https://github.com/nvim-treesitter/nvim-treesitter
return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",  -- Required: main branch has the new API for Neovim 0.11+
        lazy = false,     -- Required: this plugin doesn't support lazy loading
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install({
                "bash",
                "c",
                "cpp",
                "cue",
                "dockerfile",
                "go",
                "groovy",
                "hcl",
                "json",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "python",
                "ruby",
                "terraform",
                "yaml",
            })
        end,
    },
}
