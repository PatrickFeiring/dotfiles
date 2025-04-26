return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = "all",

                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                    disable = function(lang, bufnr)
                        if vim.api.nvim_buf_line_count(bufnr) > 20000 then
                            return true
                        end

                        local byte_size = vim.api.nvim_buf_get_offset(
                            bufnr,
                            vim.api.nvim_buf_line_count(bufnr)
                        )

                        if byte_size > 5 * 1024 * 1024 then
                            return true
                        end

                        return false
                    end,
                },

                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["aC"] = "@class.outer",
                            ["iC"] = "@class.inner",
                            ["ac"] = "@codeblock.outer",
                            ["ic"] = "@codeblock.inner",
                        },
                    },

                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                        },
                    },
                },
                matchup = {
                    enable = true,
                },
            })
        end
    },
    "nvim-treesitter/nvim-treesitter-textobjects",
}
