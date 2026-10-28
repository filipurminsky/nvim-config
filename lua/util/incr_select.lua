-- Treesitter incremental selection for the nvim-treesitter `main` branch,
-- which removed the built-in `incremental_selection` module.
--
--   <CR> in normal mode : select the treesitter node under the cursor
--   <CR> in visual mode : grow selection to the parent node
--   <BS> in visual mode : shrink selection back to the previous node
local M = {}

-- Stack of selected nodes, so <BS> can walk back down.
local stack = {}
local context
local selecting = false

local function reset()
  stack = {}
  context = nil
end

local group = vim.api.nvim_create_augroup("dotfiles_incr_select", { clear = true })
vim.api.nvim_create_autocmd({ "BufLeave", "TextChanged", "TextChangedI" }, { group = group, callback = reset })
vim.api.nvim_create_autocmd("ModeChanged", {
  group = group,
  callback = function()
    if not selecting and vim.v.event.old_mode:match("^[vV\22]") then
      reset()
    end
  end,
})

local function valid_context()
  return context
    and context.buf == vim.api.nvim_get_current_buf()
    and context.win == vim.api.nvim_get_current_win()
    and context.tick == vim.api.nvim_buf_get_changedtick(0)
    and vim.fn.mode():match("^[vV\22]")
    and vim.deep_equal(context.anchor, vim.fn.getpos("v"))
    and vim.deep_equal(context.cursor, vim.api.nvim_win_get_cursor(0))
end

-- Charwise-select the given node's range as a fresh visual selection.
local function select_range(node)
  local srow, scol, erow, ecol = node:range()
  if srow == erow and scol == ecol then
    return false
  end

  -- node ranges have an exclusive end column; convert to an inclusive cursor.
  if ecol > 0 then
    ecol = ecol - 1
  else
    erow = erow - 1
    ecol = -1 -- select to end of the previous line
  end

  -- Leave any existing visual selection before starting a new one.
  if vim.fn.mode():match("[vV\22]") then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", false)
  end

  vim.api.nvim_win_set_cursor(0, { srow + 1, scol })
  vim.cmd("normal! v")
  if ecol == -1 then
    vim.api.nvim_win_set_cursor(0, { erow + 1, 0 })
    vim.cmd("normal! $")
  else
    vim.api.nvim_win_set_cursor(0, { erow + 1, ecol })
  end
  return true
end

local function select_node(node)
  selecting = true
  local ok, selected = pcall(select_range, node)
  selecting = false
  if not ok or not selected then
    reset()
    return
  end
  context = {
    buf = vim.api.nvim_get_current_buf(),
    win = vim.api.nvim_get_current_win(),
    tick = vim.api.nvim_buf_get_changedtick(0),
    anchor = vim.fn.getpos("v"),
    cursor = vim.api.nvim_win_get_cursor(0),
  }
end

-- Default <CR> behaviour, used as a fallback in special buffers.
local function fallback_cr()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
end

function M.init_selection()
  reset()
  -- Don't hijack <CR> in special buffers (help tags, quickfix, etc.).
  if vim.bo.buftype ~= "" then
    return fallback_cr()
  end

  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    return fallback_cr()
  end

  stack = { node }
  select_node(node)
end

function M.node_incremental()
  if not valid_context() then
    return M.init_selection()
  end
  local node = stack[#stack]
  if not node then
    return M.init_selection()
  end

  -- Walk up until we find an ancestor with a strictly larger range.
  local srow, scol, erow, ecol = node:range()
  local cur = node
  while cur:parent() do
    cur = cur:parent()
    local s, c, e, d = cur:range()
    if s ~= srow or c ~= scol or e ~= erow or d ~= ecol then
      table.insert(stack, cur)
      return select_node(cur)
    end
  end

  -- Already at the root: just re-assert the current selection.
  select_node(node)
end

function M.node_decremental()
  if not valid_context() then
    return M.init_selection()
  end
  if #stack > 1 then
    table.remove(stack)
  end
  local node = stack[#stack]
  if node then
    select_node(node)
  end
end

return M
