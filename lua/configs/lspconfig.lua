local merge_tb = vim.tbl_deep_extend
local configs = require "nvchad.configs.lspconfig"
local on_init = configs.on_init
local on_attach = function(client, bufnr)
  local buf_map = function(mode, lhs, rhs, desc)
    if desc then
      desc = "LSP: " .. desc
    end
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end

  buf_map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
  buf_map("n", "gD", vim.lsp.buf.declaration, "Go to Declaration")
  buf_map("n", "gr", vim.lsp.buf.references, "References")
  buf_map("n", "gi", vim.lsp.buf.implementation, "Implementation")
  buf_map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
  buf_map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  buf_map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  buf_map("n", "<leader>f", function()
    vim.lsp.buf.format { async = true }
  end, "Format Buffer")
end
local capabilities = configs.capabilities

-- for _, lsp in ipairs(servers) do
-- 	local opts = {
-- 		on_init = on_init,
-- 		on_attach = on_attach,
-- 		capabilities = capabilities,
-- 	}
--
-- 	local exists, settings = pcall(require, "configs.lsp.server-settings." .. lsp)
-- 	if exists then
-- 		opts = merge_tb("force", settings, opts)
-- 	end
--
-- 	lspconfig[lsp].setup(opts)
-- end

vim.lsp.enable { "html", "lua_ls", "cssls", "vue_ls", "sqlls", "pyright", "ts_ls", "omnisharp", "rust_analyzer", "move" }

local vue_typescript_plugin_path = vim.fn.stdpath "data"
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin"

vim.lsp.config("ts_ls", {
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
  },
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = vue_typescript_plugin_path,
        language = { "vue" },
      },
    },
  },
})

local function hover_or_def()
  local params = vim.lsp.util.make_position_params(0, "utf-16")

  vim.lsp.buf_request(0, "textDocument/hover", params, function(_, result)
    local contents = result and result.contents
    -- server returns literal string "null" (not nil)
    if not contents or contents == "null" then
      vim.lsp.buf.definition()
      return
    end
    vim.lsp.buf.hover()
  end)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method "textDocument/completion" then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "References" })

    vim.keymap.set("n", "K", hover_or_def, { buffer = ev.buf, desc = "Hover (fallback to definition)" })
  end,
})

-- Only run this on Windows:
if vim.fn.has "win32" == 1 then
  local omnisharp_bin = vim.fn.stdpath "data" .. "/mason/packages/omnisharp/OmniSharp.exe"
  vim.lsp.config.omnisharp = {
    cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    on_attach = on_attach,
    capabilities = capabilities,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
  }
else
  vim.lsp.config.omnisharp = {
    cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    on_attach = on_attach,
    capabilities = capabilities,
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
  }
end

vim.lsp.config.omnisharp = {
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  enable_roslyn_analyzers = true,
  organize_imports_on_format = true,
}
