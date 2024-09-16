return {
  "szw/vim-maximizer",
  cmd = "MaximizerToggle",
  init = function()
    require'user.configs.keymaps.init'.add({
      "<Leader>sm",
      "<CMD>MaximizerToggle<CR>",
      mode = "n",
      desc = "Maximize/Minimize a split"
    })
  end
}
