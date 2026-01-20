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

vim.lsp.enable { "html", "lua_ls", "cssls", "vue_ls", "sqlls", "pyright", "ts_ls", "omnisharp", "move" }

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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "move",
  callback = function(args)
    local hover = require "utils.move_hover"
    vim.keymap.set("n", "K", hover.hover_or_doc_fallback, { buffer = args.buf, desc = "Hover / doc fallback" })
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end

    if client:supports_method "textDocument/completion" then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = ev.buf, desc = "Go to declaration" })
    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "References" })

    -- Only set K for Move buffers
    if vim.bo[ev.buf].filetype == "move" then
      vim.keymap.set("n", "K", function()
        local hover = require "utils.move_hover"
        hover.hover_toggle_focus(function()
          hover.hover_or_doc_fallback()
        end)
      end, { buffer = ev.buf, desc = "Hover / doc fallback" })
    else
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "LSP Hover" })
    end
  end,
})

-- C#/Omnisharp configuration with platform detection
local platform = require("utils.platform")

local function get_omnisharp_cmd()
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages/omnisharp"

  if platform.is_windows() then
    -- Windows: Use .exe from Mason
    local exe_path = mason_path .. "/OmniSharp.exe"
    if vim.fn.filereadable(exe_path) == 1 then
      return { exe_path, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
    end
  elseif platform.is_wsl() then
    -- WSL: Prefer Linux omnisharp, but can use Windows exe for legacy .NET projects
    -- For modern .NET, Linux omnisharp works fine
    local linux_path = mason_path .. "/omnisharp"
    if vim.fn.filereadable(linux_path) == 1 then
      return { linux_path, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
    end
    -- Fallback to system omnisharp
    if platform.executable("omnisharp") then
      return { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
    end
  else
    -- Linux/macOS: Use system omnisharp or Mason-installed
    local linux_path = mason_path .. "/omnisharp"
    if vim.fn.filereadable(linux_path) == 1 then
      return { linux_path, "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
    end
    if platform.executable("omnisharp") then
      return { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
    end
  end

  -- Final fallback
  return { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
end

vim.lsp.config("omnisharp", {
  cmd = get_omnisharp_cmd(),
  on_attach = function(client, bufnr)
    -- Call the standard on_attach
    on_attach(client, bufnr)

    -- Use omnisharp-extended for better go-to-definition (supports decompilation)
    local ok, omnisharp_extended = pcall(require, "omnisharp_extended")
    if ok then
      vim.keymap.set("n", "gd", function()
        omnisharp_extended.lsp_definition()
      end, { buffer = bufnr, desc = "Go to Definition (omnisharp-extended)" })

      vim.keymap.set("n", "gr", function()
        omnisharp_extended.lsp_references()
      end, { buffer = bufnr, desc = "References (omnisharp-extended)" })

      vim.keymap.set("n", "gi", function()
        omnisharp_extended.lsp_implementation()
      end, { buffer = bufnr, desc = "Implementation (omnisharp-extended)" })
    end
  end,
  capabilities = capabilities,
  -- Omnisharp settings
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = true,
    },
    MsBuild = {
      LoadProjectsOnDemand = false,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
      AnalyzeOpenDocumentsOnly = false,
    },
    Sdk = {
      IncludePrereleases = true,
    },
  },
  -- Handle both legacy and modern .NET
  handlers = {
    ["textDocument/definition"] = function(...)
      local ok, omnisharp_extended = pcall(require, "omnisharp_extended")
      if ok then
        return omnisharp_extended.handler(...)
      end
      return vim.lsp.handlers["textDocument/definition"](...)
    end,
  },
  -- Root detection for both legacy and modern projects
  root_markers = {
    "*.sln",
    "*.csproj",
    "omnisharp.json",
    ".git",
  },
})
