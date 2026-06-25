return {
  {
    "HakonHarnes/img-clip.nvim",
    event = "VeryLazy",
    ---@module 'img-clip'
    ---@type img-clip.Options
    opts = {
      default = {
        -- Prompt for a filename before saving so pasted images get
        -- meaningful names instead of `image.png`.
        prompt_for_file_name = true,
        -- Embed images by reference rather than absolute path.
        relative_to_current_file = true,
      },
      filetypes = {
        markdown = {
          -- In an Obsidian vault, save images into the vault's attachment
          -- folder and embed them with `![[wiki-style]]` links.
          url_encode_path = true,
          template = "![[$FILE_NAME]]",
          download_images = false,
        },
      },
    },
    keys = {
      { "<leader>op", "<cmd>PasteImage<cr>", desc = "Obsidian: Paste image from clipboard" },
    },
  },
}
