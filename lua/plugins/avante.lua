-- avante.nvim driven by Codex over ACP (Agent Client Protocol).
--
-- Rather than talking to a model API directly, avante spawns `codex-acp` and
-- speaks JSON-RPC to it, so the agent does its own file edits and tool calls.
-- Auth piggybacks on the Codex CLI's existing ChatGPT subscription login in
-- ~/.codex/auth.json -- there is no API key involved, which is why HOME has to
-- be forwarded explicitly into the child process env below.
--
-- Every leader mapping is moved off `<leader>a` (owned entirely by
-- claudecode.nvim) onto `<leader>A`.
return {
  {
    "yetone/avante.nvim",
    build = "make",
    event = "VeryLazy",
    version = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim",
      "HakonHarnes/img-clip.nvim",
      "MeanderingProgrammer/render-markdown.nvim",
    },
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- Matches the key in `acp_providers`, which is how avante decides this is
      -- an ACP agent instead of a REST provider.
      provider = "codex",
      acp_providers = {
        codex = {
          command = "codex-acp",
          args = {},
          -- This env replaces (not extends) the child's environment, so HOME
          -- and PATH must be passed through: HOME to locate ~/.codex/auth.json,
          -- PATH so the adapter can find the tools it shells out to.
          env = {
            NODE_NO_WARNINGS = "1",
            HOME = os.getenv("HOME"),
            PATH = os.getenv("PATH"),
            -- The npm package bundles its own @openai/codex; point it at the
            -- Homebrew CLI so both entry points stay on one version.
            CODEX_PATH = vim.fn.exepath("codex"),
          },
        },
      },
      behaviour = {
        -- Inline ghost-text is Copilot's job here; two sources fighting over
        -- the same virtual text is unreadable.
        auto_suggestions = false,
      },
      mappings = {
        ask = "<leader>Aa",
        new_ask = "<leader>An",
        zen_mode = "<leader>Az",
        edit = "<leader>Ae",
        refresh = "<leader>Ar",
        focus = "<leader>Af",
        stop = "<leader>AS",
        toggle = {
          default = "<leader>At",
          debug = "<leader>Ad",
          selection = "<leader>AC",
          suggestion = "<leader>As",
          repomap = "<leader>AR",
        },
        files = {
          add_current = "<leader>Ac",
          add_all_buffers = "<leader>AB",
        },
        select_model = "<leader>A?",
        select_history = "<leader>Ah",
        -- ACP-specific: pick the Codex model / approval mode for the session.
        select_acp_model = "<leader>AM",
        select_acp_mode = "<leader>Am",
      },
    },
  },

  -- Label the group so which-key doesn't show a bare `<leader>A`.
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>A", group = "avante (codex)", icon = " " },
      },
    },
  },

  -- The sidebar is a markdown buffer with filetype `Avante`; without this it
  -- renders as raw markup.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = function(_, opts)
      opts.file_types = opts.file_types or { "markdown" }
      if not vim.tbl_contains(opts.file_types, "Avante") then
        table.insert(opts.file_types, "Avante")
      end
    end,
  },

  -- Scoped to the avante filetype so the Obsidian-tuned defaults in
  -- img-clip.lua (wiki links, relative paths, filename prompt) are untouched.
  {
    "HakonHarnes/img-clip.nvim",
    optional = true,
    opts = {
      filetypes = {
        avante = {
          prompt_for_file_name = false,
          relative_to_current_file = false,
          use_absolute_path = true,
          embed_image_as_base64 = false,
        },
      },
    },
  },
}
