-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Snacks explorer/picker dims dotfiles/hidden files via `NonText`,
-- which is near-invisible on a dark background.
local function undim_snacks_paths()
  vim.api.nvim_set_hl(0, "SnacksPickerPathHidden", { fg = "#858eb6" })
  vim.api.nvim_set_hl(0, "SnacksPickerPathIgnored", { fg = "#858eb6" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusIgnored", { fg = "#858eb6" })
  vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { fg = "#858eb6" })
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = undim_snacks_paths })
undim_snacks_paths()
