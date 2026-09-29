-- Neovide GUI settings.  Loaded from init.lua only when running under Neovide.

-- Same font as [ghostty](../../ghostty/config.ghostty).  Grayscale antialiasing (`#e-antialias`)
-- also matches Ghostty; Neovide's default subpixel edging renders heavier.
vim.o.guifont = "SauceCodePro NFM:h12:#e-antialias"

-- Enable the Command key (Logo key) on macOS
vim.g.neovide_input_use_logo = true

-- Copy/Paste shortcuts using the system clipboard (+ register)
vim.keymap.set('v', '<D-c>', '"+y')         -- Copy in Visual mode
vim.keymap.set('n', '<D-v>', '"+p')         -- Paste in Normal mode
vim.keymap.set('i', '<D-v>', '<C-r>+')      -- Paste in Insert mode
vim.keymap.set('c', '<D-v>', '<C-r>+')      -- Paste in Command mode
vim.keymap.set('t', '<D-v>', '<C-\\><C-n>"+pa') -- Paste in Terminal mode

-- Scrap that ugly animation
vim.g.neovide_cursor_animation_length = 0
