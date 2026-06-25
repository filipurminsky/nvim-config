-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Curly (undercurl) LSP diagnostic underlines instead of straight ones.
-- The terminal stack supports curly underlines (tmux `usstyle` -> Ghostty `Smulx`),
-- but Neovim's default/catppuccin DiagnosticUnderline* groups use `underline`,
-- which the terminal draws as a straight line. Re-map underline -> undercurl,
-- keeping the diagnostic color (`sp`). Runs on every ColorScheme so it survives
-- catppuccin (re)loading; the immediate call covers the scheme already active.
local function diagnostic_undercurl()
  for _, sev in ipairs({ "Error", "Warn", "Info", "Hint", "Ok" }) do
    local name = "DiagnosticUnderline" .. sev
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    hl.underline = nil
    hl.undercurl = true
    if hl.cterm then
      hl.cterm.underline = nil
      hl.cterm.undercurl = true
    end
    vim.api.nvim_set_hl(0, name, hl --[[@as vim.api.keyset.highlight]])
  end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = diagnostic_undercurl })
diagnostic_undercurl()
