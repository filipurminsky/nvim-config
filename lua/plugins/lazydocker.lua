return {
  -- Float lazydocker via snacks.nvim (already a LazyVim dependency) — no extra
  -- plugin needed. NB: <leader>D is taken by vim-dadbod-ui (Toggle DBUI), so
  -- this uses <leader>kd (k = container/k8s tooling) to avoid the clash.
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>kd",
      function()
        Snacks.terminal("lazydocker", { win = { style = "lazygit" } })
      end,
      desc = "Lazydocker (float)",
    },
  },
}
