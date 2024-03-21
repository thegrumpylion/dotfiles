return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        templ = {},
        tailwindcss = {
          filetypes_include = { "templ" },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "templ" })
      end
    end,
  },
}
