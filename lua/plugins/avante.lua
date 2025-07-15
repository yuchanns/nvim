local system = require("utils.system")

local build = "make BUILD_FROM_SOURCE=false"
if system.is_windows() then build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" end

return {
  "yetone/avante.nvim",
  build = build,
  event = "VeryLazy",
  opts = {
    disabled_tools = { "web_search" },
    provider = "copilot",
    auto_suggestions_provider = "azure",
    providers = {
      copilot = {
        -- model = "claude-sonnet-4",
        model = "gpt-4.1",
        extra_request_body = {
          temperature = 1,
          max_tokens = 20000,
        },
      },
      bedrock = {
        model = "us.anthropic.claude-3-7-sonnet-20250219-v1:0",
        extra_request_body = {
          temperature = 1,
          max_tokens = 20000,
        },
      },
      azure = {
        endpoint = "https://malacca.yuchanns.xyz/azure-ai/me-m8dtmjmc-swedencentral",
        deployment = "gpt-4.1",
        model = "gpt-4.1",
        api_version = "2025-01-01-preview",
        extra_request_body = {
          temperature = 0,
          max_tokens = 8192,
        },
      },
    },
    custom_tools = {
      {
        name = "search_engine",
        description = "Search the web",
        param = {
          type = "table",
          fields = {
            {
              name = "q",
              description = "Query to search",
              type = "string",
            },
          },
          usage = {
            q = "Query to search",
          },
        },
        returns = {
          { name = "title", description = "Title of the search result", type = "string" },
          { name = "url", description = "URL of the search result", type = "string" },
          { name = "snippet", description = "Snippet of the search result", type = "string" },
        },
        func = function(params, on_log, on_complete)
          local q = params.q
          if not q or q == "" then
            on_log("Search query cannot be empty.")
            return
          end
          local curl = require("plenary.curl")
          local api_key = os.getenv("KAGI_ACCESS_TOKEN")
          local curl_opts = {
            headers = {
              ["Authorization"] = "Bearer " .. api_key,
            },
          }

          local res = curl.get("https://kagiapi.yuchanns.xyz/api/search?q=" .. vim.uri_encode(q), curl_opts)
          if res.status ~= 200 then
            on_log("Search failed: " .. res.body)
            return
          end
          local results = vim.json.decode(res.body)
          return results
        end,
      },
    },
    behaviour = {
      support_paste_from_clipboard = true,
      auto_suggestions = false,
      enable_cursor_planning_mode = true,
      enable_claude_text_editor_tool_mode = true,
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
  },
  dependencies = {
    "github/copilot.vim",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "echasnovski/mini.pick", -- for file_selector provider mini.pick
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    -- {
    --   -- support for image pasting
    --   "HakonHarnes/img-clip.nvim",
    --   event = "VeryLazy",
    --   opts = {
    --     -- recommended settings
    --     default = {
    --       embed_image_as_base64 = false,
    --       prompt_for_file_name = false,
    --       drag_and_drop = {
    --         insert_mode = true,
    --       },
    --       -- required for Windows users
    --       use_absolute_path = true,
    --     },
    --   },
    -- },
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
