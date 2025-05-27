-- ~/.config/nvim/lua/custom/plugins/cmp.lua
print("Loaded my custom cmp.lua!")
return {
  {
    "hrsh7th/nvim-cmp",
    -- re-bring NVChad’s default sources + add the cmdline source
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",    -- LSP completions
      "hrsh7th/cmp-buffer",      -- buffer words
      "hrsh7th/cmp-path",        -- filesystem paths
      "saadparwaiz1/cmp_luasnip",-- snippet integration (if you use LuaSnip)
      "hrsh7th/cmp-cmdline",     -- ← required for : and / completions
    },
    opts = function(_, opts)
      local cmp = require("cmp")
      -- keep all NVChad defaults
      -- then wire up cmdline sources:
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          { { name = "path" } },
          { { name = "cmdline", option = { ignore_cmds = { "Man", "!" } } } }
        ),
      })
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      -- finally apply the default + your additions
      cmp.setup(opts)
    end,
  },
}
