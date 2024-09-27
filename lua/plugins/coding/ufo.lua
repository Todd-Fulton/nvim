local ft_foldable = {
  "c",
  "cpp",
  "lua",
  "rust",
  "python",
  "markdown",
  "javascript",
  "typescript",
  "asm",
  "html",
  "css",
  "cmake",
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
      -- monkey-patch ufo.model.buffer.attach
      local old_attach = require("ufo.model.buffer").attach
      ---@diagnostic disable-next-line: duplicate-set-field
      require("ufo.model.buffer").attach = function(self)
        if vim.fn.index(ft_foldable, vim.bo.filetype) ~= -1 then
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
          })
          vim.keymap.set("n", "zR", function() require("ufo").openAllFolds() end, {
            buffer = self.bufnr,
          })
          vim.keymap.set("n", "zM", function() require("ufo").closeAllFolds() end, {
            buffer = self.bufnr,
          })
          return old_attach(self)
        else
          vim.api.nvim_set_option_value("foldenable", false, { scope = "local" })
          vim.api.nvim_set_option_value("foldcolumn", "0", { scope = "local" })
          vim.api.nvim_set_option_value("statuscolumn", "", {
            scope = "local",
          })
          return false
        end
      end
      -- UFO folding
      opts = opts or {}
      require("ufo").setup(vim.tbl_extend("keep", opts, {}))
    end,
  },
}
