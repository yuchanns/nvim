-- To use ultisnips, you need to have python installed, and two modules are required:
-- * pynvim
-- * typing_extensions
-- Make sure python is available in your $PATH.
-- pyenv is recommendation.
-- You can get the executable path by `pyenv which python` and then set it to the $PATH.
local cmp = require "cmp"
local lspkind = require "lspkind"
cmp.setup {
    formatting = {
        format = lspkind.cmp_format {
            mode = "symbol", -- show only symbol annotations
            maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(_, vim_item) return vim_item end,
        },
    },
    experimental = {
        ghost_text = true,
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    sources = cmp.config.sources {
        { name = "nvim_lsp" },
        { name = "ultisnips" }, -- For ultisnips users.
        { name = "nvim_lua" },
        { name = "buffer" },
        { name = "path" },
        { name = "dictionary" },
        { name = "orgmode" },
        {
            name = "spell",
            option = {
                keep_all_entries = false,
                enable_in_context = function() return true end,
            },
        },
    },
    mapping = {
        ["<CR>"] = cmp.mapping.confirm { select = true },
        ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    },
}
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
