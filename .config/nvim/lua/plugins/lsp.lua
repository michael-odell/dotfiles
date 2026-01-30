-- ref: https://github.com/williamboman/mason-lspconfig.nvim#setup
return {
    {
        "williamboman/mason.nvim",
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
        },
        opts = {
            ensure_installed = {
                "ansiblels",
                "bashls",
                "jsonls",
                "lua_ls",
                "yamlls",
                "helm_ls",
                "terraformls",
            },
            handlers = {
                -- Default handler: enable the server
                function(server_name)
                    vim.lsp.enable(server_name)
                end,
            },
        },
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        opts = {
            ensure_installed = {
                "shellcheck",
                "shfmt",
                "misspell",
                "markdownlint",
                "yamllint",
                "tflint",
            },
            auto_update = true,
        },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            -- Add nvim-cmp capabilities to LSP (for completion support)
            vim.lsp.config('*', {
                capabilities = require('cmp_nvim_lsp').default_capabilities(),
            })

            -- LSP keybindings (beyond Neovim 0.11 defaults)
            -- Defaults now include: K (hover), grn (rename), gra (code action),
            -- grr (references), gri (implementation), gO (symbols), CTRL-S (sig help)
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }

                    -- Navigation (gd, gD are not defaults)
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)

                    -- Formatting (not a default)
                    vim.keymap.set({ 'n', 'x' }, '<F3>', function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)
                end,
            })

            -----------------------------------------------------------------
            -- Server-specific configurations (using Neovim 0.11+ vim.lsp.config)
            -----------------------------------------------------------------

            -- YAML Language Server
            vim.lsp.config('yamlls', {
                settings = {
                    yaml = {
                        format = { enable = false },
                        completion = true,
                        hover = true,
                        schemas = {
                            kubernetes = "*.yaml",
                            ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
                            ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                            ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                            ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
                            ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
                            ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                            ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
                            ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
                            ["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "*docker-compose*.{yml,yaml}",
                            ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
                        },
                        schemaStore = {
                            enable = true,
                            url = "https://www.schemastore.org/api/json/catalog.json",
                        },
                    },
                },
            })

            -- Lua Language Server (suppress vim global warning)
            vim.lsp.config('lua_ls', {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' },
                        },
                    },
                },
            })

            -- Cue Language Server (installed separately, not via mason)
            vim.lsp.enable("cue")
        end,
    },
    {
        "towolf/vim-helm",
        ft = "helm",
    },
}
