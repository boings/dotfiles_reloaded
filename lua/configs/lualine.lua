require("lualine").setup {
  options = {
    theme = "onedark",
    section_separators = "",
    component_separators = "",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff" },
    lualine_c = { {
      "filename",
      path = 1,
    } },
    lualine_x = { "diagnostics", "encoding", "fileformat", "filetype" },
    lualine_y = { "program" },
    lualine_z = { "location" },
  },
}
