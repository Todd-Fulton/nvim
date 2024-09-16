return {
  'akinsho/toggleterm.nvim',
  version = false,
  opts = {},
  cmd = {"ToggleTerm", "ToggleTermSendVisualSelection", },
  init = function ()
    vim.api.nvim_set_keymap("n", "<Leader>tt", "<CMD>ToggleTerm direction=tab<CR>", {
      desc = "Toggle Terminal (tab)"
    })
    vim.api.nvim_set_keymap("n", "<Leader>tf", "<CMD>ToggleTerm direction=float<CR>", {
      desc = "Toggle Terminal (float)"
    })
    vim.api.nvim_set_keymap("n", "<Leader>t\\", "<CMD>ToggleTerm direction=vertical<CR>", {
      desc = "Toggle Terminal (split vertical)"
    })
    vim.api.nvim_set_keymap("n", "<Leader>t-", "<CMD>ToggleTerm direction=horizontal<CR>", {
      desc = "Toggle Terminal (split horizontal)"
    })
    vim.api.nvim_set_keymap("v", "<Leader>tt", "<CMD>ToggleTermSendVisualSelection direction=tab<CR>", {
      desc = "Toggle Terminal (tab)"
    })
    vim.api.nvim_set_keymap("v", "<Leader>tf", "<CMD>ToggleTermSendVisualSelection direction=float<CR>", {
      desc = "Toggle Terminal (float)"
    })
    vim.api.nvim_set_keymap("v", "<Leader>t\\", "<CMD>ToggleTermSendVisualSelection direction=vertical<CR>", {
      desc = "Toggle Terminal (split vertical)"
    })
    vim.api.nvim_set_keymap("v", "<Leader>t-", "<CMD>ToggleTermSendVisualSelection direction=horizontal<CR>", {
      desc = "Toggle Terminal (split horizontal)"
    })
  end
}
