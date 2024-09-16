return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  opts = function(_, opts)
    local lazy_status = require('lazy.status')
    opts = opts or {}
    -- local my_colors = require("user.configs.ui.colors")
    opts = vim.tbl_deep_extend('force', opts, {
      options = {
        icons_enabled = true,
        theme = 'tokyonight',
        -- theme = {
        --   normal = {
        --     a = { fg = my_colors.fg_dark, bg = my_colors.bg_visual, gui = "bold" },
        --     b = { fg = my_colors.orange, bg = my_colors.bg_dark, gui = "italic" },
        --     c = { fg = my_colors.fg, bg = my_colors.transparent },
        --     x = { fg = my_colors.fg, bg = my_colors.transparent },
        --     y = { fg = my_colors.bg_search, bg = my_colors.bg_dark },
        --     z = { fg = my_colors.fg_dark, bg = my_colors.bg_visual, gui = "bold" },
        --   },
        -- },
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {
            -- "neo-tree",
          },
          winbar = {},
        },
        ignore_focus = {
          "neo-tree"
        },
        always_divide_middle = true,
        globalstatus = true,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = {
          {
            -- lualine lacks some modes like @recording, which
            -- noice hides, but provides an api for getting as
            -- a mode, but we format both sources to look the same.
            function()
              local noice = require("noice")
              if noice.api.status.mode.has() then
                -- keep noice and lualine the same
                local mode = require("noice").api.status.mode.get()
                  :gsub("-- ", "")
                  :gsub(" --", "")
                return mode == "VISUAL" and mode or mode:gsub("VISUAL", "V-")
              else
                return require("lualine.components.mode")()
              end
            end,
          },
        },
        lualine_b = { 'branch' },
        lualine_c = { 'diff', 'diagnostics',
          -- { 'aerial', padding = { left = 4, right = 0 } }
        },
        lualine_x = {
          {
            require("noice").api.status.search.get,
            cond = require("noice").api.status.search.has,
          },
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#FF9E64" },
          },
          { 'fileformat' },
          { 'filetype' },
        },
        lualine_y = { 'progress', 'location', },
        lualine_z = {
          {
            function()
              return os.date("%a %b %e")
            end,
          },
          function()
            return os.date("%l:%M %P")
          end,
        }
      },
      -- inactive_sections = {
      --   lualine_a = {},
      --   lualine_b = {},
      --   lualine_c = { 'filename' },
      --   lualine_x = { 'location' },
      --   lualine_y = {},
      --   lualine_z = {}
      -- },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {
        "neo-tree",
        "lazy",
        "overseer",
        "oil",
        "toggleterm",
        "trouble",
      },
    })
    return opts
  end,
}
