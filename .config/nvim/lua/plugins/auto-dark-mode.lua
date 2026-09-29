-- Follows the system light/dark setting so nvim matches the terminal
-- (Selenized Light / Selenized Dark). `f-person/auto-dark-mode.nvim` polls
-- `defaults read -g AppleInterfaceStyle` on macOS and `gsettings` on Linux.
return {
    "f-person/auto-dark-mode.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        update_interval = 3000,
        set_dark_mode = function()
            vim.o.background = "dark"
            vim.cmd.colorscheme("selenized")
        end,
        set_light_mode = function()
            vim.o.background = "light"
            vim.cmd.colorscheme("selenized")
        end,
    },
}
