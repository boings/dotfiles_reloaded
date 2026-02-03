return {
  "mrcjkb/rustaceanvim",
  version = "^6",
  lazy = false,
  init = function()
    vim.g.rustaceanvim = {
      server = {
        on_attach = function(client, bufnr)
          -- Refresh CodeLens on attach
          if client.supports_method "textDocument/codeLens" then
            vim.lsp.codelens.refresh()
          end
        end,
        default_settings = {
          ["rust-analyzer"] = {
            lens = {
              enable = true,
              references = {
                adt = { enable = true },
                enumVariant = { enable = true },
                method = { enable = true },
                trait = { enable = false }, -- traits often count derive macros
              },
              implementations = { enable = false }, -- disable - counts derive impls
              run = { enable = true },
              debug = { enable = true },
            },
            inlayHints = {
              bindingModeHints = { enable = true },
              closureReturnTypeHints = { enable = "always" },
              lifetimeElisionHints = { enable = "skip_trivial" },
            },
          },
        },
      },
    }
  end,
}
