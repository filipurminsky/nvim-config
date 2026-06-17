return {
  -- Stop linting markdown files. The LazyVim markdown extra assigns
  -- markdownlint-cli2 to the markdown filetype, which produces the
  -- diagnostic messages. Clear it so .md files are not linted.
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
    end,
  },
}
