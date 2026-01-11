return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
      vim.keymap.set("n", "<leader>:", "<cmd>Telescope commands<CR>", { desc = "Command Palette" })
    end,
  },
  {
    "rcarriga/nvim-notify",
    lazy = false,
    config = function()
      vim.notify = require("notify")
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function ()
      require("mason-lspconfig").setup {
        ensure_installed = { "omnisharp", "pyright", "sqlls" }
      }
    end,
  },
  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPost",
    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
    }
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
      require "custom.plugins.cmp"
    end,
  },
  {
    "tpope/vim-fugitive",
    event = "BufRead"
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    lazy = false,
    config = function()
      require("trouble").setup()
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { desc = "Toggle Trouble" })
      vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", { desc = "Quickfix List" })
      vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Diagnostics" })
    end,
  },
  {
    "rhysd/conflict-marker.vim",
    event = "BufRead"
  },
  {
    "nvim-treesitter/nvim-treesitter-context"
  },
  {
    "tpope/vim-rhubarb",
    event = "BufRead"
  },
  {
    "akinsho/bufferline.nvim",
    lazy = false,
    opts = {
      options = {
        numbers = "ordinal",
      },
    },
  },
  {
    "echasnovski/mini.bufremove",
    config = function()
      vim.keymap.set("n", "<leader>x", function()
        require("mini.bufremove").delete(0, false)
      end, { desc = "Close Buffer" })
    end,
  },
  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
