local lspconfig = prequire("lspconfig")

if not lspconfig then
    return
end

vim.o.signcolumn = "yes"

vim.diagnostic.config({
    severity_sort = true,
})

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)
vim.keymap.set("n", "<space>i", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end)

local function get_diagnostic_under_cursor()
    local line, row = unpack(vim.api.nvim_win_get_cursor(0))
    local diagnostics = vim.diagnostic.get(0, {
        lnum = line - 1,
    })

    if #diagnostics == 0 then
        return
    end

    for _, diagnostic in ipairs(diagnostics) do
        if row >= diagnostic.col and row < diagnostic.end_col then
            return diagnostic
        end
    end

    return nil
end

local function apply_code_action_to_next_diagnostic(titleFilter)
    return function()
        -- As code actions depends on cursor position, we move to the
        -- diagnostic, as this is used to fix issues, not for refactoring etc.
        local diagnostic = get_diagnostic_under_cursor()

        if not diagnostic then
            diagnostic = vim.diagnostic.get_next()

            if not diagnostic then
                return
            end

            vim.api.nvim_win_set_cursor(0, {
                diagnostic.lnum + 1,
                diagnostic.col,
            })
        end

        vim.lsp.buf.code_action({
            filter = function(action)
                return action.title:lower():find(titleFilter)
            end,
            apply = true,
        })
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", function()
            vim.lsp.buf.references({ includeDeclaration = false })
        end, opts)

        vim.keymap.set("n", "<space>h", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<space>r", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end, { expr = true })
        vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
        end, opts)

        vim.keymap.set({ "n", "v" }, "<space>aa", vim.lsp.buf.code_action, opts)
        vim.keymap.set(
            { "n", "v" },
            "<space>ai",
            apply_code_action_to_next_diagnostic("add import"),
            opts
        )
        vim.keymap.set(
            { "n", "v" },
            "<space>au",
            apply_code_action_to_next_diagnostic("remove unused declaration"),
            opts
        )
    end,
})

local capabilities = nil

local cmp_nvim_lsp = prequire("cmp_nvim_lsp")

if cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )
end

-- Configure individual language servers for general languages
lspconfig.hls.setup({
    capabilities = capabilities,
})

lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
})

lspconfig.pyright.setup({
    capabilities = capabilities,
})

lspconfig.rust_analyzer.setup({
    capabilities = capabilities,
    settings = {
        ["rust-analyzer"] = {
            files = {
                excludeDirs = {"node_modules"}
            },
        },
    },
})

lspconfig.svelte.setup({
    capabilities = capabilities,
})

lspconfig.tsserver.setup({
    capabilities = capabilities,
    settings = {
        typescript = {
            inlayHints = {
                includeInlayParameterNameHints = "none",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHints = false,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
        javascript = {
            inlayHints = {
                includeInlayParameterNameHints = "none",
                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                includeInlayVariableTypeHints = false,
                includeInlayFunctionParameterTypeHints = false,
                includeInlayVariableTypeHintsWhenTypeMatchesName = false,
                includeInlayPropertyDeclarationTypeHints = false,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayEnumMemberValueHints = true,
            },
        },
    },
})

lspconfig.volar.setup({
    capabilities = capabilities,
})

-- Configure individual language servers for configuration languages
local schemastore = prequire("schemastore")

lspconfig.dhall_lsp_server.setup({
    capabilities = capabilities,
})

local json_schemas = {}

if schemastore then
    json_schemas = schemastore.json.schemas()
end

lspconfig.jsonls.setup({
    capabilities = capabilities,
    settings = {
        json = {
            validate = { enable = true },
            schemas = json_schemas,
        },
    },
})

local yaml_schemas = {}

if schemastore then
    yaml_schemas = schemastore.json.schemas({
        select = {
            "CircleCI config.yml",
            "docker-compose.yml",
            "GitHub Workflow",
            "gitlab-ci",
            "openapi.json",
            "tmuxinator",
        },
    })
end

lspconfig.yamlls.setup({
    capabilities = capabilities,
    settings = {
        yaml = {
            schemas = yaml_schemas,
        },
    },
})
