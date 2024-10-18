return {
  {
    "jmbuhr/otter.nvim",
  },
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "otter" })
    end,
  },
}
