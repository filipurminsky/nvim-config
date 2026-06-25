return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Inline image rendering in markdown (and previews on hover).
      -- Needs a terminal with the Kitty graphics protocol (Ghostty ✓) and
      -- ImageMagick (`magick`) for conversion. Through tmux it also requires
      -- `set -g allow-passthrough on`.
      image = {
        enabled = true,
        doc = {
          -- Render images inline in the document as you move through it.
          inline = true,
          -- Also float a larger preview of the image under the cursor.
          float = true,
        },
      },
    },
  },
}
