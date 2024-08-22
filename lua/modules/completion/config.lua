local config = {}

function config.lspsaga()
  -- define the sign of diagnostics
  vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "Error" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "Warn" })
  vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "Info" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "💡", texthl = "Hint" })
  vim.api.nvim_set_hl(0, "SagaBeacon", { link = "FinderPreview" })
  vim.diagnostic.config({
    virtual_text = {
      format = function(diagnostic)
        if diagnostic.severity == vim.diagnostic.severity.ERROR then
          return string.format(" %s", diagnostic.message)
        elseif diagnostic.severity == vim.diagnostic.WARN then
          return string.format(" %s", diagnostic.message)
        elseif diagnostic.severity == vim.diagnostic.INFO then
          return string.format(" %s", diagnostic.message)
        end
        return string.format("💡%s", diagnostic.message)
      end,
    },
  })
  local kind = {}
  kind["Folder"] = { "  ", "Title" }
  return {
    ui = {
      winblend = 20,
      border = "rounded",
      kind = kind,
    },
    outline = {
      win_width = 30,
      preview_width = 0.4,
      show_detail = true,
      auto_preview = true,
      auto_refresh = true,
      auto_close = true,
      auto_resize = true,
      custom_sort = nil,
      keys = {
        expand_or_jump = "o",
        quit = "q",
      },
    },
  }
end

function config.compe()
  -- dictionary
  local dict = require("cmp_dictionary")
  dict.setup({
    --[[ exact_length = 2,
    first_case_insensitive = false,
    document = false,
    document_command = "wn %s -over",
    async = false,
    max_number_items = -1,
    debug = false, ]]
  })
  local cmp = require("cmp")
  local lspkind = require("lspkind")
  cmp.setup({
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol", -- show only symbol annotations
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

        -- The function below will be called before any actual modifications from lspkind
        -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
        before = function(entry, vim_item)
          return vim_item
        end,
      }),
    },
    experimental = {
      ghost_text = true,
    },
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      -- { name = "vsnip" }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      { name = "ultisnips" }, -- For ultisnips users.
      -- { name = "snippy" }, -- For snippy users.
      { name = "nvim_lua" },
      { name = "buffer" },
      { name = "path" },
      -- { name = "cmdline" },
      { name = "dictionary" },
      { name = "orgmode" },
      {
        name = "spell",
        option = {
          keep_all_entries = false,
          enable_in_context = function()
            return true
          end,
        },
      },
    }),
    mapping = {
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    },
  })
  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" },
    },
  })
  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "path" },
    }, {
      { name = "cmdline" },
    }),
  })
end

function config.avante()
  return {
    provider = "copilot",
    --[[ vendors = {
      bedrock = require("avante_bedrock").vendor(),
    }, ]]
    azure = {
      endpoint = "https://yuchanns-eastus.openai.azure.com",
      deployment = "gpt-4o-mini",
      api_version = "2024-05-01-preview",
      temperature = 0,
      max_tokens = 4096,
    },
    mappings = {
      ask = "ca",
      edit = "ce",
      refresh = "cr",
      diff = {
        ours = "co",
        theirs = "ct",
        none = "c0",
        both = "cb",
        next = "]x",
        prev = "[x",
      },
      jump = {
        next = "]]",
        prev = "[[",
      },
    },
  }
end

function config.codegpt()
  vim.g["codegpt_api_provider"] = "azure"
  vim.g["codegpt_chat_completions_url"] =
    "https://yuchanns-eastus.openai.azure.com/openai/deployments/gpt-4o-mini/chat/completions?api-version=2024-05-01-preview"
  -- custom commands
  vim.g["codegpt_commands"] = {
    -- compatible to yetone's [openai-translator](https://github.com/yetone/openai-translator)
    ["translate"] = {
      system_message_template = "You are a translation engine that can only translate text and cannot interpret it.Translate the text to Chinese, reformat it for easier reading, and remove useless symbols:",
      user_message_template = "{{text_selection}}",
      callback_type = "text_popup",
    },
    ["translateen"] = {
      system_message_template = "You are a translation engine that can only translate text and cannot interpret it.",
      user_message_template = "translate this text to English:\n {{text_selection}}",
      callback_type = "text_popup",
    },
    ["polish"] = {
      system_message_template = "Revise the following sentences to make them more clear, concise, and coherent.",
      user_message_template = "polish this text in English:\n {{text_selection}}",
      callback_type = "text_popup",
    },
    ["expand"] = {
      user_message_template = "I have the following {{language}} macro:```{{filetype}}\n{{text_selection}}```\nProvide example inputs to show the macro expansion's result as a code snippet and explain it using Chinese comments. Return only the code snippet. If it's not a macro, return an error message.",
      callback_type = "code_popup",
    },
    ["explaincn"] = {
      user_message_template = "Explain the following {{language}} code: ```{{filetype}}\n{{text_selection}}``` Explain it using Chinese in pretty markdown as if you were explaining to another developer.",
      callback_type = "text_popup",
    },
    ["doccn"] = {
      user_message_template = "I have the following {{language}} code: ```{{filetype}}\n{{text_selection}}```\nWrite really good Chinese documentation using best practices for the given language. Attention paid to documenting parameters, return types, any exceptions or errors. {{language_instructions}} Only return the code snippet include the origin content and documentation, and nothing else.",
      language_instructions = {
        go = [[Use the following style to document, note that you should ignore param_type context.Context:
        // FunctionName
        // @Description describe the function
        // @param variable_name param_type
        // @return variable_name return_type
        ]],
      },
    },
  }
end

return config
