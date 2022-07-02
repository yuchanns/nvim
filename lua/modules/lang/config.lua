local config = {}

function config.nvim_treesitter()
  vim.api.nvim_command("set foldmethod=expr")
  vim.api.nvim_command("set foldexpr=nvim_treesitter#foldexpr()")
  require("nvim-treesitter.configs").setup({
    ensure_installed = "all",
    ignore_install = { "phpdoc" },
    highlight = {
      enable = true,
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
  })
end

function config.nvim_lspconfig()
  local executable = vim.fn.executable

  local nvim_lsp = require("lspconfig")

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    require("illuminate").on_attach(client)
    require("lsp_signature").on_attach(client)
    require("aerial").on_attach(client)
    -- local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...)
      vim.api.nvim_buf_set_option(bufnr, ...)
    end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Mappings.
    -- local opts = { noremap=true, silent=true }
    --[[ buf_set_keymap('n', '<leader>a', '<cmd>AerialToggle! left<CR>', {})
    buf_set_keymap('n', '{', '<cmd>AerialPrev<CR>', {})
    buf_set_keymap('n', '}', '<cmd>AerialNext<CR>', {})
    buf_set_keymap('n', '<leader>w', '<cmd>AerialTreeToggle!<CR>', {}) ]]
    -- See `:help vim.lsp.*` for documentation on any of the below functions
  end

  -- golang
  if executable("gopls") > 0 then
    nvim_lsp["gopls"].setup({
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      },
      settings = {
        gopls = {
          analyses = { composites = false },
        },
      },
    })
    local opts = { lint_prompt_style = "vt" }
    if executable("revive") > 0 then
      opts.auto_lint = true
      opts.linter = "revive"
    end
    if executable("goimports") > 0 then
      opts.auto_format = true
      opts.formatter = "goimports"
    end
    require("go").setup(opts)
  end

  -- rust
  if executable("rust-analyzer") > 0 then
    local rust_tools_opt = {
      server = {
        on_attach = on_attach,
        flags = {
          debounce_text_changes = 150,
        },
        assist = {
          importMergeBehavior = "last",
          importPrefix = "by_self",
        },
        diagnostics = {
          disabled = { "unresolved-import" },
        },
        cargo = {
          loadOutDirsFromCheck = true,
        },
        procMacro = {
          enable = true,
        },
        checkOnSave = {
          command = "clippy",
        },
      },
    }

    require("rust-tools").setup(rust_tools_opt)
    vim.g.rustfmt_autosave = 1
  end

  -- lua
  -- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
  local sumneko_root_path = vim.fn.stdpath("data") .. "/lspconfig/sumneko_lua/lua-language-server"
  local sumneko_binary = sumneko_root_path .. "/bin/lua-language-server"
  if executable(sumneko_binary) > 0 then
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    nvim_lsp["sumneko_lua"].setup({
      cmd = { sumneko_binary, "-E", sumneko_root_path .. "/main.lua" },
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    })
  end

  if executable("stylua") > 0 then
    local augroup = "LUAFMT"
    local stylua = require("stylua-nvim")
    vim.api.nvim_create_augroup(augroup, {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      callback = function()
        if vim.bo.filetype ~= "lua" then
          return
        end
        stylua.format_file()
      end,
    })
  end

  -- php
  vim.cmd("autocmd FileType php set iskeyword+=$")
  local phpactor_root_path = vim.fn.stdpath("data") .. "/lspconfig/phpactor"
  local phpactor_binary = phpactor_root_path .. "/bin/phpactor"
  if executable(phpactor_binary) > 0 then
    nvim_lsp["phpactor"].setup({
      on_attach = on_attach,
      cmd = { phpactor_binary, "language-server", "-vvv" },
    })
  end

  -- typescript
  if executable("typescript-language-server") > 0 then
    nvim_lsp["tsserver"].setup({})
  end
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- css
  if executable("vscode-css-language-server") > 0 then
    nvim_lsp["cssls"].setup({
      capabilities = capabilities,
    })
  end
  -- html
  if executable("vscode-html-language-server") > 0 then
    nvim_lsp["html"].setup({
      capabilities = capabilities,
    })
  end
  -- json
  if executable("vscode-json-language-server") > 0 then
    nvim_lsp["jsonls"].setup({
      capabilities = capabilities,
    })
  end
  -- eslint
  if executable("vscode-eslint-language-server") > 0 then
    vim.cmd("autocmd BufWritePre <buffer> <cmd>EslintFixAll<CR>")
    nvim_lsp["eslint"].setup({})
  end

  -- haskell
  if executable("haskell-language-server-wrapper") > 0 then
    nvim_lsp["hls"].setup({
      single_file_support = true,
    })
    local augroup = "HSFMT"
    vim.api.nvim_create_augroup(augroup, {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      callback = function()
        if vim.bo.filetype ~= "haskell" and vim.bo.filetype ~= "lhaskell" then
          return
        end
        vim.lsp.buf.formatting()
      end,
    })
  end
end

return config
