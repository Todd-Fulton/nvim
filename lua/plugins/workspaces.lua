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
    { "<Leader>Sw", "<CMD>WorkspacesAdd<CR>",        desc = "Workspace add" }
  },
  opts = {
    cd_type = "tab"
  },
}
