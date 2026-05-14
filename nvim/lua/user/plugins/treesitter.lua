return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install({
                "css",
                "html",
                "java",
                "javascript",
                "kotlin",
                "lua",
                "rust",
                "svelte",
                "tlaplus",
                "typescript",
            })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "css",
                    "html",
                    "java",
                    "javascript",
                    "kotlin",
                    "lua",
                    "svelte",
                    "tla",
                    "typescript",
                },
                callback = function(ev)
                    if vim.api.nvim_buf_line_count(ev.buf) > 20000 then
                        return
                    end

                    local byte_size = vim.api.nvim_buf_get_offset(
                        ev.buf,
                        vim.api.nvim_buf_line_count(ev.buf)
                    )

                    if byte_size > 5 * 1024 * 1024 then
                        return
                    end

                    vim.treesitter.start()
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
            vim.g.no_plugin_maps = true
        end,
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                },
                move = {
                    set_jumps = true,
                },
            })

            local select = require("nvim-treesitter-textobjects.select")
            vim.keymap.set({ "x", "o" }, "af", function()
                select.select_textobject("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "if", function()
                select.select_textobject("@function.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "aC", function()
                select.select_textobject("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "iC", function()
                select.select_textobject("@class.inner", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ac", function()
                select.select_textobject("@codeblock.outer", "textobjects")
            end)
            vim.keymap.set({ "x", "o" }, "ic", function()
                select.select_textobject("@codeblock.inner", "textobjects")
            end)

            local move = require("nvim-treesitter-textobjects.move")
            vim.keymap.set({ "n", "x", "o" }, "]m", function()
                move.goto_next_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[m", function()
                move.goto_previous_start("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "]M", function()
                move.goto_next_end("@function.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[M", function()
                move.goto_previous_end("@function.outer", "textobjects")
            end)

            vim.keymap.set({ "n", "x", "o" }, "]]", function()
                move.goto_next_start("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[[", function()
                move.goto_previous_start("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "][", function()
                move.goto_next_end("@class.outer", "textobjects")
            end)
            vim.keymap.set({ "n", "x", "o" }, "[]", function()
                move.goto_previous_end("@class.outer", "textobjects")
            end)
        end,
    },
}
