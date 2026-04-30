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
                return action.title:lower():match(titleFilter)
            end,
            apply = true,
        })
    end
end

return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    local opts = { buffer = args.buf }

                    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                    vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, opts)
                    vim.keymap.set("n", "gr", function()
                        vim.lsp.buf.references({ includeDeclaration = false })
                    end, opts)

                    vim.keymap.set("n", "<space>h", vim.lsp.buf.hover, opts)
                    vim.keymap.set("n", "<space>i", function()
                        vim.lsp.inlay_hint.enable(
                            not vim.lsp.inlay_hint.is_enabled()
                        )

                        -- We treat color preview as an inlay hint as well
                        if
                            client:supports_method("textDocument/documentColor")
                        then
                            vim.lsp.document_color.enable(
                                not vim.lsp.document_color.is_enabled(args.buf),
                                args.buf,
                                {
                                    style = "virtual",
                                }
                            )
                        end
                    end, opts)

                    if
                        client:supports_method(
                            "textDocument/linkedEditingRange"
                        )
                    then
                        vim.lsp.linked_editing_range.enable(
                            true,
                            { client_id = args.data.client_id }
                        )
                    end

                    vim.lsp.on_type_formatting.enable(
                        true,
                        { client_id = args.data.client_id }
                    )

                    vim.keymap.set("n", "<space>r", function()
                        return ":IncRename " .. vim.fn.expand("<cword>")
                    end, { expr = true })
                    vim.keymap.set("n", "<space>f", function()
                        vim.lsp.buf.format({ async = true })
                    end, opts)

                    vim.keymap.set(
                        "i",
                        "<C-S>",
                        vim.lsp.buf.signature_help,
                        opts
                    )

                    vim.keymap.set(
                        { "n", "v" },
                        "<space>aa",
                        vim.lsp.buf.code_action,
                        opts
                    )
                    vim.keymap.set(
                        { "n", "v" },
                        "<space>ai",
                        apply_code_action_to_next_diagnostic("add import"),
                        opts
                    )
                    vim.keymap.set(
                        { "n", "v" },
                        "<space>au",
                        apply_code_action_to_next_diagnostic(
                            "remove unused declaration"
                        ),
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
            vim.lsp.config("hls", {
                capabilities = capabilities,
            })
            vim.lsp.enable("hls")

            vim.lsp.enable("marksman")

            vim.lsp.config("lua_ls", {
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
            vim.lsp.enable("lua_ls")

            -- Prefer basedpyright over pyright, a more feature rich fork of pyright
            vim.lsp.config("basedpyright", {
                capabilities = capabilities,
            })
            vim.lsp.enable("basedpyright")

            vim.lsp.config("rust_analyzer", {
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        files = {
                            excludeDirs = { "node_modules" },
                        },
                    },
                },
            })
            vim.lsp.enable("rust_analyzer")

            vim.lsp.config("jdtls", {
                capabilities = capabilities,
            })
            vim.lsp.enable("jdtls")

            vim.lsp.config("cssls", {
                capabilities = capabilities,
            })
            vim.lsp.enable("cssls")

            vim.lsp.config("html", {
                capabilities = capabilities,
            })
            vim.lsp.enable("html")

            vim.lsp.config("svelte", {
                capabilities = capabilities,
            })
            vim.lsp.enable("svelte")

            vim.lsp.config("ts_ls", {
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
            vim.lsp.enable("ts_ls")

            -- Configure individual language servers for configuration languages
            vim.lsp.config("dhall_lsp_server", {
                capabilities = capabilities,
            })
            vim.lsp.enable("dhall_lsp_server")

            vim.lsp.config("jsonls", {
                capabilities = capabilities,
                settings = {
                    json = {
                        validate = { enable = true },
                        schemas = require("schemastore").json.schemas(),
                    },
                },
            })
            vim.lsp.enable("jsonls")

            vim.lsp.config("taplo", {
                capabilities = capabilities,
            })
            vim.lsp.enable("taplo")

            vim.lsp.config("yamlls", {
                capabilities = capabilities,
                settings = {
                    yaml = {
                        schemaStore = {
                            enable = false,
                            url = "",
                        },
                        schemas = require("schemastore").yaml.schemas(),
                    },
                },
            })
            vim.lsp.enable("yamlls")
        end,
    },
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    "b0o/schemastore.nvim",
    {
        "smjonas/inc-rename.nvim",
        event = "LspAttach",
        config = function()
            require("inc_rename").setup()
        end,
    },
}
