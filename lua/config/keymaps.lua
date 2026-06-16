-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", ";", ":", { desc = "Enter command mode" })
vim.keymap.set("n", "<leader>e", function()
  Snacks.explorer({ cwd = Snacks.git.get_root() or LazyVim.root() })
end, { desc = "Explorer (Root Dir)" })

-- Treesitter incremental selection (nvim-treesitter `main` branch has no
-- built-in module, so this uses a small custom implementation).
local incr = require("util.incr_select")
vim.keymap.set("n", "<CR>", incr.init_selection,   { desc = "Init treesitter selection" })
vim.keymap.set("x", "<CR>", incr.node_incremental, { desc = "Expand treesitter selection" })
vim.keymap.set("x", "<BS>", incr.node_decremental, { desc = "Shrink treesitter selection" })

vim.keymap.set("n", "<C-w>+", "<cmd>resize +5<cr>",            { desc = "Increase window height" })
vim.keymap.set("n", "<C-w>-", "<cmd>resize -5<cr>",            { desc = "Decrease window height" })
vim.keymap.set("n", "<C-w>>", "<cmd>vertical resize +10<cr>",  { desc = "Increase window width" })
vim.keymap.set("n", "<C-w><", "<cmd>vertical resize -10<cr>",  { desc = "Decrease window width" })
