local system = require "utils.system"
local lsp = require "utils.lsp"

-- if not system.is_executable "sourcekit-lsp" then return end
--
-- lsp.config("sourcekit", {
--     capabilities = {
--         workspace = {
--             didChangeWatchedFiles = {
--                 dynamicRegistration = true,
--             },
--         },
--     },
-- })
