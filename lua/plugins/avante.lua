local system = require("utils.system")

local build = "make"
if system.is_windows() then
  build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
end

return {
  "yetone/avante.nvim",
  build = build,
  event = "VeryLazy",
  opts = {
    provider = "azure",
    azure = {
      endpoint = "https://yuchanns-eastus.openai.azure.com",
      deployment = "gpt-4o-mini",
      model = "gpt-4o-mini",
      api_version = "2024-05-01-preview",
      temperature = 0,
      max_tokens = 4096,
    },
    behaviour = {
      support_paste_from_clipboard = true,
    },

  },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          use_absolute_path = true
        },
      },
    },
    --- The below is optional, make sure to setup it properly if you have lazy=true
    {
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  }
}
