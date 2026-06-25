return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      workspaces = {
        {
          name = "Engineering",
          path = vim.fn.expand("~") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Engineering",
        },
        {
          name = "Private",
          path = vim.fn.expand("~") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/Private",
        },
      },
      -- Use the new `:Obsidian <subcommand>` interface instead of the
      -- deprecated `:ObsidianToday`-style commands.
      legacy_commands = false,
      picker = {
        name = "snacks.pick",
      },
    },
    keys = {
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "Obsidian: New note" },
      { "<leader>oo", "<cmd>Obsidian open<cr>", desc = "Obsidian: Open in app" },
      { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Obsidian: Search notes" },
      { "<leader>oq", "<cmd>Obsidian quick_switch<cr>", desc = "Obsidian: Quick switch" },
      { "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Obsidian: Switch vault" },
      { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Obsidian: Today's note" },
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Obsidian: Backlinks" },
      { "<leader>ol", "<cmd>Obsidian links<cr>", desc = "Obsidian: Links in note" },
      { "<leader>of", "<cmd>Obsidian follow_link<cr>", desc = "Obsidian: Follow link" },
    },
  },
}
