-- Function to read a JSON file and parse it into a Lua table
local function read_json_file(filepath)
  -- Read the file content
  local lines = vim.fn.readfile(filepath)
  -- Concatenate all lines into a single string
  local json_string = table.concat(lines, "\n")
  -- Decode the JSON string into a Lua table
  local lua_table = vim.json.decode(json_string)

  return lua_table
end

return {
  {
    "nvim-neorg/neorg",
    version = "*",
    config = function()
      read_json_file("/home/nikolas/ws.json")
      require("neorg").setup({
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/notes",
                mindns = "~/repos/greatliontech/mindns",
                semrel = "~/repos/greatliontech/semrel",
              },
            },
          },
          ["core.export"] = {},
          -- ["core.completion"] = {
          --   config = {
          --     engine = "nvim-cmp",
          --   },
          -- },
          ["core.presenter"] = {
            config = {
              zen_mode = "zen-mode",
            },
          },
        },
      })
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "neorg" })
    end,
  },
}
