return {
  "stevearc/aerial.nvim",
  lazy = false,
  config = function ()
    require("aerial").setup {
      layout = {
        min_width = 20,
        default_direction = "right",
      },
      attach_mode = "window",
      open_automatic = false,
      backends = { "lsp", "treesitter" },
    }

    vim.keymap.set("n", "<leader>oo", "<cmd>AerialToggle<CR>", { desc = "Toggle Outline"})
  end,
}
