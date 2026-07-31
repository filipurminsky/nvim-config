return {
  {
    "okuuva/auto-save.nvim",
    version = "^1", -- pin to stable major
    cmd = "ASToggle", -- lazy-load on :ASToggle
    event = { "InsertLeave", "TextChanged" },
    init = function()
      -- Suppress Neovim's "N lines, M bytes written" message on every save.
      vim.opt.shortmess:append("W")
    end,
    opts = {
      -- Save when leaving insert mode or when text changes in normal mode.
      trigger_events = {
        immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
        defer_save = { "InsertLeave", "TextChanged" },
        cancel_deferred_save = { "InsertEnter" },
      },
      -- Wait this long after the last change before writing (like IntelliJ's debounce).
      debounce_delay = 1000,
      -- Don't autosave special/unwritable buffers.
      condition = function(buf)
        local ok, modifiable = pcall(vim.api.nvim_get_option_value, "modifiable", { buf = buf })
        if not ok or not modifiable then
          return false
        end
        if vim.bo[buf].readonly then
          return false
        end
        return true
      end,
    },
  },
}
