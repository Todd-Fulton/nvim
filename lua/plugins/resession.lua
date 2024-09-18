return {
  'stevearc/resession.nvim',
  opts = {
    -- override default filter
    buf_filter = function(bufnr)
      local buftype = vim.bo[bufnr].buftype
      if buftype == 'help' then
        return true
      end
      if buftype ~= "" and buftype ~= "acwrite" then
        return false
      end
      if vim.api.nvim_buf_get_name(bufnr) == "" then
        return false
      end

      -- this is required, since the default filter skips nobuflisted buffers
      return true
    end,
    extensions = {
      scope = {}, -- add scope.nvim extension
    },
  },
  dependencies = {
    {
      "tiagovla/scope.nvim",
    },
  },
  keys = {
    {
      "<Leader>Ss",
      function()
        require("resession").save()
      end,
      desc = "Save Session"
    },
    {
      "<Leader>St",
      function()
        require("resession").save_tab()
      end,
      desc = "Save Tab"
    },
    {
      "<Leader>Sl",
      function()
        require("resession").load()
        --- Triggers SessionLoadPost which alpha.nvim uses to close
        vim.api.nvim_exec_autocmds("SessionLoadPost", {})
      end,
      desc = "Load Session"
    },
    {
      "<Leader>Sd",
      function()
        require("resession").delete()
      end,
      desc = "Delete Session"
    },
  },
}
