return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    keys = {
      -- Keep Claude Code's default <leader>aa for accepting a diff.
      { "<leader>aa", false, mode = { "n", "x" } },
      {
        "<leader>at",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "x" },
      },
    },
  },
}
