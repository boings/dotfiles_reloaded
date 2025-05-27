return {
  {
    "stevear/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        win_options = {
          winblend = 10,
        },
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" },
      },
    },
  },
}
