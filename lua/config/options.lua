-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Java 26 is incompatible with Gradle 9.1.0 (used by groovy-language-server).
-- Point Mason builds at Java 19 which supports Gradle 9.x.
-- Guarded and $HOME-relative: this config is also cloned onto Linux boxes that
-- have no such JDK, where overriding JAVA_HOME with a dead path would break
-- every Java tool rather than just groovy-language-server.
local jdk19 = vim.fn.expand("~/Library/Java/JavaVirtualMachines/temurin-19.0.2/Contents/Home")
if (vim.uv or vim.loop).fs_stat(jdk19) then
  vim.env.JAVA_HOME = jdk19
end

vim.g.lazyvim_python_lsp = "basedpyright"

-- TypeScript uses LazyVim's default vtsls server. Only run Prettier in projects
-- that explicitly configure it, avoiding surprise formatting in repositories
-- with another formatter.
vim.g.lazyvim_prettier_needs_config = true

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h13"
end
