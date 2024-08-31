local system = require("utils.system")

local M = {}

function M.setup()
  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
  local codelldb_path = extension_path .. "adapters/codelldb"
  local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  if system.is_windows() then
    codelldb_path = extension_path .. "adapter\\codelldb.exe"
    liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
  else
    -- The liblldb extension is .so for Linux and .dylib for MacOS
    liblldb_path = liblldb_path .. (system.is_linux() and ".so" or ".dylib")
  end
  local cfg = require("rustaceanvim.config")
  vim.g.rustaceanvim = {
    tools = {
      inlay_hints = {
        auto = false,
      },
    },
    server = {
      settings = function(project_root)
        local ra = require("rustaceanvim.config.server")
        return ra.load_rust_analyzer_settings(project_root .. "/.vscode", {
          settings_file_pattern = "rust-analyzer.json",
        })
      end,
      capabilities = capabilities,
    },
    dap = {
      adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
    },
  }

  vim.g.rustfmt_autosave = 1
end

return M
