return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      gdscript = {},
      bufls = {},
      cucumber_language_server = {
        settings = {
          glue = {
            "src/steps/*.ts",
          },
        },
      },
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
