return {
  -- Float lazydocker via snacks.nvim (already a LazyVim dependency) — no extra
  -- plugin needed. Mirrors the tmux `prefix D` binding.
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>D",
      function()
        Snacks.terminal("lazydocker", { win = { style = "lazygit" } })
      end,
      desc = "Lazydocker (float)",
    },
  },
}
