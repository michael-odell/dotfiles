return {
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-vsnip" },

    {
        "hrsh7th/nvim-cmp",

        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            local cmp = require('cmp')

            -- Based on plugin recommended config: https://github.com/hrsh7th/nvim-cmp?tab=readme-ov-file#recommended-configuration
            cmp.setup({
                    formatting = {
                        expandable_indicator = true,
                        fields = {
                            "abbr",
                            "kind",
                            "menu"
                        }
                    },
                    snippet = {
                        expand = function(args)
                           vim.fn["vsnip#anonymous"](args.body)
                        end,
                    },
                    sources = {
                        {name = 'nvim_lsp'},
                        {name = 'nvim_lsp_signature_help'},
                        {name = 'vsnip'},
                        {name = 'buffer'},
                    },
                    window = {
                        -- completion = cmp.config.window.bordered(),
                        -- documentation = cmp.config.window.bordered(),
                    },
                    mapping = cmp.mapping.preset.insert({
                            -- Navigate between completion items
                            ['<C-p>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
                            ['<C-n>'] = cmp.mapping.select_next_item({behavior = 'select'}),

                            -- `Enter` key to confirm completion
                            ['<CR>'] = cmp.mapping.confirm({select = false}),

                            -- Ctrl+Space to trigger completion menu
                            -- ['<C-Space>'] = cmp.mapping.complete(),

                            -- Scroll up and down in the completion documentation
                            ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                            ['<C-d>'] = cmp.mapping.scroll_docs(4),

                        }),
                })
        end,
    },
}
