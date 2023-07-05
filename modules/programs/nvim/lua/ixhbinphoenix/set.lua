
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.tgc = true
vim.opt.hidden = true
vim.opt.encoding = "utf-8"

vim.g.mapleader = " "

vim.g.node_host_prog = '/usr/bin/neovim-node-host'

vim.g.astro_typescript = 'enable'
