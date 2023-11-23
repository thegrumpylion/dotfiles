return {
  {
    "andythigpen/nvim-coverage",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("coverage").setup()
    end,
  },
  -- {
  --   "cuducos/yaml.nvim",
  --   ft = { "yaml" },
  --   dependencies = {
  --     "nvim-treesitter/nvim-treesitter",
  --     "nvim-telescope/telescope.nvim",
  --   },
  -- },
  --
  -- {
  --   "akinsho/toggleterm.nvim",
  --   version = "*",
  --   config = true,
  -- },

  -- {
  --   "https://codeberg.org/esensar/nvim-dev-container",
  --   config = function()
  --     require("devcontainer").setup({})
  --   end,
  -- },

  -- {
  --   "brenoprata10/nvim-highlight-colors",
  --   config = function()
  --     require("nvim-highlight-colors").setup({})
  --   end,
  -- },

  -- {
  --   "f-person/git-blame.nvim",
  -- },

  -- {
  --   "ziontee113/icon-picker.nvim",
  --   config = function()
  --     require("icon-picker").setup({
  --       disable_legacy_commands = true,
  --     })
  --   end,
  --   dependencies = {
  --     "stevearc/dressing.nvim",
  --   },
  -- },
  --

  -- {
  --   "nvim-neotest/neotest",
  --   opts = {
  --     log_level = vim.log.levels.DEBUG,
  --   },
  -- },
}
