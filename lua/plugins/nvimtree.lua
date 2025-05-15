return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  config = function()
    local api = require("nvim-tree.api")

    require("nvim-tree").setup({
      on_attach = function (bufnr)
        local function opts(desc)
  return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

      api.config.mappings.default_on_attach(bufnr)

      vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
      vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
      end,
      view = {
        width = 30,
        side = "left",

      },
      filters = {
        dotfiles = false,
      },
    })
  end,
}
