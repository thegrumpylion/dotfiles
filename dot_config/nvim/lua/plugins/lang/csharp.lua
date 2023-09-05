return {

  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "c_sharp" })
      end
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "Hoffs/omnisharp-extended-lsp.nvim" },
    opts = {
      servers = {
        omnisharp = {},
      },
      setup = {
        omnisharp = function(_, opts)
          opts.handlers = { ["textDocument/definition"] = require("omnisharp_extended").handler }
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

  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "Issafalcon/neotest-dotnet",
    },
    opts = {
      adapters = {
        ["neotest-dotnet"] = {},
      },
    },
  },
}
