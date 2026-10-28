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
      opts.jdtls = function(config)
        -- java-test ships executable/support jars alongside its OSGi bundles.
        -- Loading those as bundles fails; recent jdtls also ships ASM itself.
        local excluded = {
          ["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
          ["jacocoagent.jar"] = true,
        }
        local plugins = (vim.env.MASON or vim.fn.stdpath("data") .. "/mason") .. "/packages/jdtls/plugins/"
        config.init_options.bundles = vim.tbl_filter(function(jar)
          local name = vim.fs.basename(jar)
          return not excluded[name] and vim.fn.filereadable(plugins .. name) == 0
        end, config.init_options.bundles or {})
        return config
      end
    end,
  },
}
