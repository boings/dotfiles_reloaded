return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  lazy = false,
  opts = {
    focus = true,
    auto_preview = false, -- less noisy
    win = {
      size = { width = 60, height = 10 }, -- compact
    },
    modes = {
      diagnostics = {
        auto_close = true, -- close when no diagnostics
        win = { position = "bottom" },
      },
    },
  },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (project)" },
    { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
    { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix" },
    { "<leader>xl", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
  },
}
