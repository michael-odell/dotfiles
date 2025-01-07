return {
  "lifepillar/vim-solarized8",
  branch = "neovim",
  priority = 100,
  lazy = false,

  init = function()
      -- ref: https://github.com/lifepillar/vim-solarized8?tab=readme-ov-file#options
      vim.g.solarized_extra_hi_groups = 1
  end,
  config = function()
    vim.cmd('colorscheme solarized8')
  end,
}
