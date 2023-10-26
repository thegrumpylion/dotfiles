return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gdscript = {},
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
