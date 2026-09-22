return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = "VeryLazy",
    opts = function()
        -- Built from the running selenized palette (exposed as _G.selenized.colors)
        -- rather than the unrelated "solarized" theme lualine ships. The git branch/
        -- diff/diagnostics segments in section b get their colors (yellow/red/green,
        -- etc.) from selenized's own highlight groups (GitSignsAdd and friends), which
        -- are tuned against selenized's bg_0/bg_1 -- pairing them with a solarized
        -- background made those colors low-contrast and hard to read.
        local colors = _G.selenized.colors
        -- Selenized dark's bg_1, used for the filename bar so it visibly contrasts
        -- with selenized light instead of blending into it like a same-family tan
        -- (bg_2) did; fg_0 is dark's matching light foreground for that background.
        local dark = _G.selenized.color_scheme.dark
        local theme = {
            normal = {
                a = { fg = colors.bg_1, bg = colors.blue, gui = 'bold' },
                -- branch/diff/diagnostics all share this one light bg_1 background --
                -- same color 'y' (the progress %) uses -- so they read as one block
                -- with arrow dividers between components, instead of a patchwork of
                -- component-level colors that strips the dividers next to any one
                -- of them that differs from the others.
                b = { fg = colors.fg_1, bg = colors.bg_1 },
                c = { fg = dark.fg_0, bg = dark.bg_1 },
            },
            insert = { a = { fg = colors.bg_1, bg = colors.green, gui = 'bold' } },
            visual = { a = { fg = colors.bg_1, bg = colors.magenta, gui = 'bold' } },
            replace = { a = { fg = colors.bg_1, bg = colors.red, gui = 'bold' } },
            inactive = {
                a = { fg = colors.dim_0, bg = colors.bg_1 },
                b = { fg = colors.fg_1, bg = colors.bg_1 },
                c = { fg = dark.fg_0, bg = dark.bg_1 },
            },
        }
        return {
            options = {
                theme = theme,
                -- Explicit powerline glyphs (U+E0B0-U+E0B3) for the angular dividers.
                -- Written via nr2char rather than literal characters, since those PUA
                -- codepoints don't survive as plain text reliably.
                component_separators = { left = vim.fn.nr2char(0xe0b1), right = vim.fn.nr2char(0xe0b3) },
                section_separators = { left = vim.fn.nr2char(0xe0b0), right = vim.fn.nr2char(0xe0b2) },
            },
            -- ref: :h lualine or https://github.com/nvim-lualine/lualine.nvim
            sections = {
                lualine_c = {
                    {
                        'filename',
                        path = 1
                    }
                }
            },
            inactive_sections = {
                lualine_c = {
                    {
                        'filename',
                        path = 1
                    }
                }
            },
        }
    end,
}
