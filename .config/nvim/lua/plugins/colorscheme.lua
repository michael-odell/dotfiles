return {
    "calind/selenized.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        -- Set colorscheme
        vim.cmd.colorscheme "selenized"

        -- Override Visual selection to have a subtle blue tint
        -- (distinguishes from indent guide background colors)
        vim.api.nvim_set_hl(0, "Visual", { bg = "#d5e5f5" })
    end,
}
