local system = require("utils.system")

local M = {}

function M.setup()
  if not system.is_executable("gopls") then
    return
  end
  local lspconfig = require("lspconfig")
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  lspconfig["gopls"].setup({
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      gopls = {
        analyses = { composites = false },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  })
  local opts = { lint_prompt_style = "vt" }
  if system.is_executable("revive") then
    opts.auto_lint = true
    opts.linter = "revive"
    -- rule configuration references: https://github.com/mgechev/revive/blob/master/RULES_DESCRIPTIONS.md
    local config
    if system.is_windows() then
      config = "~/AppData/Local/nvim/static/revive_config.toml"
    else
      config = "~/.config/nvim/static/revive_config.toml"
    end
    opts.linter_flags = { revive = { "-config", config } }
  end
  if system.is_executable("goimports") then
    opts.auto_format = false
    opts.formatter = "goimports"
  end
  if system.is_executable("impl") then
    require("telescope").load_extension("goimpl")
  end
  require("go").setup(opts)
end

return M
