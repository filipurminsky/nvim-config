return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal_cmd = "/Users/filipurminsky/.local/bin/claude",
      terminal = {
        provider = "external",
        provider_opts = {
          -- cmd_string = the claude invocation (incl. any flags like --resume)
          -- env_table  = { ENABLE_IDE_INTEGRATION, FORCE_CODE_TERMINAL,
          --                CLAUDE_CODE_SSE_PORT, no_proxy, ... }
          external_terminal_cmd = function(cmd_string, env_table)
            -- Forward the IDE env into the new tmux window. `tmux new-window`
            -- inherits the tmux *server* env, not ours, so each var must be
            -- passed explicitly via `-e` (tmux >= 3.0). CLAUDE_CODE_SSE_PORT
            -- is what makes Claude auto-connect to nvim's MCP server.
            local env_flags = {}
            for k, v in pairs(env_table) do
              table.insert(env_flags, "-e " .. vim.fn.shellescape(k .. "=" .. v))
            end

            local launch = string.format(
              [[tmux new-window -a -t "$src" -c %s -P -F '#{window_id}' -n "$target" %s %s]],
              vim.fn.shellescape(vim.fn.getcwd()),
              table.concat(env_flags, " "),
              vim.fn.shellescape(cmd_string)
            )

            -- Name the window "CC <nvim window name>" and place it right after
            -- the nvim window (`-a`). $TMUX_PANE is nvim's own pane (inherited
            -- env), so we resolve the source window even though this runs
            -- detached. Refocus an existing CC window, else create one and pin
            -- its name against tmux automatic-rename.
            local script = table.concat({
              [[src=$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}')]],
              [[name=$(tmux display-message -p -t "$TMUX_PANE" '#{window_name}')]],
              [[target="🤖 $name"]],
              [[if tmux list-windows -F '#{window_name}' | grep -qxF -- "$target"; then]],
              [[  tmux select-window -t "$target"]],
              [[else]],
              "  new_id=$(" .. launch .. ")",
              [[  tmux set-window-option -t "$new_id" automatic-rename off]],
              [[fi]],
            }, "\n")

            -- Wrap in a shell so the conditional, command substitution, and
            -- quoting work (jobstart runs an argv list directly otherwise).
            return { "sh", "-c", script }
          end,
        },
      },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)

      -- After a selection/file is sent (<leader>as, <leader>ab, tree add),
      -- jump to the external Claude tmux window ("CC <nvim window name>").
      -- The plugin fires this once per file when the send is accepted on a
      -- connected session; the built-in focus_after_send is inert here.
      vim.api.nvim_create_autocmd("User", {
        pattern = "ClaudeCodeSendComplete",
        callback = function()
          local focus =
            [[name=$(tmux display-message -p -t "$TMUX_PANE" '#{window_name}'); tmux select-window -t "🤖 $name"]]
          vim.fn.jobstart({ "sh", "-c", focus })
        end,
      })
    end,
    cmd = {
      "ClaudeCode",
      "ClaudeCodeFocus",
      "ClaudeCodeSelectModel",
      "ClaudeCodeAdd",
      "ClaudeCodeSend",
      "ClaudeCodeTreeAdd",
      "ClaudeCodeStatus",
      "ClaudeCodeStart",
      "ClaudeCodeStop",
      "ClaudeCodeOpen",
      "ClaudeCodeClose",
      "ClaudeCodeDiffAccept",
      "ClaudeCodeDiffDeny",
      "ClaudeCodeCloseAllDiffs",
    },
    keys = {
      { "<leader>a",  nil,                             desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",           desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",      desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",  desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>",desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>",desc = "Select model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",      desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",       mode = "v", desc = "Send selection" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
      },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    },
  },
}
