return {
  "MeanderingProgrammer/render-markdown.nvim",
  cmd = "RenderMarkdown",
  ft = function()
    local plugin = require("lazy.core.config").spec.plugins["render-markdown.nvim"]
    local opts = require("lazy.core.plugin").values(plugin, "opts", false)
    return opts.file_types or { "markdown" }
  end,
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        opts = opts or {}
        opts.ensure_installed = opts.ensure_installed or {}
        if opts.ensure_installed ~= "all" then
          local set = {
            ["html"] = true,
            ["markdown"] = true,
            ["markdown_inline"] = true,
          }
          for _, k in ipairs(opts.ensure_installed) do
            set[k] = true
          end
          opts.ensure_installed = vim.tbl_keys(set)
          return opts
        end
      end,
    },
  },
}
