return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      bufls = {},
      cucumber_language_server = {
        settings = {
          glue = {
            "src/steps/*.ts",
          },
        },
      },
      tofu_ls = {},
    },
    setup = {
      gdscript = function(_, opts)
        opts.flags = {
          debounce_text_changes = 150,
        }
      end,
    },
  },
}
