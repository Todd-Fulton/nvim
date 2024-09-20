local ft = { "lua", "c", "cpp" }
return {
  "danymat/neogen",
  -- Uncomment next line if you want to follow only stable versions
  -- version = "*",
  dependencies = {
    "L3MON4D3/LuaSnip"
  },
  opts = {
    snippet_engine = "luasnip",
    languages = {
      lua = { template = { annotation_convention = "ldoc" } },
    },
  },
  ft = ft,
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = ft,
      callback = function(ev)
        require("which-key").add({
          { "<Leader>a", group = "Annotate", icon = "" },
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
            --- [TODO:description]
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
