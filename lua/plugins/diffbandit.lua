return {
  {
    "CoreyKaylor/diffbandit.nvim",
    version = "*",
    cmd = {
      "DiffBandit",
      "DiffBanditBuffers",
      "DiffBanditFolderDiff",
      "DiffBanditGit",
      "DiffBanditGitCurrent",
      "DiffBanditGitMenu",
      "DiffBanditGitLog",
      "DiffBanditGitCommit",
      "DiffBanditGitCompare",
      "DiffBanditGitCheckout",
      "DiffBanditCommitPanel",
      "DiffBanditMerge",
    },
    opts = {},
    keys = {
      { "<leader>gd", "<cmd>DiffBanditGit<cr>",         desc = "DiffBandit (changed files)" },
      { "<leader>gD", "<cmd>DiffBanditGitCurrent<cr>",  desc = "DiffBandit (current file)" },
      { "<leader>gc", "<cmd>DiffBanditCommitPanel<cr>", desc = "Commit Panel (DiffBandit)" },
      { "<leader>gm", "<cmd>DiffBanditGitMenu<cr>",     desc = "Git Menu (DiffBandit)" },
      { "<leader>gH", "<cmd>DiffBanditGitLog<cr>",      desc = "Repo History (DiffBandit)" },
      {
        -- :DiffBanditGitLog takes pathspecs as command fargs, which are not
        -- expanded like `%`, so resolve the current file here.
        "<leader>gF",
        function()
          vim.cmd("DiffBanditGitLog " .. vim.fn.fnameescape(vim.fn.expand("%:p")))
        end,
        desc = "File History (DiffBandit)",
      },
    },
  },
}
