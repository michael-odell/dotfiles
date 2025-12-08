return {
    "calind/selenized.nvim",
    init = function()
        vim.cmd.colorscheme "selenized"
    end
}

--return {
--  "lifepillar/vim-solarized8",
--  branch = "neovim",
--  priority = 1000,
--  lazy = false,
--
--  init = function()
--      -- ref: https://github.com/lifepillar/vim-solarized8?tab=readme-ov-file#options
--      vim.g.solarized_extra_hi_groups = 1
--  end,
--  config = function()
--    vim.cmd([[colorscheme solarized8]])
--  end,
--}

-- This one looks very updated and tweakable in standard neovim ways: https://github.com/maxmx03/solarized.nvim

-- return {
--     'shaunsingh/solarized.nvim',
--     config = function()
--         vim.opt.background="light"
--         require('solarized').set()
--     end,
-- }
