return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {},
  cmd = "Oil",
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  init = function()
    local km = require'user.configs.keymaps.init'
    km.add({ "-", "<CMD>Oil<CR>", desc = "Open Oil in Parent Directory", mode = "n"})
  end
}
