return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require'dap'
      local dap_configs = require'user.configs.dap.init'
      for adapter, map in pairs(dap_configs.adapters) do
        dap[adapter] = map
      end
      for config, map in pairs(dap_configs.configurations) do
        dap[config] = map
      end
    end,
  },
}
