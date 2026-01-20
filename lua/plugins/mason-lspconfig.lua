return {
  "williamboman/mason-lspconfig.nvim",
  config = function()
    local platform = require("utils.platform")

    local ensure_installed = { "pyright", "sqlls" }

    -- Add omnisharp if dotnet is available
    -- Omnisharp works on all platforms but needs dotnet SDK for modern .NET
    -- or Mono for legacy .NET on Linux
    if platform.has_dotnet() or platform.has_mono() or platform.is_windows() then
      table.insert(ensure_installed, "omnisharp")
    end

    require("mason-lspconfig").setup({
      ensure_installed = ensure_installed,
    })
  end,
}
