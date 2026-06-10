-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Java 26 is incompatible with Gradle 9.1.0 (used by groovy-language-server).
-- Point Mason builds at Java 19 which supports Gradle 9.x.
vim.env.JAVA_HOME = "/Users/filipurminsky/Library/Java/JavaVirtualMachines/temurin-19.0.2/Contents/Home"

vim.g.lazyvim_python_lsp = "basedpyright"

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h13"
end
