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
      yamlls = {
        settings = {
          yaml = {
            schemas = {
              ["/home/nikolas/repos/thegrumpylion/grpc-test/schema.json"] = ".cases/*.{yml,yaml}",
            },
          },
        },
      },
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
