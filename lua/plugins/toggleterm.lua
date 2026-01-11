return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>h", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal (horizontal)" },
      { "<leader>v", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Terminal (vertical)" },
    },
    config = true,
  },
}
