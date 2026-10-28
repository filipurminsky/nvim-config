-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Keep the shell's Java environment intact. Groovy has its own runtime;
-- jdtls selects a Java 21+ runtime in plugins/java.lua.

vim.g.lazyvim_python_lsp = "basedpyright"

-- TypeScript uses LazyVim's default vtsls server. Only run Prettier in projects
-- that explicitly configure it, avoiding surprise formatting in repositories
-- with another formatter.
vim.g.lazyvim_prettier_needs_config = true

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h13"
end
