-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "norg", "md" },
--   callback = function()
--     local otter = require("otter")
--     -- table of embedded languages to look for.
--     -- default = nil, which will activate
--     -- any embedded languages found
--     local languages = nil
--
--     -- enable completion/diagnostics
--     -- defaults are true
--     local completion = true
--     local diagnostics = true
--     -- treesitter query to look for embedded languages
--     -- uses injections if nil or not set
--     local tsquery = nil
--
--     otter.activate(languages, completion, diagnostics, tsquery)
--   end,
-- })

vim.api.nvim_create_autocmd("LspAttach", {
  pattern = "*.md",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "marksman" then
      local util = require("lspconfig.util")
      if util.root_pattern(".jot")(args.file) then
        vim.lsp.buf_detach_client(args.buf, args.data.client_id)
      end
    end
  end,
})