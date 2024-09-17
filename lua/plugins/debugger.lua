return {
  {
    "mfussenegger/nvim-dap",
    ft = {"cpp", "c", "lua", "asm" },
    config = function()
      local dap = require 'dap'
      local dap_configs = require 'user.configs.dap.init'
      for adapter, map in pairs(dap_configs.adapters) do
        dap[adapter] = map
      end
      for config, map in pairs(dap_configs.configurations) do
        dap[config] = map
      end
      require ('dapui').setup()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio"
    },
    lazy = true,
    opts = {},
  }
}
