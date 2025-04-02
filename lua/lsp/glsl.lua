local system = require("utils.system")

if not system.is_executable("glsl_analyzer") then return end

vim.filetype.add({
  extension = {
    frag = "glsl",
  },
})

local lspconfig = require("lspconfig")
lspconfig["glsl_analyzer"].setup({
  cmd = { "glsl_analyzer" },
  filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
  single_file_support = true,
})
