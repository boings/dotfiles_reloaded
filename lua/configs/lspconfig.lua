require("nvchad.configs.lspconfig").defaults()
local merge_tb = vim.tbl_deep_extend

local configs = require("nvchad.configs.lspconfig")
local on_init = configs.on_init
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
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")
local servers = { "html", "cssls", "volar"}

for _, lsp in ipairs(servers) do
	local opts = {
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	}

	local exists, settings = pcall(require, "configs.lsp.server-settings." .. lsp)
	if exists then
		opts = merge_tb("force", settings, opts)
	end

	lspconfig[lsp].setup(opts)
end

local config = {
	virtual_text = false,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		focusable = false,
		style = "minimal",
		border = "single",
		source = "always",
	},
}

vim.diagnostic.config(config)

lspconfig.ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/usr/lib/node_modules/@vue/language-server/",
        language = { "vue" },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
}

lspconfig.volar.setup {}

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

lspconfig.omnisharp.setup {
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid())},
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
}

lspconfig.pyright.setup {}

lspconfig.sqlls.setup {
  cmd = { "sql-language-server", "up", "--method", "stdio" },
}

