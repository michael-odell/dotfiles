return {
    {
        "hrsh7th/cmp-nvim-lsp"
    },
    -- At some point, this looks like a successor to nvim-cmp: https://github.com/saghen/blink.cmp?tab=readme-ov-file
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",

            -- SOME snippet tool is required, others are possible -- see snippets.lua
            "hrsh7th/vim-vsnip"
        },
        config = function()
            local cmp = require('cmp')

            -- Based on plugin recommended config: https://github.com/hrsh7th/nvim-cmp?tab=readme-ov-file#recommended-configuration
            cmp.setup({
                    sources = {
                        {name = 'nvim_lsp'},
                        {name = 'vsnip'},
                        {name = 'buffer'},
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
                    snippet = {
                        expand = function(args)
                            vim.fn["vsnip#anonymous"](args.body)
                        end,
                    },
                })
        end,
    },
}
