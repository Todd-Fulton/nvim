return {
  "folke/todo-comments.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "TodoTelescope",
  init = function()
    require'user.configs.keymaps.init'.add({
      mode = { "n" },
      {
        "]t",
        function() require'todo-comments'.jump_next() end,
        desc = "Next todo",
        --- TODO: add condition, only activate if we are in a buffer
      },
      {
        "[t",
        function() require'todo-comments'.jump_prev() end,
        desc = "Prev todo",
        -- TODO: add condition, only activate if we are in a buffer
      },
    })
  end,
  opts = {}
}
