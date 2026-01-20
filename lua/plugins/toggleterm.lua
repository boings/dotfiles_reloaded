return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { "<leader>h", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal (horizontal)" },
      { "<leader>v", "<cmd>ToggleTerm direction=vertical<cr>", desc = "Terminal (vertical)" },
    },
    config = function()
      local platform = require("utils.platform")

      local shell = vim.o.shell
      if platform.is_windows() then
        -- Prefer PowerShell on Windows
        if vim.fn.executable("pwsh") == 1 then
          shell = "pwsh"
        elseif vim.fn.executable("powershell") == 1 then
          shell = "powershell"
        end
      end

      require("toggleterm").setup({
        shell = shell,
        -- WSL-specific: Can open Windows terminal if needed
        on_create = function(term)
          if platform.is_wsl() then
            -- Set environment variable to help child processes know they're in WSL
            vim.fn.setenv("NVIM_IN_WSL", "1")
          end
        end,
      })

      -- Add command to open Windows terminal from WSL (useful for legacy .NET)
      if platform.is_wsl() then
        vim.api.nvim_create_user_command("WinTerm", function()
          vim.fn.system("cmd.exe /c start cmd.exe")
        end, { desc = "Open Windows terminal from WSL" })

        vim.api.nvim_create_user_command("WinPwsh", function()
          vim.fn.system("powershell.exe &")
        end, { desc = "Open PowerShell from WSL" })
      end
    end,
  },
}
