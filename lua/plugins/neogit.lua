return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration

    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim", -- optional
  },
  cmd = "Neogit",
  keys = {{"<Leader>gv", nil, desc = "Open Neogit" }},
  opts = {},
  config = function (_, opts)
    require("neogit").setup(opts)
    vim.api.nvim_set_keymap("n","<Leader>gv", "<CMD>Neogit<CR>", {desc = "Open Neogit"} )
  end
}
