return {
  {
    "folke/persistence.nvim",
    event = { "BufReadPre", "VimEnter" },
    config = function(_, opts)
      local persistence = require("persistence")
      persistence.setup(opts)
      if vim.g.dotfiles_no_session == 1 then
        persistence.stop()
        return
      end
      local restoring = false

      -- Resurrect launches nvim-restore.sh, which opts into restoring this
      -- project's session. Ordinary Neovim launches keep the default behavior.
      if vim.g.dotfiles_restore_session == 1 then
        vim.g.dotfiles_restore_session = nil
        vim.schedule(function()
          persistence.load()
        end)
      end

      local function checkpoint()
        if restoring or not persistence.active() then
          return
        end
        local count = 0
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if
            vim.bo[buf].buftype == ""
            and vim.api.nvim_buf_get_name(buf) ~= ""
            and not vim.tbl_contains({ "gitcommit", "gitrebase", "jj" }, vim.bo[buf].filetype)
          then
            count = count + 1
          end
        end
        if count >= math.max(opts.need or 1, 1) then
          pcall(persistence.save)
        end
      end
      local group = vim.api.nvim_create_augroup("dotfiles_session_checkpoint", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "PersistenceLoadPre",
        callback = function()
          restoring = true
        end,
      })
      vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "PersistenceLoadPost",
        callback = function()
          restoring = false
        end,
      })
      vim.api.nvim_create_autocmd({ "FocusLost", "BufLeave" }, { group = group, callback = checkpoint })
      if persistence._dotfiles_timer and not persistence._dotfiles_timer:is_closing() then
        persistence._dotfiles_timer:stop()
        persistence._dotfiles_timer:close()
      end
      local timer = assert(vim.uv.new_timer())
      persistence._dotfiles_timer = timer
      timer:start(60000, 60000, vim.schedule_wrap(checkpoint))
      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = group,
        once = true,
        callback = function()
          timer:stop()
          timer:close()
        end,
      })
    end,
  },
}
