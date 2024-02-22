return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        regols = {
          cmd = {
            "regols",
          },
          filetypes = {
            "rego",
          },
          root_dir = require("lspconfig.util").root_pattern(".git"),
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "rego" })
      end
    end,
  },
}
