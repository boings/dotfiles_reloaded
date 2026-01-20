return {
{
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  version = "*",
  ---@type snacks.Config
  dependencies = {
      "MunifTanjim/nui.nvim",
    },
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
  },
  keys = {
      {
        "<leader>:",
        function ()
          require("snacks").picker.command_history()
        end,
        desc = "Command History (snacks)"
      }
    }
}
}
