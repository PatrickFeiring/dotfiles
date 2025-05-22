return {
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                css = { "stylelint" },
                typescript = { "eslint" },
                svelte = { "eslint", "stylelint" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost" }, {
                callback = function()
                    require("lint").try_lint(nil, {
                        ignore_errors = true,
                    })
                end,
            })
        end,
    },
}
