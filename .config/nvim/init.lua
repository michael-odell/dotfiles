vim.opt.background = "light"

require("lazy-nvim")

vim.cmd('source ~/.config/nvim/oldinit.vim')

vim.opt.signcolumn = 'yes'

-- Apply format options to all filetypes (replaces per-filetype ForceMyFormatOptions calls)
vim.api.nvim_create_autocmd("FileType", {
    desc = "Apply standard format options to all filetypes",
    callback = function()
        -- Set defaults synchronously (ftplugin files can override these)
        local fo = vim.opt_local.formatoptions
        fo:append("n")  -- Recognize numbered lists
        fo:append("j")  -- Remove comment leader when joining lines
        fo:remove("r")  -- Don't auto-insert comment leader on <CR>
        fo:remove("o")  -- Don't auto-insert comment leader on 'o' or 'O'

        -- Schedule 't' removal to run AFTER all ftplugins - 't' should NEVER be on
        vim.schedule(function()
            vim.opt_local.formatoptions:remove("t")
        end)
    end
})

vim.diagnostic.config({
    virtual_text = true
})

