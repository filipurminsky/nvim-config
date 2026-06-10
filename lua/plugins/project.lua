local excluded_file = vim.fn.stdpath("data") .. "/snacks/excluded_projects.txt"

local function load_excluded()
  local set = {}
  local f = io.open(excluded_file, "r")
  if f then
    for line in f:lines() do
      if line ~= "" then set[line] = true end
    end
    f:close()
  end
  return set
end

local function exclude_project(dir)
  local f = io.open(excluded_file, "a")
  if f then
    f:write(dir .. "\n")
    f:close()
  end
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      explorer = {
        root = function()
          return LazyVim.root()
        end,
      },
      picker = {
        sources = {
          projects = {
            dev = { "~/git", "~/dev", "~/projects" },
            transform = function(item)
              local excluded = load_excluded()
              if excluded[item.file] then return false end
              return item
            end,
            actions = {
              delete_project = function(picker, item)
                if not item then return end
                exclude_project(item.file)
                vim.notify("Removed: " .. item.file)
                picker:close()
              end,
            },
            win = {
              input = {
                keys = {
                  ["<C-x>"] = { "delete_project", mode = { "i", "n" } },
                },
              },
            },
          },
        },
      },
    },
  },
}
