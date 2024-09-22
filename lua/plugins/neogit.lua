return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    "nvim-telescope/telescope.nvim", -- optional
  },
  cmd = "Neogit",
  opts = {
    graph_stype = "unicode",
    commit_editor = {
      kind = "auto",
    },
  },
  init = function()
    require("which-key").add {
      { "<Leader>gnt", "<CMD>Neogit<CR>", desc = "Open Neogit" },
      { "<Leader>gnc", "CMD>Neogit kind=tab commit<CR>", icon = "", desc = "Commit staged files/hunks" },
      { "<Leader>gnd", "CMD>Neogit diff<CR>", icon = "", desc = "Commit staged files/hunks" },
      { "<Leader>gnP", "CMD>Neogit push<CR>", icon = "", desc = "Commit staged files/hunks" },
      { "<Leader>gnp", "CMD>Neogit pull<CR>", icon = "", desc = "Commit staged files/hunks" },
    }
  end,
}
