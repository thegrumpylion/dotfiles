-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.opt.path = vim.opt.path + vim.fn.expand("$HOME/repos/github.com")
vim.opt.path = vim.opt.path + vim.fn.expand("$HOME/repos")

-- additional filetypes
vim.filetype.add({
  extension = {
    templ = "templ",
  },
})
