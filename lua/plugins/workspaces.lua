return {
  "natecraddock/workspaces.nvim",
  lazy = false,
  keys = {
    {
      "<Leader>fw",
      function()
        local ws = require "workspaces"
        vim.cmd [[Lazy load resession.nvim]]
        vim.cmd [[Lazy load telescope.nvim]]
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[bufnr].modified then
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local empty = bufname == ""
            if empty then bufname = "Untitled" end
            local confirm =
              vim.fn.confirm(('Save changes to "%s"?'):format(bufname), "&Yes\n&No\n&Cancel", 1, "Question")
            if confirm == 1 then
              if not empty then vim.cmd.write() end
            elseif confirm == 3 then
              return
            end
          end
        end
        -- TODO: custom UI for more control, this is async
        ws.open()
        local bd = require("mini.bufremove").delete
        local scratch = vim.api.nvim_create_buf(false, true)
        vim.bo[scratch].bufhidden = "wipe"
        vim.api.nvim_win_set_buf(0, scratch)
        vim.bo[scratch].buftype = ""
        if #vim.api.nvim_list_wins() > 1 then vim.cmd.only() end
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[bufnr].buflisted then bd(bufnr, true) end
        end
        vim.cmd [[Alpha]]
      end,
      desc = "Open Workspace",
    },
    { "<Leader>Sw", "<CMD>WorkspacesAdd<CR>", desc = "Workspace add" },
    {
      "<Leader>tw",
      function()
        vim.cmd [[:$tabnew]]
        require("workspaces").open()
      end,
      desc = "Open Workspace in a new tab",
    },
  },
  opts = {
    cd_type = "tab",
    sort = true,
    mru_sort = true,
    auto_open = true,
    auto_dir = true,
  },
}
