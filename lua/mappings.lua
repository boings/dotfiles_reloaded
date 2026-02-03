require "nvchad.mappings"

local map = vim.keymap.set

-- Ctrl+/ to toggle comment (both terminal representations)
map("n", "<C-/>", "gcc", { desc = "Toggle Comment", remap = true })
map("v", "<C-/>", "gc", { desc = "Toggle Comment", remap = true })
map("n", "<C-_>", "gcc", { desc = "Toggle Comment", remap = true })
map("v", "<C-_>", "gc", { desc = "Toggle Comment", remap = true })

map("n", "<leader>`", "<cmd>b#<cr>", { desc = "Switch to previous buffer" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- In terminal buffers: Move up window
map("t", "<C-k>", "<C-\\><C-n><C-w>k", {
  desc = "Terminal -> go to upper win",
})

-- Show line diagnostics
map("n", "<leader>ce", vim.diagnostic.open_float, {
  desc = "LSP: Line Diagnostics",
})

-- Jump between diagnostics
map("n", "]d", function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = "Next diagnostic" })

map("n", "[d", function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = "Previous diagnostic" })

map("n", "]e", function()
  vim.diagnostic.jump { count = 1, float = true, severity = vim.diagnostic.severity.ERROR }
end, { desc = "Next error" })

map("n", "[e", function()
  vim.diagnostic.jump { count = -1, float = true, severity = vim.diagnostic.severity.ERROR }
end, { desc = "Previous error" })

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
map("n", "<leader>cf", function()
  vim.lsp.buf.format { async = true }
end, { desc = "LSP: Format buffer" })

-- close buffer without closing window
map("n", "q", function()
  local bufs = vim.fn.getbufinfo { buflisted = 1 }
  if #bufs > 1 then
    -- Switch to previous buffer, then delete the one we were on
    local current = vim.api.nvim_get_current_buf()
    vim.cmd "bprevious"
    vim.api.nvim_buf_delete(current, {})
  else
    -- Last buffer - just delete it (will show empty buffer)
    vim.cmd "enew"
    local current = vim.api.nvim_get_current_buf()
    vim.cmd "bprevious"
    vim.api.nvim_buf_delete(current, { force = true })
  end
end, {
  desc = "Close buffer (keep window)",
})

-- toggle file explorer
map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", {
  desc = "Explorer: Toggle",
})

-- Pick from open buffers via telescope
map("n", "<leader>bb", "<cmd>Telescope buffers<cr>", {
  desc = "Buffers: Pick open buffer",
})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
--
-- CodeLens keymap
map("n", "<leader>cl", vim.lsp.codelens.run, { desc = "LSP: Run CodeLens" })

-- AUTOCMDS

-- Auto-refresh CodeLens
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  callback = function(args)
    local clients = vim.lsp.get_clients { bufnr = args.buf }
    for _, client in ipairs(clients) do
      if client.supports_method "textDocument/codeLens" then
        vim.lsp.codelens.refresh { bufnr = args.buf }
        break
      end
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help", "qf", "man", "lspinfo", "NvimTree", "packer" },
  callback = function()
    map("n", "q", "<cmd>close<cr>", {
      buffer = true,
      desc = "Close window",
    })
  end,
})

local ok, Terminal = pcall(require, "toggleterm.terminal")
if ok then
  local Term = Terminal.Terminal

  local horiz = Term:new { direction = "horizontal" }
  local vert = Term:new { direction = "vertical" }

  vim.keymap.set("n", "<leader>h", function()
    horiz:toggle()
  end, { desc = "Terminal (horizontal)" })
  vim.keymap.set("n", "<leader>v", function()
    vert:toggle()
  end, { desc = "Terminal (vertical)" })
end
