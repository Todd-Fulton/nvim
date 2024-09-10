return {
  "akinsho/bufferline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  version = false,
  event = "BufAdd",
  opts = {
    options = {
      mode = "buffers",
    },
  },
}
