return {
  -- Sticky header showing the enclosing function/class/block at the top of the
  -- window while scrolling deep code. Not enabled by LazyVim by default.
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    opts = {
      max_lines = 3, -- how many context lines to show at most
      multiline_threshold = 1, -- collapse multiline contexts to a single line
      separator = nil, -- use a separator line only when scrolled (set "─" to force)
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)

      -- The default TreesitterContext group inherits the editor background, so
      -- the sticky header blends into the code. Give it a lifted background +
      -- bold, and underline the bottom row to set it apart. Catppuccin Mocha:
      -- surface0 = #313244, overlay0 = #6c7086. Reapplied on ColorScheme so a
      -- theme reload doesn't wipe it.
      local function style()
        vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#313244", bold = true })
        vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#6c7086", bg = "#313244" })
        vim.api.nvim_set_hl(0, "TreesitterContextBottom", { underline = true, sp = "#6c7086" })
      end
      style()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = style })
    end,
    keys = {
      {
        "<leader>uT",
        function()
          require("treesitter-context").toggle()
        end,
        desc = "Toggle Treesitter Context",
      },
      {
        "[c",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Jump to context (upwards)",
      },
    },
  },

  -- Let lua_ls resolve `require("treesitter-context")` while editing this
  -- config. lazydev only indexes loaded plugins, and the plugin above
  -- lazy-loads on LazyFile, so add it to the library explicitly.
  {
    "folke/lazydev.nvim",
    opts = {
      library = {
        { path = "nvim-treesitter-context", words = { "treesitter%-context" } },
      },
    },
  },
}
