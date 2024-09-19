local ft_ignore = {
  "neo-tree", "NeogitStatus", "alpha"
}

return {
  -- UFO folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        config = function()
          local builtin = require("statuscol.builtin")
          require("statuscol").setup({
            ft_ignore = ft_ignore,
            relculright = true,
            segments = {
              { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
              { text = { "%s" },                  click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          })
        end,
      },
    },
    event = "BufReadPost",
    opts = {},

    config = function(_, opts)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = ft_ignore,
        callback = function()
          require('ufo').detach()
          vim.api.nvim_set_option_value("foldenable", false, { scope = "local" })
          vim.api.nvim_set_option_value("foldcolumn", "0", { scope = "local" })
        end,
      })
      -- UFO folding
      require("ufo").setup(opts)
      vim.keymap.set("n", "zR", function()
        require("ufo").openAllFolds()
      end)
      vim.keymap.set("n", "zM", function()
        require("ufo").closeAllFolds()
      end)
    end,
  },
}
