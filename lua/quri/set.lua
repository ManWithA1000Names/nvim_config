vim.opt.nu = true -- no idea
vim.opt.relativenumber = true
vim.opt.conceallevel = 0
vim.opt.completeopt = { "menuone", "noselect" }

vim.opt.errorbells = false -- no idea
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

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.guifont = "FiraCode Nerd Font:h10"

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.cmdheight = 1

vim.opt.updatetime = 100
vim.opt.shortmess:append("c")

vim.opt.colorcolumn = "100"

vim.opt.colorcolumn = "100"

vim.opt.timeoutlen = 250

vim.opt.pumheight = 10

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.foldlevel = 20
vim.opt.foldmethod = "indent"

-- Global Variables
vim.g.leader = " "
vim.g.mapleader = " "
vim.g.markdown_fenced_languages = {
	"ts=typescript",
}
