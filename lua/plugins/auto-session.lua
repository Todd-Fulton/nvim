return {
  "rmagatti/auto-session",
  dependencies = {
    "tiagovla/scope.nvim"
  },
  init = function()
    -- restore last workspace session for current directory
    vim.api.nvim_set_keymap("n", "<leader>Sr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" })
    -- save workspace session for current working directory
    vim.api.nvim_set_keymap("n", "<leader>Ss", "<cmd>SessionSave<CR>", { desc = "Save session for cwd" })
  end,
  cmd = { "SessionRestore", "SessionSave"},
  opts = function(_, opts)
    return vim.tbl_deep_extend('force', opts or {},
      {
        auto_restore_enabled = false,
        auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
        bypass_save_filetypes = { 'alpha', 'dashboard', 'neo-tree' }, -- or whatever dashboard you use
        pre_save_cmds = {
          function()
            -- Scope.nvim saving
            vim.cmd([[ScopeSaveState]])
          end
        },
        pre_restore_cmds = {
          function()
            -- Scope.nvim loading
            vim.cmd([[ScopeLoadState]])
          end
        },
      })
  end,
}
