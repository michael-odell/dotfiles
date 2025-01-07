return {
  "lifepillar/vim-solarized8",
  branch = "neovim",
  priority = 100,
  lazy = false,
  init = function()
      vim.g.solarized_termtrans = 0
  end,
  config = function()
    vim.cmd('colorscheme solarized8')
  end,
}
