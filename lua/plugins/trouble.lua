return {
  "folke/trouble.nvim",
  cmd = "TroubleToggle",
  lazy = false,
  config = function()
    require("trouble").setup()
    vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { desc = "Toggle Trouble" })
    vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", { desc = "Quickfix List" })
    vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Diagnostics" })
  end,
}
