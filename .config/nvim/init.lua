-- Filetype detection for languages not built into Neovim
vim.filetype.add({
    extension = {
        cue = "cue",
    },
})

require("lazy-nvim")

vim.cmd('source ~/.config/nvim/oldinit.vim')

require('diff-side').setup()

vim.opt.signcolumn = 'yes'

-- Split big rewritten diff hunks into add/delete/change parts (default is 40 lines).
vim.opt.diffopt:append('linematch:200')

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

        -- Schedule 't' removal to run AFTER all ftplugins
        -- Exception: prose filetypes where auto-wrap is useful
        vim.schedule(function()
            local prose_filetypes = { markdown = true, text = true, gitcommit = true }
            if not prose_filetypes[vim.bo.filetype] then
                vim.opt_local.formatoptions:remove("t")
            end
        end)
    end
})

vim.diagnostic.config({
    virtual_text = true
})

-- Enable treesitter highlighting for supported filetypes
vim.api.nvim_create_autocmd("FileType", {
    desc = "Enable treesitter highlighting",
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-- Toggle diagnostics/errors for current buffer to avoid the really annoying ones
vim.keymap.set('n', '<leader>e', function()
    local bufnr = 0
    if vim.diagnostic.is_enabled({ bufnr = bufnr }) then
        vim.diagnostic.enable(false, { bufnr = bufnr })
        print("Diagnostics Disabled")
    else
        vim.diagnostic.enable(true, { bufnr = bufnr })
        print("Diagnostics Enabled")
    end
end, { desc = "Toggle Buffer Diagnostics" })

-- Copy a `path:line` reference to the system clipboard (via `yank`, like `,y`):
-- the cursor line in normal mode, `path:12-18` for a visual selection.  The path is
-- from the repo root in a git repo, else from the cwd.  In a fugitive buffer (e.g.
-- the base side of a diff) it's the path within the commit.
local function copy_reference(first, last)
    local name = vim.api.nvim_buf_get_name(0)
    if name == '' then
        vim.notify('No file name to reference', vim.log.levels.WARN)
        return
    end
    local path = name:match('^fugitive://.-//%w+/(.*)$')
    if not path then
        local root = vim.fs.root(0, '.git')
        path = root and vim.fs.relpath(root, name) or vim.fn.fnamemodify(name, ':.')
    end
    local ref = path .. ':' .. first .. (last ~= first and '-' .. last or '')
    vim.fn.system('yank', ref)
    if vim.v.shell_error ~= 0 then
        vim.notify('yank failed for ' .. ref, vim.log.levels.ERROR)
    else
        vim.notify('Copied ' .. ref)
    end
end
vim.keymap.set('n', '<leader>r', function()
    local line = vim.fn.line('.')
    copy_reference(line, line)
end, { desc = "Copy path:line reference to clipboard" })
vim.keymap.set('x', '<leader>r', function()
    local a, b = vim.fn.line('v'), vim.fn.line('.')
    copy_reference(math.min(a, b), math.max(a, b))
    vim.api.nvim_feedkeys(vim.keycode('<Esc>'), 'n', false)
end, { desc = "Copy path:first-last reference to clipboard" })

if vim.g.neovide then
    require("neovide")
end
