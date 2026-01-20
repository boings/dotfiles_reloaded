return {
  "nvim-treesitter/nvim-treesitter-context",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  lazy = false,
  config = function()
    require("treesitter-context").setup {
      enable = true,
      max_lines = 5,
      min_window_height = 0,
      line_numbers = true,
      multiline_threshold = 20,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
      zindex = 20,
    }

    vim.keymap.set("n", "<leader>tc", "<cmd>TSContextToggle<CR>", { desc = "Toggle Treesitter Context" })
    vim.keymap.set("n", "<leader>oo", "<cmd>AerialToggle<CR>", { desc = "Toggle Outline" })
  end,
}
