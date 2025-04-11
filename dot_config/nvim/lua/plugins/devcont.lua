return {
  {
    "https://codeberg.org/esensar/nvim-dev-container",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("devcontainer").setup({
        attach_mounts = {
          always = true,
          neovim_config = {
            enabled = true,
            options = { "readonly" },
          },
          neovim_data = {
            enabled = true,
            options = {},
          },
          -- Only useful if using neovim 0.8.0+
          neovim_state = {
            enabled = true,
            options = {},
          },
        },
      })
    end,
  },
}
