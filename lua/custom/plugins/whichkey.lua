return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      -- key = { name = "Group Name" }
      defaults = {
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
