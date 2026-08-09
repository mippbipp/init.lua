-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-p>", "<cmd>cprev<CR>zz")

-- line diagnostics
vim.keymap.del("n", "<leader>cd") -- unmap
vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Remap movement keys for wrapped lines
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("v", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
vim.keymap.set("v", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- map $ and 0 to work with wrapped lines
vim.keymap.set("n", "$", "g$")
vim.keymap.set("n", "0", "g0")

vim.keymap.set("n", "Q", "<nop>")

-- void register
vim.keymap.set({ "n", "v" }, "<leader>i", '"_d', {
  desc = "Delete to void register",
})
vim.keymap.set({ "n", "v" }, "<leader>r", '"_c', {
  desc = "Change to void register",
})
