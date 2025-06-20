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
--
-- Path to vue ls depending on system.
local volar_path
if vim.fn.has("linux") then
  volar_path = "/usr/lib/node_modules/@vue/language-server/"
elseif vim.fn.has("macunix") then
  volar_path = "/usr/local/lib/node_modules/@vue/language-server/"
end

lspconfig.ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = volar_path,
        language = { "vue" },
      },
    },
  },
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  settings = {
    typescript = {
      tsserver = {
        useSyntaxServer = false,
      },
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      }
    }
  }
}

lspconfig.volar.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact", "json"},
  root_dir = lspconfig.util.root_pattern(
    "vue.config.js",
      "vue.config.ts",
    "nuxt.config.js",
    "nuxt.config.ts"
  ),
  init_options = {
    vue = {
      hybridMode = false,
    },
  },
  settings = {
    typescript = {
      inlayHints = {
        enumMemberValues = {
          enabled = true,
        },
        functionLikeReturnTypes = {

          enabled = true,
        },
        propertyDeclarationTypes = {
          enabled = true,
        },
        parameterTypes = {
          enabled = true,
          suppressWhenArgumentMatchesName = true,
        },
        variableTypes = {
          enabled = true,
        },
      },
    },
  },
}

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

-- Only run this on Windows:
if vim.fn.has("win32") == 1 then
  -- Mason installs OmniSharp under stdpath("data").."/mason/packages/omnisharp/"
  -- On Windows that folder contains OmniSharp.exe
  local omnisharp_root = vim.fn.stdpath("data") .. "/mason/packages/omnisharp"
  local omnisharp_bin  = omnisharp_root .. "/OmniSharp.exe"

  -- You may want to double-check in your file explorer that OmniSharp.exe lives there.
  -- If Mason has changed its path, adjust the 'omnisharp_bin' accordingly.

  lspconfig.omnisharp.setup({
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    on_attach   = on_attach,
    capabilities = capabilities,

    -- (Optional) Add any OmniSharp-specific settings here:
    -- enable_roslyn_analyzers = true,
    -- organize_imports_on_format = true,
    -- etc.
  })
end

lspconfig.omnisharp.setup {
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid())},
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
}

lspconfig.sqlls.setup {
  cmd = { "sql-language-server", "up", "--method", "stdio" },
}

