local lspconfig = prequire("lspconfig")

if not lspconfig then
    return
end

-- Visualize lsp loading progress. Not all language servers do support the
-- progress update endpoints.
local fidget = prequire("fidget")

if fidget then
    fidget.setup({})
end

vim.o.signcolumn = "yes"

vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "<space>f", vim.diagnostic.open_float)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

local function applyCodeActionWithFilter(titleFilter)
    return function()
        -- As code actions depends on cursor position, we move to the
        -- diagnostic, as this is used to fix issues, not for refactoring etc.
        local line, _ = unpack(vim.api.nvim_win_get_cursor(0))
        local diagnostics = vim.diagnostic.get(0, {
            lnum = line - 1,
        })

        if #diagnostics > 0 then
            vim.api.nvim_win_set_cursor(0, {
                diagnostics[1].lnum + 1,
                diagnostics[1].col,
            })

            vim.lsp.buf.code_action({
                filter = function(action)
                    return action.title:lower():find(titleFilter)
                end,
                apply = true,
            })
        end
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local opts = { buffer = ev.buf }

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        vim.keymap.set("n", "<space>h", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, opts)

        vim.keymap.set({ "n", "v" }, "<space>aa", vim.lsp.buf.code_action, opts)
        vim.keymap.set(
            { "n", "v" },
            "<space>ai",
            applyCodeActionWithFilter("add import"),
            opts
        )
        vim.keymap.set(
            { "n", "v" },
            "<space>au",
            applyCodeActionWithFilter("remove unused declaration"),
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
})

lspconfig.svelte.setup({
    capabilities = capabilities,
})

lspconfig.volar.setup({
    capabilities = capabilities,
    filetypes = {
        "typescript",
        "javascript",
        "javascriptreact",
        "typescriptreact",
        "vue",
    },
})

-- Configure individual language servers for configuration languages
local schemastore = prequire("schemastore")

lspconfig.dhall_lsp_server.setup({
    capabilities = capabilities,
})

local json_schemas = {}

if schemastore then
    json_schemas = schemastore.json.schemas({
        select = {
            "openapi.json",
            "package.json",
            "prettierrc.json",
            "tsconfig.json",
        },
    })
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
