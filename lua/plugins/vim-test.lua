return {
  {
    "vim-test/vim-test",
    dependencies = { "preservim/vimux" },
    cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
    keys = {
      { "<leader>Tn", "<cmd>TestNearest<cr>", desc = "Test Nearest (vimux)" },
      { "<leader>Tf", "<cmd>TestFile<cr>", desc = "Test File (vimux)" },
      { "<leader>Ts", "<cmd>TestSuite<cr>", desc = "Test Suite (vimux)" },
      { "<leader>Tl", "<cmd>TestLast<cr>", desc = "Test Last (vimux)" },
      { "<leader>Tv", "<cmd>TestVisit<cr>", desc = "Open file under test" },
      { "<leader>Tc", "<cmd>VimuxCloseRunner<cr>", desc = "Close vimux pane" },
      { "<leader>Tz", "<cmd>VimuxZoomRunner<cr>", desc = "Zoom vimux pane" },
    },
    init = function()
      -- Route all vim-test runs through a vimux tmux pane. neotest (LazyVim
      -- test.core extra) keeps <leader>t; vim-test lives under <leader>T.
      vim.g["test#strategy"] = "vimux"
      vim.g.VimuxHeight = "25" -- % of screen for the runner pane
      vim.g.VimuxOrientation = "v" -- "v" = split below, "h" = split right
    end,
  },

  -- which-key group label for the <leader>T prefix (cosmetic).
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>T", group = "Test (vimux)" },
      },
    },
  },
}
