return {

  -- Add C# to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "c_sharp" })
      end
    end,
  },

  -- Correctly setup lspconfig for C# 🚀
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Ensure mason installs the server
        omnisharp = {},
      },
      -- configure omnisharp to fix the semantic tokens bug (really annoying)
      setup = {
        omnisharp = function(_, _)
          require("lazyvim.util").on_attach(function(client, _)
            if client.name == "omnisharp" then
              ---@type string[]
              local tokenModifiers = client.server_capabilities.semanticTokensProvider.legend.tokenModifiers
              for i, v in ipairs(tokenModifiers) do
                tokenModifiers[i] = v:gsub(" ", "_")
              end
              ---@type string[]
              local tokenTypes = client.server_capabilities.semanticTokensProvider.legend.tokenTypes
              for i, v in ipairs(tokenTypes) do
                tokenTypes[i] = v:gsub(" ", "_")
              end
            end
          end)
          return false
        end,
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "williamboman/mason.nvim",
      optional = true,
      opts = function(_, opts)
        if type(opts.ensure_installed) == "table" then
          vim.list_extend(opts.ensure_installed, { "netcoredbg", "csharpier" })
        end
      end,
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["netcoredbg"] then
        require("dap").adapters["netcoredbg"] = {
          type = "executable",
          command = require("mason-registry").get_package("netcoredbg"):get_install_path() .. "/netcoredbg",
          args = { "--interpreter=vscode" },
        }
      end
      dap.configurations.cs = {
        {
          type = "netcoredbg",
          request = "launch",
          name = "Launch file",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },
}
