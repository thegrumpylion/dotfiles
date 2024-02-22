return {
  "danymat/neogen",
  dependencies = "nvim-treesitter/nvim-treesitter",
  config = function()
    require("neogen").setup({
      enabled = true,
      snippet_engine = "luasnip",
    })
  end,
  -- Uncomment next line if you want to follow only stable versions
  -- version = "*"
}
