return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup()
    vim.keymap.set("n", "<leader>:", "<cmd>Telescope commands<CR>", { desc = "Command Palette" })
  end,
}
