return {
  "natecraddock/workspaces.nvim",
  cmd = {
    "WorkspacesAdd",
    "WorkspacesAddDir",
    "WorkspacesList",
    "WorkspacesListDirs",
    "WorkspacesOpen",
    "WorkspacesRemove",
    "WorkspacesRemoveDir",
    "WorkspacesRename",
    "WorkspacesSyncDirs",
  },
  keys = {
    { "<Leader>fw", "<CMD>Telescope workspaces<CR>", desc = "Workspaces" },
    { "<Leader>Sw", "<CMD>WorkspacesAdd<CR>",        desc = "Workspace add" },
    { "<Leader>tw", function ()
      vim.cmd [[:$tabnew]]
      require("workspaces").open()
    end,
    desc = "Open Workspace in a new tab",
    },
  },
  opts = {
    cd_type = "tab"
  },
}
