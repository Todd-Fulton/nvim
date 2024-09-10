return {
  "szw/vim-maximizer",
  cmd = "MaximizerToggle",
  init = function()
    require'config.keymaps'.add({
      "<Leader>sm",
      "<CMD>MaximizerToggle<CR>",
      mode = "n",
      desc = "Maximize/Minimize a split"
    })
  end
}
