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
      dashboard.button("SPC o", "  > Toggle file explorer"),
      dashboard.button("SPC f f", "󰱽  > Find file"),
      dashboard.button("SPC f g", "󱩾  > Find word"),
      dashboard.button("SPC f r", "󰥌  > Find recently opened"),
      dashboard.button("SPC S l", "󰦛  > Load Session"),
      dashboard.button("SPC f w", "󱅙  > Open Workspace"),
      dashboard.button("SPC f h", "󰘥  > Search help"),
      dashboard.button("SPC q ", "󰈆  > Quit Neovim"),
    }

    dashboard.config.opts.noautocmd = true

    vim.cmd [[autocmd FileType alpha setlocal nofoldenable]]
    return dashboard.config
  end,
}
