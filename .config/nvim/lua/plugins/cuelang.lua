-- ref: https://github.com/cue-lang/cue/wiki/LSP:-Getting-started
-- Cue uses treesitter for highlighting; ensure filetype detection works
return {
    {
        "nvim-treesitter/nvim-treesitter",
        init = function()
            vim.filetype.add({
                extension = {
                    cue = "cue",
                },
            })
        end,
    },
}
