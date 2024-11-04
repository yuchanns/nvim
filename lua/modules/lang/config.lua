local Utils = require("utils.utils")

local config = {}

local function on_lsp_attach(attach, on_attach)
  Utils.auto_cmd("LspAttach", attach, function(args)
    if not (args.data and args.data.client_id) then
      return
    end
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    on_attach(client, bufnr)
  end)
end

function config.nvim_treesitter()
  vim.api.nvim_command("set foldmethod=expr")
  vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")
  require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    ignore_install = { "phpdoc" },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "org" },
      disable = function(lang, bufnr)
        return lang == "javascript" and vim.api.nvim_buf_line_count(bufnr) > 1000
      end,
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "gnn", -- set to `false` to disable one of the mappings
        node_incremental = ".",
        scope_incremental = "grc",
        node_decremental = "grm",
      },
    },
  })
end

function config.nvim_lspconfig()
  local executable = vim.fn.executable

  local lspconfig = require("lspconfig")

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  on_lsp_attach("omnifunc", function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
  end)
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  -- clangd
  if executable("clangd") > 0 then
    lspconfig["clangd"].setup({
      capabilities = capabilities,
      cmd = {
        "clangd",
        "--offset-encoding=utf-16",
      },
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    })
  end

  -- golang
  if executable("gopls") > 0 then
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
    if executable("revive") > 0 then
      opts.auto_lint = true
      opts.linter = "revive"
      -- rule configuration references: https://github.com/mgechev/revive/blob/master/RULES_DESCRIPTIONS.md
      opts.linter_flags = { revive = { "-config", "~/.config/nvim/static/revive_config.toml" } }
    end
    if executable("goimports") > 0 then
      opts.auto_format = false
      opts.formatter = "goimports"
    end
    require("go").setup(opts)
  end

  -- rust
  if executable("rust-analyzer") > 0 then
    local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/"
    local codelldb_path = extension_path .. "adapters/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
    local this_os = vim.loop.os_uname().sysname
    if this_os:find("Windows") then
      codelldb_path = extension_path .. "adapter\\codelldb.exe"
      liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
    else
      -- The liblldb extension is .so for Linux and .dylib for MacOS
      liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
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

  -- lua
  if executable("lua-language-server") then
    local settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
          special = { reload = "require" },
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "hs", "vim", "it", "describe", "before_each", "after_each" },
          disable = { "lowercase-global" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = {
            vim.fn.expand("$VIMRUNTIME/lua"),
            vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
            vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
            vim.fn.expand("${3rd}/luv/library"),
          },
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
        hint = {
          enable = true,
          setType = true,
        },
      },
    }
    -- luars.json https://luals.github.io/wiki/configuration/#luarcjson-file
    lspconfig["lua_ls"].setup({
      settings = { Lua = {} },
      capabilities = capabilities,
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
            return
          end
        end
        client.config.settings.Lua =
          vim.tbl_deep_extend("force", client.config.settings.Lua, settings.Lua)

        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
      end,
    })
  end

  if executable("stylua") > 0 then
    local stylua = require("stylua-nvim")
    Utils.auto_cmd("BufWritePre", "LUAFMT", function(_)
      if vim.bo.filetype ~= "lua" then
        return
      end
      stylua.format_file()
    end)
  end

  -- php
  vim.cmd("autocmd FileType php set iskeyword+=$")
  local phpactor_root_path = vim.fn.stdpath("data") .. "/lspconfig/phpactor"
  local phpactor_binary = phpactor_root_path .. "/bin/phpactor"
  if executable(phpactor_binary) > 0 then
    lspconfig["phpactor"].setup({
      capabilities = capabilities,
      cmd = { phpactor_binary, "language-server", "-vvv" },
    })
  end

  -- typescript
  if executable("typescript-language-server") > 0 then
    lspconfig["ts_ls"].setup({})
  end
  --[[ local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true ]]
  -- vue
  --[[ if executable("vls") > 0 then
    nvim_lsp["vuels"].setup({})
  end ]]
  --[[ if executable("vue-language-server") > 0 then
    -- TODO: dynamic generate tsdk path
    lspconfig["volar"].setup({
      capabilities = capabilities,
      init_options = {
        typescript = {
          tsdk = string.format(
            "%s/.local/share/pnpm/global/5/node_modules/typescript/lib",
            os.getenv("HOME")
          ),
        },
      },
      filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
        "json",
      },
    })
  end ]]
  -- css
  if executable("vscode-css-language-server") > 0 then
    lspconfig["cssls"].setup({
      capabilities = capabilities,
    })
  end
  -- html
  if executable("vscode-html-language-server") > 0 then
    lspconfig["html"].setup({
      capabilities = capabilities,
    })
  end
  -- json
  if executable("vscode-json-language-server") > 0 then
    lspconfig["jsonls"].setup({
      capabilities = capabilities,
    })
  end
  -- eslint
  if executable("vscode-eslint-language-server") > 0 then
    Utils.auto_cmd("BufWritePre", "ESLINTFMT", function(_)
      vim.cmd([[EslintFixAll]])
    end)
    lspconfig["eslint"].setup({})
  end

  -- haskell
  if executable("haskell-language-server-wrapper") > 0 then
    lspconfig["hls"].setup({
      single_file_support = true,
    })
    Utils.auto_cmd("BufWritePre", "HSFMT", function(_)
      if vim.bo.filetype ~= "haskell" and vim.bo.filetype ~= "lhaskell" then
        return
      end
      vim.lsp.buf.format({ async = true })
    end)
  end

  --[[ -- grammarly
  if executable("grammarly-languageserver") > 0 then
    lspconfig["grammarly"].setup({
      init_options = { clientId = "client_MJ7wALWHHFrSNnkx4VsLbP" },
      capabilities = capabilities,
    })
  end ]]
  -- protobuf
  --[[ if executable("bufls") > 0 then
    lspconfig["bufls"].setup({})
  end ]]
  -- python
  if executable("pylsp") > 0 then
    lspconfig["pylsp"].setup({
      capabilities = capabilities,
      settings = {
        pylsp = {
          plugins = {
            pycodestyle = {
              ignore = { "E501" },
            },
          },
        },
      },
    })
    -- Basically I onply us pylsp for formatting
    -- so let's disable the completion
    -- https://github.com/hrsh7th/nvim-cmp/issues/822
    on_lsp_attach("pylsp", function(client, bufnr)
      if client.name == "pylsp" then
        client.server_capabilities.completionProvider = false
      end
    end)
  end
  if executable("pyright") > 0 then
    -- pyright support pdm
    lspconfig["pyright"].setup({ capabilities = capabilities })
  end

  -- typst
  if executable("typst-lsp") > 0 then
    lspconfig["typst_lsp"].setup({
      -- root_dir = require("lspconfig").util.root_pattern(".git", "*.typ"),
    })
  end
end

function config.dap()
  local dap = require("dap")

  vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "Error", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "ﰲ", texthl = "Success", linehl = "", numhl = "" })
  -- golang
  dap.adapters.go = function(callback, _)
    local stdout = vim.uv.new_pipe(false)
    local handle
    local pid_or_err
    local port = 38697
    local opts = {
      stdio = { nil, stdout },
      args = { "dap", "-l", "127.0.0.1:" .. port },
      detached = true,
    }
    handle, pid_or_err = vim.uv.spawn("dlv", opts, function(code)
      stdout:close()
      handle:close()
      if code ~= 0 then
        print("dlv exited with code", code)
      end
    end)
    assert(handle, "Error running dlv: " .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require("dap.repl").append(chunk)
        end)
      end
    end)
    -- Wait for delve to start
    vim.defer_fn(function()
      callback({ type = "server", host = "127.0.0.1", port = port })
    end, 100)
  end
  dap.configurations.go = {
    {
      type = "go",
      name = "Debug",
      request = "launch",
      program = "${file}",
    },
    {
      type = "go",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}",
    },
    -- works with go.mod packages and sub packages
    {
      type = "go",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
  }

  -- rust/c/cpp config
  dap.adapters.lldb = {
    type = "executable",
    command = "/usr/bin/lldb-vscode",
    name = "lldb",
  }

  dap.configurations.cpp = {
    {
      name = "Launch",
      type = "lldb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
      args = {},

      runInTerminal = false,
    },
  }
  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp
end

function config.phpfmt()
  local root_path = vim.fn.stdpath("data") .. "/lspconfig/PHP_CodeSniffer"
  local binary = root_path .. "/bin/phpcbf"

  require("phpfmt").setup({
    cmd = binary,
    auto_format = true,
  })
end

function config.shfmt()
  require("shfmt").setup({
    args = { "-l", "-w", "-i 4" },
    auto_format = true,
  })
end

function config.illuminate()
  on_lsp_attach("illuminate", require("illuminate").on_attach)
end

function config.mason()
  require("mason").setup()
  require("mason-lspconfig").setup({
    ensure_installed = {
      "lua_ls",
      "rust_analyzer",
      "gopls",
      "pylsp",
      "pyright",
      "typst_lsp",
      "ts_ls",
      "bufls",
      "jdtls",
    },
  })
end

return config
