return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function(_, opts)
    opts = opts or {}
    local conf_transparent = true

    local bg = "#011628"
    local bg_dark = "#011423"
    local bg_highlight = "#18181F"
    local bg_search = "#0A64AC"
    local bg_visual = "#143254"
    local fg = "#4AC0F8"
    local fg_dark = "#54D0E9"
    local fg_gutter = "#323E47"
    local transparent = "#000000"

    -- comment
    opts = {
      style = "night",
      transparent = conf_transparent,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        sidebars = "transparent",
        floats = "transparent",
      },
      cache = true,
      dim_inactive = true,
      lualine_bold = true,
      on_colors = function(colors)
        colors.bg = conf_transparent and transparent or bg
        colors.bg_dark = conf_transparent and transparent or bg_dark
        colors.bg_highlight = bg_highlight
        colors.bg_popup = conf_transparent and transparent or bg_dark
        colors.bg_search = bg_search
        colors.bg_sidebar = conf_transparent and transparent or bg_dark
        colors.bg_statusline = conf_transparent and transparent or bg_dark
        colors.bg_visual = bg_visual
        colors.border = bg_dark
        colors.fg = fg
        colors.fg_dark = fg_dark
        colors.fg_float = fg
        colors.fg_gutter = fg_gutter
        colors.fg_sidebar = fg_dark
      end,
    }
    require('tokyonight').setup(opts)
    vim.cmd [[colorscheme tokyonight-night]]
  end,
}
