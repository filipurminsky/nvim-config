-- Treesitter incremental selection for the nvim-treesitter `main` branch,
-- which removed the built-in `incremental_selection` module.
--
--   <CR> in normal mode : select the treesitter node under the cursor
--   <CR> in visual mode : grow selection to the parent node
--   <BS> in visual mode : shrink selection back to the previous node
local M = {}

-- Stack of selected nodes, so <BS> can walk back down.
local stack = {}

-- Charwise-select the given node's range as a fresh visual selection.
local function select_node(node)
  local srow, scol, erow, ecol = node:range()

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
end

-- Default <CR> behaviour, used as a fallback in special buffers.
local function fallback_cr()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "n", false)
end

function M.init_selection()
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
  if #stack > 1 then
    table.remove(stack)
  end
  local node = stack[#stack]
  if node then
    select_node(node)
  end
end

return M