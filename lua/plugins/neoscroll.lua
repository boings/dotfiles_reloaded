return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  config = function()
    -- Clear any existing mappings first
    local keymap = vim.keymap.set
    local opts = { silent = true }

    require("neoscroll").setup {
      mappings = {}, -- We'll set these manually to avoid conflicts
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      easing = "quadratic",
      performance_mode = false,
    }

    local neoscroll = require("neoscroll")
    local modes = { "n", "v", "x" }

    keymap(modes, "<C-u>", function() neoscroll.ctrl_u({ duration = 150 }) end, opts)
    keymap(modes, "<C-d>", function() neoscroll.ctrl_d({ duration = 150 }) end, opts)
    keymap(modes, "<C-b>", function() neoscroll.ctrl_b({ duration = 200 }) end, opts)
    keymap(modes, "<C-f>", function() neoscroll.ctrl_f({ duration = 200 }) end, opts)
    keymap(modes, "<C-y>", function() neoscroll.scroll(-0.1, { move_cursor = false, duration = 50 }) end, opts)
    keymap(modes, "<C-e>", function() neoscroll.scroll(0.1, { move_cursor = false, duration = 50 }) end, opts)
    keymap(modes, "zt", function() neoscroll.zt({ half_win_duration = 100 }) end, opts)
    keymap(modes, "zz", function() neoscroll.zz({ half_win_duration = 100 }) end, opts)
    keymap(modes, "zb", function() neoscroll.zb({ half_win_duration = 100 }) end, opts)
  end,
}
