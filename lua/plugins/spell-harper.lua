-- Grammar and spell checking via harper-ls.
--
-- Neovim's built-in 'spell' only does dictionary lookup, and LazyVim enables it
-- for prose filetypes only (lazyvim_wrap_spell). harper-ls adds grammar checks
-- on top and understands code: in source files it only inspects comments,
-- strings and doc blocks, not identifiers.
--
-- The personal dictionary lives inside this repo so it is version controlled;
-- add words with the "Add to dictionary" code action (<leader>ca).

local user_dict = vim.fn.stdpath("config") .. "/spell/harper-dictionary.txt"

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        harper_ls = {
          -- The upstream default list (code + prose) plus "text". Listed in full
          -- because this key replaces the default rather than extending it.
          filetypes = {
            "asciidoc",
            "gitcommit",
            "markdown",
            "tex",
            "text",
            "typst",
            "toml",
            "c",
            "cpp",
            "cs",
            "clojure",
            "cmake",
            "dart",
            "go",
            "haskell",
            "html",
            "java",
            "javascript",
            "lua",
            "nix",
            "php",
            "python",
            "ruby",
            "rust",
            "sh",
            "swift",
            "typescript",
            "typescriptreact",
          },
          settings = {
            ["harper-ls"] = {
              userDictPath = user_dict,
              -- Rules are on by default; disable the naggy ones here, e.g.
              -- linters = { SentenceCapitalization = false, ToDoHyphen = false },
            },
          },
        },
      },
    },
  },

  -- Mason: auto-install the language server
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "harper-ls" })
    end,
  },
}
