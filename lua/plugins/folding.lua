return {
  "kevinhwang91/nvim-ufo",
  dependencies = {
    "kevinhwang91/promise-async",
  },
  event = "BufReadPost",
  config = function()
    vim.o.foldcolumn = "1"
    vim.o.foldlevel = 99
    vim.o.foldenable = true
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

    require("ufo").setup()
  end,
}
