-- ~/.config/nvim/lua/custom/chadrc.lua
local M = {}

-- style for our new module
vim.cmd("highlight St_relativepath guifg=#626a83 guibg=#2a2b36")

M.ui = {
  statusline = {
    theme = "default",  -- or "minimal", "block", etc.
    order = {
      "mode",
      "relativepath",   -- ← our custom module
      "file",
      "git",
      "%=",             -- divider
      "lsp_msg",
      "%=",
      "diagnostics",
      "lsp",
      "cwd",
      "cursor",
    },
    modules = {
      relativepath = function()
        -- get the buffer under the statusline window
        local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid or 0)
        local path = vim.api.nvim_buf_get_name(buf)
        if path == "" then return "" end
        -- show the directory (relative to cwd) + trailing slash
        return "%#St_relativepath#  " .. vim.fn.expand("%:.:h") .. " /"
      end,
    },
  },
}

return M
