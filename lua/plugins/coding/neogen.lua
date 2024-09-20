local ft = { "lua", "c", "cpp", "bash", "sh", "zsh" }

return {
  "danymat/neogen",
  -- Uncomment next line if you want to follow only stable versions
  -- version = "*",
  dependencies = {
    "L3MON4D3/LuaSnip"
  },
  opts = function(_, opts)
    opts = vim.tbl_deep_extend('force', opts or {}, {
      snippet_engine = "luasnip",
      languages = {
        lua = { template = { annotation_convention = "emmylua" } },
        zsh = require("neogen.configurations.sh"),
      },
    })
    return opts
  end,
  ft = ft,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = ft,
      callback = function(ev)
        require("which-key").add({
          { "<Leader>a", group = "Annotate", icon = "" },
          {
            "<Leader>aa",
            function()
              require('neogen').generate()
            end,
            desc = "Annotate element under the cursor",
            icon = "",
            silent = true,
            noremap = true,
            buffer = ev.buf,
          },
          {
            "<Leader>af",
            function()
              require('neogen').generate({ type = 'func' })
            end,
            desc = "Annotate function",
            icon = "󰊕",
            silent = true,
            noremap = true,
            buffer = ev.buf,
          },
          {
            "<Leader>ac",
            function()
              require('neogen').generate({ type = 'class' })
            end,
            desc = "Annotate class",
            icon = "",
            silent = true,
            noremap = true,
            buffer = ev.buf,
          },
          {
            "<Leader>at",
            function()
              require('neogen').generate({ type = 'type' })
            end,
            desc = "Annotate type",
            icon = "",
            silent = true,
            noremap = true,
            buffer = ev.buf,
          },
          {
            "<Leader>aF",
            function()
              require('neogen').generate({ type = 'file' })
            end,
            desc = "Annotate file",
            icon = "󰷉",
            silent = true,
            noremap = true,
            buffer = ev.buf,
          },
        })
      end
    })
  end,
}
