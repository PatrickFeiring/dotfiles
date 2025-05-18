return {
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                enabled = function()
                    local context = require("cmp.config.context")

                    if vim.api.nvim_get_mode().mode == "c" then
                        return true
                    else
                        return not context.in_treesitter_capture("comment")
                            and not context.in_syntax_group("Comment")
                    end
                end,

                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },

                sources = {
                    {
                        name = "nvim_lsp",
                        group_index = 2,
                        keyword_length = 3,
                    },
                    {
                        name = "buffer",
                        group_index = 1,
                        keyword_length = 3,
                        option = {
                            get_bufnrs = function()
                                -- Fetch words not only from current buffer but from all
                                -- visible buffers
                                local bufs = {}
                                for _, win in ipairs(vim.api.nvim_list_wins()) do
                                    bufs[vim.api.nvim_win_get_buf(win)] = true
                                end
                                return vim.tbl_keys(bufs)
                            end,
                        },
                    },
                    {
                        name = "copilot",
                        group_index = 2,
                    },
                },

                mapping = {
                    ["<C-x><C-o>"] = cmp.mapping.complete({
                        config = {
                            sources = {
                                { name = "nvim_lsp" },
                            },
                        },
                    }),
                    ["<C-x><C-s>"] = cmp.mapping.complete({
                        config = {
                            sources = {
                                { name = "luasnip" },
                            },
                        },
                    }),
                    ["<C-n>"] = cmp.mapping(
                        cmp.mapping.select_next_item(),
                        { "i", "c" }
                    ),
                    ["<C-p>"] = cmp.mapping(
                        cmp.mapping.select_prev_item(),
                        { "i", "c" }
                    ),
                    ["<C-b>"] = cmp.mapping(
                        cmp.mapping.scroll_docs(-4),
                        { "i", "c" }
                    ),
                    ["<C-f>"] = cmp.mapping(
                        cmp.mapping.scroll_docs(4),
                        { "i", "c" }
                    ),
                    ["<C-e>"] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                },

                completion = {
                    autocomplete = { "TextChanged" },
                },
            })

            _G._nvim_cmp_autocomplete_on = true

            vim.keymap.set({ "n", "i" }, "<C-x><C-x>a", function()
                if _G._nvim_cmp_autocomplete_on then
                    require("cmp").setup({
                        completion = { autocomplete = false },
                    })
                    print("Autocompletion off")
                else
                    require("cmp").setup({
                        completion = { autocomplete = { "TextChanged" } },
                    })
                    print("Autocompletion on")
                end

                _G._nvim_cmp_autocomplete_on = not _G._nvim_cmp_autocomplete_on
            end, { desc = "Toggle autocomplete" })
        end,
    },
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "saadparwaiz1/cmp_luasnip",
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = {
            "zbirenbaum/copilot.lua",
            "hrsh7th/nvim-cmp",
        },
        opts = {},
    },

    { dir = "~/Documents/typewriter.nvim" },
    {
        "L3MON4D3/LuaSnip",
        config = function()
            require("user.snippets")

            local luasnip = require("luasnip")
            local typewriter = prequire("typewriter")

            local function replace_termcodes(str)
                return vim.api.nvim_replace_termcodes(str, true, true, true)
            end

            vim.api.nvim_set_keymap("i", "<Tab>", "", {
                expr = true,
                callback = function()
                    if luasnip and luasnip.expandable() then
                        return replace_termcodes("<Plug>luasnip-expand-snippet")
                    elseif typewriter and typewriter.expandable() then
                        return replace_termcodes("<Plug>typewriter-expand")
                    else
                        return replace_termcodes("<Tab>")
                    end
                end,
            })

            vim.keymap.set("i", "<C-J>", "<Plug>luasnip-jump-next")
        end,
    },
    {
        "mattn/emmet-vim",
        init = function()
            vim.g.user_emmet_leader_key = "<C-E>"
        end,
    },
}
