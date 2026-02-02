-- CUE language support
-- ref: https://github.com/cue-lang/cue/wiki/LSP:-Getting-started
--
-- Setup:
--   - Filetype detection: init.lua (vim.filetype.add)
--   - Treesitter parser: treesitter.lua (syntax highlighting)
--   - LSP: lsp.lua (vim.lsp.enable("cue")) - requires `cue` binary in PATH
return {}
