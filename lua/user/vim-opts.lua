local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.numberwidth = 2
opt.wrap = false
opt.scrolloff = 10 -- lines to keep above/below cursor
opt.sidescrolloff = 8 -- columns to keep left/right cursor

opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.breakindent = true
opt.smartindent = true
opt.autoindent = true
opt.virtualedit = "block"
opt.inccommand = "split"
opt.backspace = "indent,eol,start"
opt.clipboard:prepend("unnamedplus")


-- searching
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- ui
opt.splitbelow = true
opt.splitright = true
opt.termguicolors = true
opt.background = "dark"
opt.cursorline = true

-- backup and swap files
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true -- yes, we want history, but not swap files
opt.sessionoptions = "buffers,curdir,folds,globals,tabpages,winpos,winsize,help,localoptions,terminal"

-- general file stuffs
opt.fileencoding = "utf-8"
opt.timeoutlen = 750
opt.updatetime = 100


vim.cmd "digraphs sA 119964" -- 𝒜
vim.cmd "digraphs sC 119966" -- 𝒞
vim.cmd "digraphs sD 119967" -- 𝒟
vim.cmd "digraphs sG 119970" -- 𝒢
vim.cmd "digraphs sJ 119973" -- 𝒥
vim.cmd "digraphs sK 119974" -- 𝒦
vim.cmd "digraphs sN 119977" -- 𝒩
vim.cmd "digraphs sO 119978" -- 𝒪
vim.cmd "digraphs sP 119979" -- 𝒫
vim.cmd "digraphs sQ 119980" -- 𝒬
vim.cmd "digraphs sS 119982" -- 𝒮
vim.cmd "digraphs sT 119983" -- 𝒯
vim.cmd "digraphs sU 119984" -- 𝒰
vim.cmd "digraphs sV 119985" -- 𝒱
vim.cmd "digraphs sW 119986" -- 𝒲
vim.cmd "digraphs sX 119987" -- 𝒳
vim.cmd "digraphs sY 119988" -- 𝒴
vim.cmd "digraphs sZ 119989" -- 𝒵
vim.cmd "digraphs sa 119990" -- 𝒶
vim.cmd "digraphs sb 119991" -- 𝒷
vim.cmd "digraphs sc 119992" -- 𝒸
vim.cmd "digraphs sd 119993" -- 𝒹
vim.cmd "digraphs sf 119995" -- 𝒻
vim.cmd "digraphs sh 119997" -- 𝒽
vim.cmd "digraphs si 119998" -- 𝒾
vim.cmd "digraphs sj 119999" -- 𝒿
vim.cmd "digraphs sk 120000" -- 𝓀
vim.cmd "digraphs sl 120001" -- 𝓁
vim.cmd "digraphs sm 120002" -- 𝓂
vim.cmd "digraphs sn 120003" -- 𝓃
vim.cmd "digraphs sp 120005" -- 𝓅
vim.cmd "digraphs sq 120006" -- 𝓆
vim.cmd "digraphs sr 120007" -- 𝓇
vim.cmd "digraphs ss 120008" -- 𝓈
vim.cmd "digraphs st 120009" -- 𝓉
vim.cmd "digraphs su 120010" -- 𝓊
vim.cmd "digraphs sv 120011" -- 𝓋
vim.cmd "digraphs sw 120012" -- 𝓌
vim.cmd "digraphs sx 120013" -- 𝓍
vim.cmd "digraphs sy 120014" -- 𝓎
vim.cmd "digraphs sz 120015" -- 𝓏

-- When opening a terminal
-- Disable number, relativenumber signcolmn,
-- Enable line wrap
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function (_)
    vim.api.nvim_set_option_value("number", false, {
      scope = "local",
    })
    vim.api.nvim_set_option_value("relativenumber", false, {
      scope = "local",
    })
    vim.api.nvim_set_option_value("signcolumn", nil, {
      scope = "local",
    })
    vim.api.nvim_set_option_value("wrap", true, {
      scope = "local",
    })
  end
})

-- For C++ files, set indent width to 4
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp" },
  callback = function ()
    vim.api.nvim_set_option_value("shiftwidth", 4, {
      scope = "local",
    })
    vim.api.nvim_set_option_value("tabstop", 4, {
      scope = "local",
    })
  end
})

