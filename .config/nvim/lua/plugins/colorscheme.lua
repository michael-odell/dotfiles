return {
    "calind/selenized.nvim",
    priority = 1000,
    lazy = false,
    config = function()
        -- Show changed words in diffs as DiffText-colored (yellow) foreground text on the
        -- DiffChange background, instead of a solid yellow block.  Reapplied whenever the
        -- colorscheme reloads (e.g. light/dark switch).
        vim.api.nvim_create_autocmd("ColorScheme", {
            group = vim.api.nvim_create_augroup("subtle-diff-text", {}),
            pattern = "selenized",
            callback = function()
                local text = vim.api.nvim_get_hl(0, { name = "DiffText", link = false })
                local change = vim.api.nvim_get_hl(0, { name = "DiffChange", link = false })
                vim.api.nvim_set_hl(0, "DiffText", { fg = text.bg or text.fg, bg = change.bg })
            end,
        })

        -- Set colorscheme
        vim.cmd.colorscheme "selenized"

        -- Override Visual selection to have a subtle blue tint
        -- (distinguishes from indent guide background colors)
        vim.api.nvim_set_hl(0, "Visual", { bg = "#d5e5f5" })
    end,
}
