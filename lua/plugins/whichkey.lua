return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- key = { name = "Group Name" }
      defaults = {
        ["<leader>h"] = { name = "Snipe" },
        ["<leader>ha"] = {
          "<cmd>lua require('snipe').open_buffer_menu()<cr>",
          "Snipe: Buffer Menu",
        },
        ["<leader>hl"] = {
          "<cmd>lua require('snipe').open_buffer_locations()<cr>",
          "Snipe: Buffer Locations",
        },
        ["<leader>c"] = { name = "Code"      },
        ["<leader>e"] = { name = "Explorer"  },
        ["<leader>b"] = { name = "Buffers"   },
        ["<leader>j"] = { name = "Jumps"     },
        ["<leader>cf"] = { name = "Format"   },
        ["<leader>ce"] = { name = "Diagnostics" },
        -- add any others you like…
      },
    },
  },
}
