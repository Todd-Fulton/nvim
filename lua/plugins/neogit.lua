return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "sindrets/diffview.nvim",        -- optional - Diff integration

    "nvim-telescope/telescope.nvim", -- optional
  },
  cmd = "Neogit",
  keys = {{"<Leader>gv", "<CMD>Neogit<CR>", desc = "Open Neogit" }},
  opts = {
    graph_stype = "unicode",
    commit_editor = {
      kind = "auto",
    },
  },
}
