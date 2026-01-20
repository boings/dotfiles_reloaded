local platform = require("utils.platform")

local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    move = { "movement_move" },
    -- css = { "prettier" },
    -- html = { "prettier" },
    cs = { "csharpier", "dotnet_format", stop_after_first = true },
    python = { "black" },
    sql = { "sqlfluff" },
  },

  format_on_save = {
    timeout_ms = 5000,
    lsp_fallback = true,
  },

  formatters = {
    movement_move = {
      command = "movement",
      stdin = false,
      timeout_ms = 15000,
      args = function(_, ctx)
        return { "move", "fmt", "--file-path", ctx.filename }
      end,
      condition = function()
        return vim.fn.executable("movement") == 1
      end,
    },

    -- CSharpier - preferred formatter for C#
    csharpier = {
      command = "dotnet-csharpier",
      args = { "--write-stdout" },
      stdin = true,
      condition = function()
        -- CSharpier requires dotnet and works on all platforms
        return platform.has_dotnet() and vim.fn.executable("dotnet-csharpier") == 1
      end,
    },

    -- dotnet format - fallback, works with both legacy and modern .NET
    dotnet_format = {
      command = "dotnet",
      args = function(_, ctx)
        return { "format", "--include", ctx.filename, "--no-restore" }
      end,
      stdin = false,
      condition = function()
        if not platform.has_dotnet() then
          return false
        end
        -- Check if we're in a .NET project
        local csproj = vim.fn.glob("*.csproj", false, true)
        if #csproj == 0 then
          csproj = vim.fn.glob("**/*.csproj", false, true)
        end
        return #csproj > 0
      end,
    },
  },
}

return options
