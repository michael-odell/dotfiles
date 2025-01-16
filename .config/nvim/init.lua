vim.opt.background = "light"

require("lazy-nvim")

vim.cmd('source ~/.config/nvim/oldinit.vim')

vim.opt.signcolumn = 'yes'

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
-- require('lspconfig')["yamlls"].setup {
--     settings = {
--         yaml = {
--             format = {
--                 enable = false
--             },
--             completion = true,
--             hover = true,
--             schemas = {
--                 kubernetes = "*.yaml",
--                 ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
--                 ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
--                 ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
--                 ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
--                 ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
--                 ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
--                 ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
--                 ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
--                 ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
--                 ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
--                 ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
--                 ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
--             },
--             schemaStore = {
--                 enable = true,
--                 url = "https://www.schemastore.org/api/json/catalog.json",
--             },
--         }
--     }
-- }

-- local cmp = require('cmp')
-- cmp.setup({
--     sources = {
--         {name = 'nvim_lsp'}
--     },
--     mapping = cmp.mapping.preset.insert({
--         -- Suggested on https://lsp-zero.netlify.app/docs/tutorial.html
-- 
--         -- Navigate between completion items
--         ['<C-p>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
--         ['<C-n>'] = cmp.mapping.select_next_item({behavior = 'select'}),
-- 
--         -- `Enter` key to confirm completion
--         ['<CR>'] = cmp.mapping.confirm({select = false}),
-- 
--         -- Ctrl+Space to trigger completion menu
--         ['<C-Space>'] = cmp.mapping.complete(),
-- 
--         -- Scroll up and down in the completion documentation
--         ['<C-u>'] = cmp.mapping.scroll_docs(-4),
--         ['<C-d>'] = cmp.mapping.scroll_docs(4),
--     }),
--     snippet = {
--         expand = function(args)
--             vim.snippet.expand(args.body)
--         end,
--     },
-- })

