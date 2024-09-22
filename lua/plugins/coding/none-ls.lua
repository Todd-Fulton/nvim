return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  ft = { "lua", "c", "cpp" },
  config = function()
    local null_ls = require "null-ls"
    null_ls.setup {
      sources = {
        null_ls.builtins.diagnostics.selene,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.stylua,
      },
    }
  end,
}
