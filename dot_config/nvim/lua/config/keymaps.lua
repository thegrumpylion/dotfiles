-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<Leader>Ii", "<cmd>IconPickerNormal<cr>", opts)
vim.keymap.set("n", "<Leader>Iy", "<cmd>IconPickerYank<cr>", opts)
vim.keymap.set("i", "<C-i>", "<cmd>IconPickerInsert<cr>", opts)
