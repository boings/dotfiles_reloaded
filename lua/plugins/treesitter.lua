return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    -- keep your existing opts
    require("nvim-treesitter.install").prefer_git = true
    opts.ensure_installed = opts.ensure_installed or {}

    -- Register a custom parser for Move
    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.move_on_aptos = {
      install_info = {
        url = "https://github.com/aptos-labs/tree-sitter-move-on-aptos",
        files = { "src/parser.c", "src/scanner.c" }, -- most TS grammars provide this
        -- optional, but sometimes helpful:
        branch = "main",
      },
      filetype = "move",
    }

    vim.treesitter.language.register("move_on_aptos", "move")

    -- (Optional) Don’t add "move" to ensure_installed if it’s not in registry.
    -- You’ll install it manually via :TSInstall move

    return opts
  end,
}
