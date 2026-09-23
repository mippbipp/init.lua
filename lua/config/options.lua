-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.snacks_animate = false
vim.g.have_nerd_font = true

vim.opt.swapfile = false
vim.opt.updatetime = 50

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.breakindentopt = "shift:2"

vim.opt.cursorline = false
vim.opt.scrolloff = 8

vim.g.vscode = false -- see: https://www.lazyvim.org/extras/vscode
