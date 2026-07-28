local keymap = require "utils.keymap"
local nmap = keymap.nmap
local cmd = keymap.cmd
local silent, noremap = keymap.silent, keymap.noremap
local opts = keymap.new_opts
local autocmd = require "utils.autocmd"
local loader = require "utils.loader"

local lsp_document_highlight_group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
local lsp_document_highlight_delay = 100
local lsp_document_highlight_states = {}

local function cancel_document_highlight(bufnr)
    local state = lsp_document_highlight_states[bufnr]
    if not state then return end

    state.generation = state.generation + 1

    if state.timer then
        state.timer:stop()
        if not state.timer:is_closing() then state.timer:close() end
        state.timer = nil
    end

    if state.cancel_request then
        state.cancel_request()
        state.cancel_request = nil
    end
end

local function cursor_unchanged(bufnr, winid, cursor)
    if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(winid) then return false end
    if vim.api.nvim_win_get_buf(winid) ~= bufnr then return false end

    local current = vim.api.nvim_win_get_cursor(winid)
    return current[1] == cursor[1] and current[2] == cursor[2]
end

local function clear_document_highlight(bufnr)
    cancel_document_highlight(bufnr)
    if vim.api.nvim_buf_is_valid(bufnr) then vim.lsp.util.buf_clear_references(bufnr) end
end

local function schedule_document_highlight(bufnr)
    clear_document_highlight(bufnr)

    local winid = vim.api.nvim_get_current_win()
    if vim.api.nvim_win_get_buf(winid) ~= bufnr then return end

    local state = lsp_document_highlight_states[bufnr] or { generation = 0 }
    lsp_document_highlight_states[bufnr] = state

    local generation = state.generation
    local cursor = vim.api.nvim_win_get_cursor(winid)
    state.timer = vim.defer_fn(function()
        local current = lsp_document_highlight_states[bufnr]
        if not current or current.generation ~= generation then return end

        current.timer = nil
        if not cursor_unchanged(bufnr, winid, cursor) then return end

        current.cancel_request = vim.lsp.buf_request_all(
            bufnr,
            "textDocument/documentHighlight",
            function(client) return vim.lsp.util.make_position_params(winid, client.offset_encoding) end,
            function(results)
                local latest = lsp_document_highlight_states[bufnr]
                if not latest or latest.generation ~= generation then return end

                latest.cancel_request = nil
                if not cursor_unchanged(bufnr, winid, cursor) then return end

                for client_id, response in pairs(results) do
                    local client = vim.lsp.get_client_by_id(client_id)
                    if client and not response.error and response.result then
                        vim.lsp.util.buf_highlight_references(bufnr, response.result, client.offset_encoding)
                    end
                end
            end
        )
    end, lsp_document_highlight_delay)
end

autocmd.lsp_attach(function(client, bufnr)
    if not client then return end

    if client:supports_method("textDocument/inlayHint", bufnr) then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if not client:supports_method("textDocument/documentHighlight", bufnr) then return end

    vim.api.nvim_clear_autocmds({ group = lsp_document_highlight_group, buffer = bufnr })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        group = lsp_document_highlight_group,
        buffer = bufnr,
        callback = function(args) schedule_document_highlight(args.buf) end,
    })
    vim.api.nvim_create_autocmd("BufWipeout", {
        group = lsp_document_highlight_group,
        buffer = bufnr,
        callback = function(args)
            cancel_document_highlight(args.buf)
            lsp_document_highlight_states[args.buf] = nil
        end,
    })

    schedule_document_highlight(bufnr)
end)

autocmd.user_pattern("VeryLazy", loader.callback_load_mods { "lsp", "lsp.setup" })
autocmd.user_cmd("LspRestartHint", function()
    vim.cmd "LspRestart"
    vim.notify("LSP Restarted", vim.log.levels.INFO, { title = "LSP" })
end, {})

-- lspsaga
vim.api.nvim_set_hl(0, "SagaBeacon", { link = "FinderPreview" })
vim.diagnostic.config {
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "💡",
        },
    },
    virtual_text = {
        format = function(diagnostic)
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
                return string.format(" %s", diagnostic.message)
            elseif diagnostic.severity == vim.diagnostic.severity.WARN then
                return string.format(" %s", diagnostic.message)
            elseif diagnostic.severity == vim.diagnostic.severity.INFO then
                return string.format(" %s", diagnostic.message)
            end
            return string.format("💡%s", diagnostic.message)
        end,
    },
}

nmap {
    { "ga",        cmd "Lspsaga code_action",                                    opts(noremap, silent) },
    { "gi",        cmd "lua require('telescope.builtin').lsp_implementations()", opts(noremap, silent) },
    { "gr",        cmd "lua vim.lsp.buf.references()",                           opts(noremap, silent) },
    { "gd",        cmd "lua vim.lsp.buf.definition()",                           opts(noremap, silent) },
    { "gs",        cmd "lua vim.lsp.buf.document_symbol()",                      opts(noremap, silent) },
    { "gR",        cmd "Trouble lsp_references toggle",                          opts(noremap, silent) },
    { "gh",        cmd "Lspsaga finder ref+def",                                 opts(noremap, silent) },
    { "gm",        cmd "lua require'telescope'.extensions.goimpl.goimpl{}",      opts(noremap, silent) },
    { "gn",        cmd "Lspsaga rename",                                         opts(noremap, silent) },
    { "gf",        cmd "lua vim.lsp.buf.format { async = true }",                opts(noremap, silent) },
    { "K",         cmd "Lspsaga hover_doc",                                      opts(noremap, silent) },
    { "[e",        cmd "Lspsaga diagnostic_jump_prev",                           opts(noremap, silent) },
    { "]e",        cmd "Lspsaga diagnostic_jump_next",                           opts(noremap, silent) },
    { "<Leader>e", cmd "Lspsaga show_line_diagnostics",                          opts(noremap, silent) },
    { "<Leader>a", cmd "Lspsaga outline",                                        opts(noremap, silent) },
    { "<Leader>r", cmd "LspRestartHint",                                         opts(noremap, silent) },
}

return {
    {
        "yuchanns/ishiku.nvim",
        opts = {
            ensure_installed = { "lua", "vim", "python", "rust", "go", "typescript", "markdown", "c", "cpp" },
            auto_install = true,
            sync_install = false,
            disable = function(lang, bufnr)
                local max_lines = {
                    javascript = 1000,
                    typescript = 1200,
                    tsx = 1200,
                    json = 800,
                    jsonc = 800,
                }

                local limit = max_lines[lang]
                if limit and vim.api.nvim_buf_line_count(bufnr) > limit then
                    return true
                end

                local name = vim.api.nvim_buf_get_name(bufnr)
                if name:match "%.min%.[^/]+$" then
                    return true
                end

                local stat = vim.uv.fs_stat(name)
                if stat and stat.size > 512 * 1024 then
                    return true
                end

                return false
            end,
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
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = ".",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
            },
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        build = ":MasonUpdate",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            automatic_enable = false,
            ensure_installed = {
                "emmylua_ls",
                "rust_analyzer",
                "gopls",
                -- "pylsp",
                "pyright",
                -- "typst_lsp",
                "ts_ls",
                -- "bufls",
                "jdtls",
                "glsl_analyzer",
                "jinja_lsp",
                "zls",
            },
        },
        dependencies = {
            { "williamboman/mason.nvim", opts = {} },
            {
                "neovim/nvim-lspconfig",
                dependencies = { "ckipp01/stylua-nvim" },
            },
        },
    },
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
    },
    {
        "glepnir/lspsaga.nvim",
        opts = {
            ui = {
                winblend = 20,
                border = "rounded",
                kind = { Folder = { "  ", "Title" } },
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
        },
        event = "LspAttach",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "hrsh7th/cmp-nvim-lsp",                event = "InsertEnter" },
            { "SirVer/ultisnips",                    event = "InsertEnter" },
            { "hrsh7th/cmp-nvim-lua",                event = "InsertEnter" },
            { "quangnguyen30192/cmp-nvim-ultisnips", event = "InsertEnter" },
            { "hrsh7th/cmp-buffer",                  event = "InsertEnter" },
            { "hrsh7th/cmp-path",                    event = "InsertEnter" },
            { "hrsh7th/cmp-cmdline",                 event = "InsertEnter" },
            { "uga-rosa/cmp-dictionary",             event = "InsertEnter" },
            { "onsails/lspkind.nvim",                event = "InsertEnter" },
            { "f3fora/cmp-spell",                    event = "InsertEnter" },
            { "ekalinin/Dockerfile.vim",             event = "InsertEnter" },
        },
    },
    {
        "crispgm/nvim-go",
        ft = "go",
        event = "LspAttach",
        opts = {
            test_timeout = "300s",
        }
    },
    { "rhysd/vim-go-impl",     ft = "go",          event = "LspAttach" },
    {
        "edolphin-ydf/goimpl.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim",         event = "VeryLazy" },
            { "nvim-lua/popup.nvim",           event = "VeryLazy" },
            { "nvim-telescope/telescope.nvim", event = "VeryLazy" },
        },
        event = "LspAttach",
        ft = { "go" },
    },
    {
        "mrcjkb/rustaceanvim",
        version = "^4",
        ft = { "rust" },
        event = "LspAttach",
        lazy = false,
        dependencies = { "rust-lang/rust.vim" },
    },
}
