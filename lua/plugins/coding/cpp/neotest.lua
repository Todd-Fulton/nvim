---TODO: Need better lazy loading than based on ft
return {
  {
    "alfaix/neotest-gtest",
    lazy = true,
  },
  {
    "nvim-neotest/neotest",
    ft = {"cpp", "c", "cmake"},
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "alfaix/neotest-gtest",
    },
    opts = function()
      return {
        -- your neotest config here
        adapters = {
          require("neotest-gtest").setup {
            is_test_file = function(file_path)
              local test_extensions = {
                ["cpp"] = true,
                ["cc"] = true,
                ["cxx"] = true,
                ["c++"] = true,
              }
              local Path = require "plenary.path"
              local elems = vim.split(file_path, Path.path.sep, { plain = true })
              local filename = elems[#elems]
              if filename == "" then -- directory
                return false
              end
              local extsplit = vim.split(filename, ".", { plain = true })
              local extension = extsplit[#extsplit]
              local fname_last_part = extsplit[#extsplit - 1]
              local result = test_extensions[extension]
                  and (vim.startswith(filename, "test_") or vim.endswith(fname_last_part, "_test") or vim.startswith(
                    filename,
                    "tests_"
                  ) or vim.endswith(fname_last_part, "_tests"))
                or false
              return result
            end,
          },
        },
      }
    end,
  },
}
