local system = require("utils.system")
local autocmd = require("utils.autocmd")

if not system.is_executable("pyright") then return end

local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

lspconfig["pyright"].setup({
  capabilities = capabilities,
})

-- lspconfig["pylsp"].setup({
--   capabilities = capabilities,
--   settings = {
--     pylsp = {
--       plugins = {
--         ruff = {
--           enabled = true,
--           formatEnabled = true,
--         },
--         pycodestyle = false,
--       },
--     },
--   },
-- })
--
-- -- I use pylsp for formatting only
-- -- and use pyright for completion,
-- -- so let's disable the completion of pylsp
-- -- https://github.com/hrsh7th/nvim-cmp/issues/822
-- autocmd.lsp_attach(function(client, _)
--   if not client then return end
--   if client.name ~= "pylsp" then return end
--   client.server_capabilities.completionProvider = nil
-- end)
