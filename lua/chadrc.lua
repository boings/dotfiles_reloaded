-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "rosepine",

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

-- Custom statusline highlight
vim.cmd("highlight St_relativepath guifg=#626a83 guibg=#2a2b36")

M.ui = {
  tabufline = {
    lazyload = false,
  },
  statusline = {
    theme = "default",
    order = {
      "mode",
      "relativepath",
      "file",
      "git",
      "%=",
      "lsp_msg",
      "%=",
      "diagnostics",
      "lsp",
      "cwd",
      "cursor",
    },
    modules = {
      relativepath = function()
        local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
        local path = vim.api.nvim_buf_get_name(buf)
        if path == "" then
          return ""
        end
        return "%#St_relativepath#  " .. vim.fn.expand("%:.:h") .. " /"
      end,
    },
  },
}

return M
