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

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<space>f", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

local on_attach = function(_client, bufnr)
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>h", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "<space>r", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<space>a", vim.lsp.buf.code_action, bufopts)
end

local capabilities = nil

local cmp_nvim_lsp = prequire("cmp_nvim_lsp")

if cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(
        vim.lsp.protocol.make_client_capabilities()
    )
end

-- Configure individual language servers for general languages
lspconfig.hls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
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

lspconfig.volar.setup({
    on_attach = on_attach,
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
    on_attach = on_attach,
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
    on_attach = on_attach,
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
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        yaml = {
            schemas = yaml_schemas,
        },
    },
})
