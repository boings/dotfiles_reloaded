return {
  "echasnovski/mini.bufremove",
  config = function()
    vim.keymap.set("n", "<leader>x", function()
      require("mini.bufremove").delete(0, false)
    end, { desc = "Close Buffer" })
  end,
}
