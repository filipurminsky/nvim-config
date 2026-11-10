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
        groovyls = {
          cmd_env = (function()
            -- Any installed JDK 19 (brew cask temurin@19 or an IntelliJ download).
            -- java_home is macOS-only; -F makes it fail rather than fall back.
            if vim.fn.executable("/usr/libexec/java_home") == 0 then
              return nil
            end
            local result = vim.system({ "/usr/libexec/java_home", "-F", "-v", "19" }, { text = true }):wait()
            local home = result.code == 0 and vim.trim(result.stdout) or ""
            if home ~= "" and vim.fn.executable(home .. "/bin/java") == 1 then
              return { JAVA_HOME = home, PATH = home .. "/bin:" .. vim.env.PATH }
            end
          end)(),
        },
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
