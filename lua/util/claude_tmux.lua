local M = {}

-- IDs survive renaming, duplicate window names, and renumbering. The reverse
-- link prevents reusing an unrelated window after a stale association.
local resolve = [[
set -eu
: "${TMUX_PANE:?Claude external terminal requires tmux}"
src=$(tmux display-message -p -t "$TMUX_PANE" '#{window_id}')
session=$(tmux display-message -p -t "$TMUX_PANE" '#{session_id}')
peer=$(tmux show-options -w -v -t "$src" @claude_companion 2>/dev/null || true)
valid_peer() {
  [ -n "$peer" ] &&
    [ "$(tmux display-message -p -t "$session:$peer" '#{@claude_source}' 2>/dev/null)" = "$src" ]
}
]]

function M.launch(cmd, env)
  local flags = {}
  for k, v in pairs(env or {}) do
    flags[#flags + 1] = "-e " .. vim.fn.shellescape(k .. "=" .. tostring(v))
  end
  local create = string.format(
    [[tmux new-window -a -t "$session:$src" -c %s -P -F '#{window_id}' -n "$name" %s %s]],
    vim.fn.shellescape(vim.fn.getcwd()),
    table.concat(flags, " "),
    vim.fn.shellescape(cmd)
  )
  return {
    "sh",
    "-c",
    resolve .. [[
tmux wait-for -L "claude-$src"
trap 'tmux wait-for -U "claude-$src"' EXIT
peer=$(tmux show-options -w -v -t "$src" @claude_companion 2>/dev/null || true)
if valid_peer; then
  tmux select-window -t "$session:$peer"
else
  name="🤖 $(tmux display-message -p -t "$TMUX_PANE" '#{window_name}')"
  peer=$(]] .. create .. [[)
  tmux set-option -w -t "$peer" automatic-rename off
  tmux set-option -w -t "$peer" @claude_source "$src"
  tmux set-option -w -t "$src" @claude_companion "$peer"
fi
tmux run-shell -b "$HOME/.config/tmux/glue-sync.sh"
]],
  }
end

function M.focus()
  if vim.env.TMUX_PANE then
    vim.fn.jobstart({ "sh", "-c", resolve .. [[
if valid_peer; then tmux select-window -t "$session:$peer"; fi
]] })
  end
end

return M
