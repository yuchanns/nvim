local system = require("utils.system")
local lsp = require("utils.lsp")

if not system.is_executable("glsl_analyzer") then return end

vim.filetype.add({
  extension = {
    frag = "glsl",
  },
})

lsp.config("glsl_analyzer", {
  cmd = { "glsl_analyzer" },
  filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
  single_file_support = true,
})
