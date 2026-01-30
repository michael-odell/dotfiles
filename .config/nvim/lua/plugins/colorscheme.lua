return {
    "calind/selenized.nvim",
    priority = 1000,
    lazy = false,
    init = function()
        vim.cmd.colorscheme "selenized"
    end
}
