local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    move = { "movement_move" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    cs = { "csharpier" },
    python = { "black" },
    sql = { "sqlfluff" },
  },

  format_on_save = {
    --   -- These options will be passed to conform.format()
    timeout_ms = 5000,
    lsp_fallback = true,
  },
  formatters = {
    movement_move = {
      command = "movement",
      stdin = false,
      timeout_ms = 15000, -- 15s
      args = function(_, ctx)
        return { "move", "fmt", "--file-path", ctx.filename }
      end,
      condition = function()
        return vim.fn.executable "movement" == 1
      end,
    },
  },
}

return options
