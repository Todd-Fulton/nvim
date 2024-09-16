return {
  'goolord/alpha-nvim',
  -- cmd = "Alpha",
  opts = function ()
    local dashboard = require'alpha.themes.dashboard'
    dashboard.section.header.val = {
      [[ ╔────────────────────────────────────────────────────────────────────────────╗]],
      [[ │ █████╗ ██████╗  ██████╗██╗  ██╗                 ██████╗ ████████╗██╗    ██╗│]],
      [[ │██╔══██╗██╔══██╗██╔════╝██║  ██║                 ██╔══██╗╚══██╔══╝██║    ██║│]],
      [[ │███████║██████╔╝██║     ███████║                 ██████╔╝   ██║   ██║ █╗ ██║│]],
      [[ │██╔══██║██╔══██╗██║     ██╔══██║                 ██╔══██╗   ██║   ██║███╗██║│]],
      [[ │██║  ██║██║  ██║╚██████╗██║  ██║    ██╗██╗██╗    ██████╔╝   ██║   ╚███╔███╔╝│]],
      [[ │╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    ╚═╝╚═╝╚═╝    ╚═════╝    ╚═╝    ╚══╝╚══╝ │]],
      [[ ╚────────────────────────────────────────────────────────────────────────────╝]],
}
    dashboard.config.layout = {
      { type = "padding", val = vim.fn.max { 2, vim.fn.floor(vim.fn.winheight(0) * 0.2) } },
      dashboard.section.header,
      { type = "padding", val = 5 },
      dashboard.section.buttons,
      { type = "padding", val = 3 },
      dashboard.section.footer,
    }

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", "  > New File", "<CMD>ene<CR>"),
      dashboard.button("SPC o", "  > Toggle file explorer", "<CMD>Neotree<CR>"),
      dashboard.button("SPC ff", "󰱽  > Find file", "<CMD>Telescope find_files<CR>"),
      dashboard.button("SPC fg", "󱩾  > Find word", "<CMD>Telescope live_grep<CR>"),
      dashboard.button("SPC fr", "󰥌  > Find recently opened", "<CMD>Telescope oldfiles<CR>"),
      dashboard.button("SPC Sr", "󰦛  > Restore Session", "<CMD>SessionRestore<CR>"),
      dashboard.button("SPC fh", "󰘥  > Search help", "<CMD>Telescope help_tags<CR>"),
      dashboard.button("SPC q", "󰈆  > Quit Neovim", "<CMD>qa<CR>"),
    }

    dashboard.config.opts.noautocmd = true

    vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
    return dashboard.config
  end,
}
