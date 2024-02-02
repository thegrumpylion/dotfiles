return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "rego" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        regols = {
          --- that's what the doc of groovy-language-server say to do
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
}
