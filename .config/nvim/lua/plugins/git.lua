return {
    {
        "tpope/vim-fugitive",
        lazy = false,
    },
    {
        "lewis6991/gitsigns.nvim",
        lazy = false,
        config = function()
            -- ref: https://github.com/lewis6991/gitsigns.nvim?tab=readme-ov-file#installation--usage
            require('gitsigns').setup {
                signs = {
                    add = { text = '+' },
                    change = { text = '~' },
                    delete = { text = '-' },
                },
                signs_staged = {
                    add = { text = '+' },
                    change = { text = '~' },
                    delete = { text = '-' },
                },
                numhl = true,
                linehl = false,
                word_diff = false,
            }
        end,
        keys = {
            {
                "]c",
                function()
                    if vim.wo.diff then
                        vim.cmd.normal({']c', bang = true})
                    else
                        require("gitsigns").nav_hunk('next')
                    end
                end,
                desc = "next git change"
            },

            {
                "[c",
                function()
                    if vim.wo.diff then
                        vim.cmd.normal({'[c', bang = true})
                    else
                        require("gitsigns").nav_hunk('prev')
                    end
                end,
                desc = "previous git change"
            },

            {
                "<leader>gb",
                ":Gitsigns toggle_current_line_blame<cr>",
                desc = "toggle git blame"
            }
        }

    },
}
