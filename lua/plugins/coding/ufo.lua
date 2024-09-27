local ft_ignore = {
  "neo-tree",
  "NeogitStatus",
  "NeogitCommitMessage",
  "alpha",
}

return {
  -- UFO folding
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        dependencies = {
          "mfussenegger/nvim-dap",
          "lewis6991/gitsigns.nvim",
        },
        config = function()
          local builtin = require "statuscol.builtin"
          require("statuscol").setup {
            relculright = true,
            segments = {
              { text = { builtin.foldfunc, "  " }, click = "v:lua.ScFa" },
              { text = { "%s" }, click = "v:lua.ScSa" },
              { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
            },
          }
        end,
      },
    },
    event = "BufReadPost",
    opts = {},
    config = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          -- TODO:
          --   NeogitDiffView should have folds and linenumbers, but no signs column, need
          --   to specifiy that specifically

          if vim.fn.index(ft_ignore, vim.bo.filetype) ~= -1 then
            require("ufo").detach()
            vim.api.nvim_set_option_value("foldenable", false, { scope = "local" })
            vim.api.nvim_set_option_value("foldcolumn", "0", { scope = "local" })
            vim.api.nvim_set_option_value("statuscolumn", "", {
              scope = "local",
              buffer = ev.bufm,
            })
          else
            vim.api.nvim_set_option_value("foldenable", true, { scope = "local" })
            vim.api.nvim_set_option_value("foldlevel", 99, { scope = "local" })
            vim.api.nvim_set_option_value("foldlevelstart", 99, { scope = "local" })
            vim.api.nvim_set_option_value("foldcolumn", "1", { scope = "local" })
            vim.api.nvim_set_option_value(
              "fillchars",
              [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]],
              { scope = "local" }
            )
            vim.api.nvim_set_option_value("statuscolumn", "%!v:lua.require('statuscol').get_statuscol_string()", {
              scope = "local",
              buffer = ev.bufm,
            })
            vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end, {
              buffer = ev.buf,
            })
            vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end, {
              buffer = ev.buf,
            })
          end
        end,
      })
      -- UFO folding
      require("ufo").setup(opts)
    end,
  },
}
