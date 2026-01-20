require "nvchad.options"

vim.opt.number = true
vim.opt.relativenumber = true

-- Ensure relative numbers persist after all plugins load
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.opt.number = true
    vim.opt.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd("InsertEnter", {
  pattern = "*",
  callback = function() vim.opt.relativenumber = false end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = "*",
  callback = function() vim.opt.relativenumber = true end,
})

vim.opt.clipboard:append("unnamedplus")

-- add yours here!

-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
