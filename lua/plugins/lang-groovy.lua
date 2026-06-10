-- Treat Jenkinsfile* as Groovy
vim.filetype.add({
  pattern = {
    [".*/Jenkinsfile[^/]*"] = "groovy",
  },
})

return {
  -- Treesitter syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "groovy" })
    end,
  },

  -- LSP: groovy-language-server (requires Java)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        groovyls = {},
      },
    },
  },

  -- Mason: auto-install LSP + linter
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "groovy-language-server",
        "npm-groovy-lint",
      })
    end,
  },

  -- Linter
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        groovy = { "npm-groovy-lint" },
      },
    },
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        groovy = { "npm-groovy-lint" },
      },
    },
  },
}
