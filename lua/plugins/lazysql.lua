return {
  -- Float lazysql via snacks.nvim (already a LazyVim dependency) — no extra
  -- plugin needed. Consistent with lazydocker's <leader>kd; <leader>ks = sql.
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>ks",
      function()
        Snacks.terminal("lazysql", { win = { style = "lazygit" } })
      end,
      desc = "Lazysql (float)",
    },
  },
}
