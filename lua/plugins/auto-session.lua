return {
  "rmagatti/auto-session",
  cmd = { "SessionRestore", "SessionSave" },
  init = function()
    local km = require'config.keymaps'
    km.add({
      mode = { "n" },
     -- restore last workspace session for current directory
      {"<leader>Sr", "<cmd>SessionRestore<CR>", desc = "Restore session for cwd" },
     -- save workspace session for current working directory
      {"<leader>Ss", "<cmd>SessionSave<CR>", desc = "Save session for cwd" },
    })
  end,
  config = function(_, opts)
    local auto_session = require("auto-session")
    opts = opts and opts or {}

    auto_session.setup({
      auto_restore_enabled = false,
      auto_session_suppress_dirs = { "~/", "~/Downloads", "~/Documents", "~/Desktop/" },
    })

  end,
}
