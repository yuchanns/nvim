local system = require "utils.system"
local lsp = require "utils.lsp"

if not system.is_executable "jinja-lsp" then return end
vim.filetype.add {
    extension = {
        jinja = "jinja",
        jinja2 = "jinja",
        j2 = "jinja",
    },
}
lsp.config "jinja_lsp"
