return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        templ = {},
      },
      setup = {
        tailwindcss = function(_, opts)
          vim.list_extend(opts.filetypes, { "templ" })
          -- opts.init_options = {
          --   userLanguages = {
          --     templ = "html",
          --   },
          -- }
          return opts
        end,
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
