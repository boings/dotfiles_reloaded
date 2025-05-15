require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls" }
local nvlsp = require "nvchad.configs.lspconfig"
local lspconfig = require'lspconfig'
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local capabilities = cmp_nvim_lsp.default_capabilities(vim.lsp.protocol.make_client_capabilities())

local on_attach = function (client, bufnr)
  local buf_map = function (mode, lhs, rhs, desc)
    if desc then desc = "LSP: " .. desc end
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  buf_map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
  buf_map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
  buf_map("n", "gr", vim.lsp.buf.references, "References")
  buf_map("n", "gi", vim.lsp.buf.implementation, "Implementation")
  buf_map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
  buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  buf_map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  buf_map("n", "<leader>f", function() vim.lsp.buf.format { async = true } end, "Format Buffer")
end

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
}

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      imports = {
        granularity = {
          group = "module",
        },
        prefix = "self",
      },
      cargo = {
        allFeatures = true,
      },
      procMacro = {
        enable = true,
      },
      assist = {
        importEnforceGranularity = true, importPrefix = "by_self"
      },
      inlayHints = {
        lifetimeElisionHints = {
          enable = true
        }
      },
    }
  }
})

for _, lsp in ipairs(servers) do
  lspconfig(lsp).setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities
  }
end

lspconfig.omnisharp.setup {
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid())},
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
}

lspconfig.pyright.setup {}

lspconfig.sqlls.setup {
  cmd = { "sql-language-server", "up", "--method", "stdio" },
}

-- read :h vim.lsp.config for changing options of lsp servers 
