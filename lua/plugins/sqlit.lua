return {
  -- Float Sqlit via snacks.nvim (already a LazyVim dependency) — no extra
  -- plugin needed. Consistent with lazydocker's <leader>kd; <leader>ks = SQL.
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>ks",
      function()
        Snacks.terminal("sqlit", { win = { style = "lazygit" } })
      end,
      desc = "Sqlit (float)",
    },
  },
}
