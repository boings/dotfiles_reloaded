-- C#/.NET development support
-- Handles both legacy .NET Framework (<4.8) and modern .NET Core/5+
-- With platform-specific handling for Windows, Linux, and WSL

return {
  {
    -- Omnisharp-extended for better go-to-definition (decompilation support)
    "Hoffs/omnisharp-extended-lsp.nvim",
    ft = "cs",
  },
  {
    -- Extra C# functionality
    "iabdelkareem/csharp.nvim",
    ft = "cs",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
      "Tastyep/structlog.nvim",
    },
    config = function()
      local platform = require("utils.platform")

      require("csharp").setup({
        lsp = {
          -- We configure omnisharp separately in lspconfig
          enable = false,
        },
        dap = {
          -- Enable DAP support if netcoredbg is available
          adapter_name = "coreclr",
        },
      })

      -- C#-specific keymaps
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "cs",
        callback = function(args)
          local opts = { buffer = args.buf }

          -- Run project
          vim.keymap.set("n", "<leader>dr", function()
            if platform.has_dotnet() then
              vim.cmd("!dotnet run")
            else
              vim.notify("dotnet CLI not found", vim.log.levels.ERROR)
            end
          end, vim.tbl_extend("force", opts, { desc = "Dotnet Run" }))

          -- Build project
          vim.keymap.set("n", "<leader>db", function()
            if platform.has_dotnet() then
              vim.cmd("!dotnet build")
            else
              vim.notify("dotnet CLI not found", vim.log.levels.ERROR)
            end
          end, vim.tbl_extend("force", opts, { desc = "Dotnet Build" }))

          -- Test project
          vim.keymap.set("n", "<leader>dt", function()
            if platform.has_dotnet() then
              vim.cmd("!dotnet test")
            else
              vim.notify("dotnet CLI not found", vim.log.levels.ERROR)
            end
          end, vim.tbl_extend("force", opts, { desc = "Dotnet Test" }))

          -- Restore packages
          vim.keymap.set("n", "<leader>dp", function()
            if platform.has_dotnet() then
              vim.cmd("!dotnet restore")
            else
              vim.notify("dotnet CLI not found", vim.log.levels.ERROR)
            end
          end, vim.tbl_extend("force", opts, { desc = "Dotnet Restore" }))

          -- Show project info
          vim.keymap.set("n", "<leader>di", function()
            local proj_type, target = platform.detect_dotnet_project_type()
            if proj_type then
              vim.notify(
                string.format("Project: %s\nTarget: %s", proj_type, target or "unknown"),
                vim.log.levels.INFO,
                { title = ".NET Project Info" }
              )
            else
              vim.notify("No .csproj found", vim.log.levels.WARN)
            end
          end, vim.tbl_extend("force", opts, { desc = "Dotnet Project Info" }))
        end,
      })

      -- WSL-specific warnings for legacy .NET
      if platform.is_wsl() then
        vim.api.nvim_create_autocmd("BufReadPost", {
          pattern = "*.csproj",
          callback = function()
            local proj_type, target = platform.detect_dotnet_project_type(vim.fn.expand("%:p"))
            if proj_type == "legacy" then
              vim.notify(
                string.format(
                  "Legacy .NET Framework project detected (%s).\n"
                    .. "Building/running legacy projects in WSL requires Windows tools.\n"
                    .. "Consider using Windows terminal or VS for full compatibility.",
                  target or "unknown version"
                ),
                vim.log.levels.WARN,
                { title = "WSL + Legacy .NET", timeout = 10000 }
              )
            end
          end,
        })
      end
    end,
  },
}
