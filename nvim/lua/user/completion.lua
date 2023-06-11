local cmp = prequire("cmp")

if not cmp then
    return
end

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },

    sources = {
        { name = "nvim_lsp", option = { keyword_length = 2 } },
        {
            name = "buffer",
            option = {
                keyword_length = 2,
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
        ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
        ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
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

vim.keymap.set({ "n", "i" }, "<C-x><C-x>c", function()
    if vim.g.copilot_enabled then
        vim.g.copilot_enabled = false
        print("Copilot off")
    else
        vim.g.copilot_enabled = true
        print("Copilot on")
    end
end, { desc = "Toggle copilot" })
