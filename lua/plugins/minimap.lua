return {
  "echasnovski/mini.map",
  event = "BufReadPost",
  config = function()
    local map = require("mini.map")
    map.setup({
      integrations = {
        map.gen_integration.builtin_search(),
        map.gen_integration.diagnostic(),
        map.gen_integration.gitsigns(),
      },
      symbols = {
        encode = map.gen_encode_symbols.dot("4x2"),
        scroll_line = "▶",
        scroll_view = "┃",
      },
      window = {
        side = "right",
        width = 15,
        winblend = 50,
        show_integration_count = false,
      },
    })

    -- Auto-open minimap on buffer enter
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        if vim.bo.buftype == "" then
          map.open()
        end
      end,
    })

    vim.keymap.set("n", "<leader>mm", map.toggle, { desc = "Toggle Minimap" })
  end,
}
