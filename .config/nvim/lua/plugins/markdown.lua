-- ref: https://github.com/MeanderingProgrammer/render-markdown.nvim
-- Structural highlighting for markdown: rendered headings, list bullets,
-- table borders/alignment, code block borders. Complements vim-table-mode
-- (which does the actual table editing/alignment/sorting).
return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {},
}
