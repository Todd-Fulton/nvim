return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = "VeryLazy",
  config = function(_, opts)
    require 'bufferline'.setup(opts or {})
    vim.api.nvim_set_keymap("n", "<leader>tt", ":$tabnew<CR>", { silent = true, desc = "New tab" })
    vim.api.nvim_set_keymap("n", "<leader>tc", ":tabclose<CR>", { silent = true, desc = "Close tab" })
    vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { silent = true, desc = "Collapse tabs" })
    vim.api.nvim_set_keymap("n", "<leader>tn", ":tabn<CR>", { silent = true, desc = "Next tab" })
    vim.api.nvim_set_keymap("n", "<leader>tp", ":tabp<CR>", { silent = true, desc = "Prev tab" })

    -- move current tab to previous position
    vim.api.nvim_set_keymap("n", "<leader>tmp", ":-tabmove<CR>", { silent = true, desc = "Move tab (prev)" })
    -- move current tab to next position
    vim.api.nvim_set_keymap("n", "<leader>tmn", ":+tabmove<CR>", { silent = true, desc = "Move tab (next)" })
  end
}
