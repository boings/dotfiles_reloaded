local configs = require("nvchad.configs.lspconfig")
local capabilities = configs.capabilities

return {
  capabilities = capabilities,
  filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact", "json"},
  root_markers = {
    "vue.config.js",
    "vue.config.ts",
    "nuxt.config.js",
    "nuxt.config.ts"
  },
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
