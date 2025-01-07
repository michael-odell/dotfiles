return {
  "mofiqul/vscode.nvim",
  priority = 100,
  lazy = false,
  config = function()
    require("vscode").setup {
			style="light"
    }

    vim.cmd.colorscheme "vscode"
  end,
}
