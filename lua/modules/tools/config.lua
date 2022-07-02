local config = {}

function config.telescope()
  if not packer_plugins["plenary.nvim"].loaded then
    vim.cmd([[packadd plenary.nvim]])
    vim.cmd([[packadd popup.nvim]])
    vim.cmd([[packadd telescope-fzy-native.nvim]])
    vim.cmd([[packadd telescope-file-browser.nvim]])
  end
  require("telescope").setup({
    defaults = {
      layout_config = {
        horizontal = { prompt_position = "top", results_width = 0.6 },
        vertical = { mirror = false },
      },
      sorting_strategy = "ascending",
      file_previewer = require("telescope.previewers").vim_buffer_cat.new,
      grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
      qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      },
    },
  })
  require("telescope").load_extension("fzy_native")
  require("telescope").load_extension("file_browser")
  require("telescope").load_extension("neoclip")
  if vim.fn.executable("goimpl") > 0 then
    require("telescope").load_extension("goimpl")
  end
end

function config.autopairs()
  require("nvim-autopairs").setup()
end

function config.neoclip()
  require("neoclip").setup({
    history = 1000,
    filter = nil,
    preview = true,
    default_register = '"',
    content_spec_column = false,
    on_paste = {
      set_reg = false,
    },
    keys = {
      telescope = {
        i = {
          select = "<cr>",
          paste = "<c-p>",
          paste_behind = "<c-k>",
        },
        n = {
          select = "<cr>",
          paste = "p",
          paste_behind = "P",
        },
      },
    },
  })
end

return config
