return {
    { "jjo/vim-cue" },
    { "neovim/nvim-lspconfig",
        ft = "cue",
        config= function()
            -- Suggestions from cue https://github.com/cue-lang/cue/wiki/LSP:-Getting-started
            --
            -- -- Go-to-definition on Ctrl-]
            -- vim.keymap.set("n", "<C-]>", vim.lsp.buf.definition, { desc = "LSP Definition" })

            -- -- Hover on Ctrl-h
            -- vim.keymap.set("n", "<C-h>", vim.lsp.buf.hover, { desc = "LSP Hover" })

            -- -- Optional: set trace level logging (logs at ~/.local/state/nvim/lsp.log)
            -- vim.lsp.set_log_level('trace')

            -- -- Optional: format on save
            -- vim.api.nvim_create_autocmd("BufWritePre", {
            --         pattern = "*.cue",
            --         callback = function()
            --             vim.lsp.buf.format({ async = false })
            --         end,
            --     })
        end
    }

}
