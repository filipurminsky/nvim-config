return {
  {
    "mfussenegger/nvim-jdtls",
    optional = true,
    opts = function(_, opts)
      if vim.fn.has("macunix") == 1 then
        local result = vim.system({ "/usr/libexec/java_home", "-v", "21+" }, { text = true }):wait()
        local home = result.code == 0 and vim.trim(result.stdout) or nil
        if home and vim.fn.executable(home .. "/bin/java") == 1 then
          -- The launcher otherwise prefers an inherited JAVA_HOME, even if old.
          vim.list_extend(opts.cmd, { "--java-executable", home .. "/bin/java" })
        end
      end
    end,
  },
}
