return {
  "numToStr/Navigator.nvim",
  config = function()
    require("Navigator").setup()
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
    vim.keymap.set({'n', 't'}, '<C-h>', '<CMD>NavigatorLeft<CR>')
    vim.keymap.set({'n', 't'}, '<C-l>', '<CMD>NavigatorRight<CR>')
    vim.keymap.set({'n', 't'}, '<C-k>', '<CMD>NavigatorUp<CR>')
    vim.keymap.set({'n', 't'}, '<C-j>', '<CMD>NavigatorDown<CR>')
    -- If using C-b for tmux, use C-b C-b to send to the 2nd C-b to neovim
    vim.keymap.set({'n', 't'}, '<C-b>', '<CMD>NavigatorPrevious<CR>')
  end
}
