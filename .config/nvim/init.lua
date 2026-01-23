vim.g.do_filetype_lua = 1
vim.opt.background = "light"

require("lazy-nvim")

vim.cmd('source ~/.config/nvim/oldinit.vim')

vim.opt.signcolumn = 'yes'

vim.lsp.enable("cue")

vim.diagnostic.config({
        virtual_text = true
    })

-- require('lspconfig')["helm-ls"].setup {
--     settings = {
--         ['helm-ls'] = {
--             yamlls = {
--                 path = "yaml-language-server",
--             }
--         }
--     },
-- }
--
--     -- on_attach = function(client, bufnr)
--     --     client.server_capabilities.documentFormattingProvider = true
--     --     on_attach(client, bufnr)
--     -- end,
--

