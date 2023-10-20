return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gdscript = {},
      terraformls = {},
      tflint = {},
      helm_ls = {},
      bufls = {},
    },
    setup = {
      clangd = function(_, opts)
        opts.capabilities.offsetEncoding = { "utf-16" }
      end,
      gdscript = function(_, opts)
        opts.flags = {
          debounce_text_changes = 150,
        }
      end,
    },
  },
}
