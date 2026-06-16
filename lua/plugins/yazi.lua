return {
  {
    "mikavilpas/yazi.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = {
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    opts = {
      -- Open yazi instead of netrw when a directory is opened
      open_for_directories = true,
      keymaps = {
        show_help = "<F1>",
      },
    },
    init = function()
      -- Prevent netrw from loading so yazi handles directories
      vim.g.loaded_netrwPlugin = 1
    end,
    keys = {
      -- Opens Yazi in the current file's directory
      {
        "<leader>y",
        "<cmd>Yazi<CR>",
        desc = "Open Yazi at current file",
      },
      -- Opens Yazi in your project root
      {
        "<leader>Y",
        "<cmd>Yazi cwd<CR>",
        desc = "Open Yazi at root directory",
      },
    },
  },
}