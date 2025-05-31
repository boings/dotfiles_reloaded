-- ~/.config/nvim/lua/custom/plugins/snipe.lua
return {
  {
    "leath-dub/snipe.nvim",
    -- load on-demand when we hit <leader>h (or any key that calls it)
    cmd = { "Snipe" },
    keys = {
      -- Just in case you want a separate “gb” mapping later:
      -- { "gb", function() require("snipe").open_buffer_menu() end, desc = "Snipe: Buffer Menu" },
    },
    opts = {
      -- You can pass Snipe’s options here if you want; the defaults work well:
      --   popup_height = "50%",
      --   popup_width  = "70%",
      --   follow_cursor = true,
      --   keymap = { next = "<Down>", prev = "<Up>", accept = "<CR>", close = "<Esc>" },
    },
    config = function(_, opts)
      -- If you want to tweak Snipe’s options, pass `opts` into setup(). Otherwise, an empty table is fine.
      require("snipe").setup(opts)
    end,
  },
}
