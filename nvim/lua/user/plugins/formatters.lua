return {
    {
        "stevearc/conform.nvim",
        config = function()
            local conform = require("conform")

            local web = function(bufnr)
                if conform.get_formatter_info("biome", bufnr).available then
                    return {
                        "biome-organize-imports",
                        "biome",
                    }
                else
                    return {
                        "prettierd",
                        "prettier",
                        stop_after_first = true,
                    }
                end
            end

            local formatters_by_ft = {
                css = web,
                html = web,
                javascript = web,
                json = web,
                jsonc = web,
                lua = { "stylua" },
                markdown = { "injected" },
                python = function(bufnr)
                    if
                        require("conform").get_formatter_info(
                            "ruff_format",
                            bufnr
                        ).available
                    then
                        return { "ruff_format", "ruff_organize_imports" }
                    else
                        return { "isort", "black" }
                    end
                end,
                scss = web,
                sql = { "pg_format" },
                svelte = web,
                typescript = web,
                typescriptreact = web,
                vue = web,
                yaml = web,
            }

            local lsp_only = { "rust" }

            require("conform").setup({
                formatters_by_ft = formatters_by_ft,
                format_on_save = function(bufnr)
                    if
                        vim.g.disable_autoformat
                        or vim.b[bufnr].disable_autoformat
                    then
                        return
                    end

                    if
                        not vim.tbl_contains(
                            vim.tbl_keys(formatters_by_ft),
                            vim.bo.filetype
                        )
                        and not vim.tbl_contains(lsp_only, vim.bo.filetype)
                    then
                        return
                    end

                    return {
                        timeout_ms = 500,
                        lsp_fallback = true,
                    }
                end,
            })

            _G.format_textobject = function(type)
                if type == nil then
                    vim.o.operatorfunc = "v:lua.format_textobject"
                    return "g@"
                end

                if
                    vim.g.disable_autoformat
                    or vim.b[vim.api.nvim_get_current_buf()].disable_autoformat
                then
                    return
                end

                local from = vim.fn.getpos("'[")
                local to = vim.fn.getpos("']")

                require("conform").format({
                    range = {
                        start = { from[2], from[3] },
                        ["end"] = { to[2], to[3] },
                    },
                })
            end

            vim.keymap.set("n", "<leader>f", _G.format_textobject, {
                desc = "Format operator",
                noremap = true,
                expr = true,
            })

            vim.keymap.set("n", "<leader>ff", function()
                return _G.format_textobject() .. "_"
            end, {
                desc = "Format current line",
                noremap = true,
                expr = true,
            })

            vim.api.nvim_create_user_command("FormatDisable", function()
                vim.b.disable_autoformat = true
                vim.g.disable_autoformat = true
            end, {
                desc = "Disable autoformat-on-save",
            })

            vim.api.nvim_create_user_command("FormatEnable", function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, {
                desc = "Re-enable autoformat-on-save",
            })

            vim.api.nvim_create_user_command("FormatToggle", function()
                vim.b.disable_autoformat = not vim.b.disable_autoformat
                vim.g.disable_autoformat = vim.b.disable_autoformat

                print(
                    string.format(
                        "Format on write is %s",
                        vim.b.disable_autoformat and "off" or "on"
                    )
                )
            end, {
                desc = "Toggle autoformat-on-save",
            })
        end,
    },
}
