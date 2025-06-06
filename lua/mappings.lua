require "nvchad.mappings"

local map = vim.keymap.set

map("n", "<C-_>", "<cmd>ToggleTerm<cr>", {desc = "Terminal: Toggle with Ctrl-/" })
map("n", "<C-/>", "<cmd>ToggleTerm<cr>", {desc = "Terminal: Toggle with Ctrl-/" })

map("n", "<leader>`", "<cmd>b#<cr>", {desc = "Switch to previous buffer" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Trouble
map("n", "<leader>xx", "<cmd>TroubleToggle<CR>", { desc = "Toggle Trouble" })
map("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>", { desc = "Quickfix List" })
map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>", { desc = "Diagnostics" })

-- In terminal buffers: Move up window
map("t", "<C-k>", "<C-\\><C-n><C-w>k", {
  desc = "Terminal -> go to upper win"
})

-- Show line diagnostics
map("n", "<leader>ce", vim.diagnostic.open_float, {
  desc = "LSP: Line Diagnostics",
})

-- Jump list picker via Telescope
map("n", "<leader>j", function()
  require("telescope.builtin").jumplist()
end, {
    desc = "Jump: Telescope jumplist",
  })

-- Select all
map({ "n", "v" }, "<C-a>", "ggvG", {
  desc = "Select everything in buffer",
})

-- format current doc
map("n", "<leader>cf", function ()
  vim.lsp.buf.format({ async = true })
end,
  { desc = "LSP: Format buffer" }
)

-- close any buffer with q
map("n", "q", "<cmd>bdelete<cr>", {
  desc = "Close buffer",
})

-- toggle file explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", {
  desc = "Explorer: Toggle",
})

-- Pick from open buffers via telescope
map("n", "<leader>bb", "<cmd>Telescope buffers<cr>",
  {
    desc = "Buffers: Pick open buffer",
  })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
-- AUTOCMDS
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "qf", "man", "lspinfo", "NvimTree", "packer"},
  callback = function()
    map("n", "q", "<cmd>close<cr>", {
      buffer = true,
      desc = "Close window",
    })
  end,
})
