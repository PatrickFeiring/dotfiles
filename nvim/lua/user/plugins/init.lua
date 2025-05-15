return {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("tokyonight").setup({
                style = "moon",
            })
            vim.cmd.colorscheme("tokyonight")
        end,
    },
    "lukas-reineke/indent-blankline.nvim",

    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        keys = {
            {
                "<leader>.",
                function()
                    Snacks.scratch({
                        name = "Notes",
                        ft = "markdown",
                        filekey = {
                            cwd = false,
                            branch = false,
                            count = true,
                        },
                        win = {
                            -- 'scratch' style but with wrap enabled
                            style = {
                                width = 100,
                                height = 30,
                                bo = {
                                    buftype = "",
                                    buflisted = false,
                                    bufhidden = "hide",
                                    swapfile = false,
                                },
                                minimal = false,
                                noautocmd = false,
                                zindex = 20,
                                wo = {
                                    winhighlight = "NormalFloat:Normal",
                                    wrap = true,
                                },
                                border = "rounded",
                                title_pos = "center",
                                footer_pos = "center",
                            },
                        },
                    })
                end,
                desc = "Toggle notes",
            },
        },
    },

    {
        "mfussenegger/nvim-lint",
        config = function()
            vim.api.nvim_create_user_command("RunMypy", function()
                require("lint").try_lint("mypy")
            end, { nargs = 0 })

            vim.api.nvim_create_user_command("RunPyCodeStyle", function()
                require("lint").try_lint("pycodestyle")
            end, { nargs = 0 })
        end,
    },

    -- Window management
    {
        "christoomey/vim-tmux-navigator",
    },
    {
        "szw/vim-maximizer",
        init = function()
            vim.g.maximizer_set_default_mapping = false

            local opts = { noremap = true, silent = true }

            vim.keymap.set("n", "<C-W>m", ":MaximizerToggle<CR>", opts)
        end,
    },
    "jlanzarotta/bufexplorer",

    {
        "christoomey/vim-tmux-runner",
        config = function()
            local opts = { noremap = true, silent = true }

            vim.keymap.set("n", "<leader>ma", "<cmd>VtrAttachToPane<CR>", opts)
            vim.keymap.set("n", "<leader>ms", "<cmd>:w<CR>", opts)
            vim.keymap.set(
                "n",
                "<leader>mx",
                "<cmd>:w<CR>:VtrSendCommandToRunner<CR>",
                opts
            )
            vim.keymap.set(
                "n",
                "<leader>md",
                '<cmd>VtrFlushCommand<CR>:echo "Cleared command"<CR>',
                opts
            )
        end,
    },

    -- Textobjects
    "kana/vim-textobj-user",
    "kana/vim-operator-user",

    {
        "kana/vim-textobj-entire",
        dependencies = {
            "kana/vim-textobj-user",
        },
    },
    {
        "kana/vim-textobj-line",
        dependencies = {
            "kana/vim-textobj-user",
        },
    },
    "wellle/targets.vim",
    "michaeljsmith/vim-indent-object",
    {
        "whatyouhide/vim-textobj-xmlattr",
        dependencies = {
            "kana/vim-textobj-user",
        },
    },
    "mjbrownie/django-template-textobjects",
    {
        "saaguero/vim-textobj-pastedtext",
        dependencies = {
            "kana/vim-textobj-user",
        },
        init = function()
            vim.g.pastedtext_select_key = "gp"
        end,
    },

    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
        end,
    },
    "tpope/vim-endwise",
    "andrewradev/splitjoin.vim",
    "machakann/vim-swap",
    "tommcdo/vim-exchange",
    "tpope/vim-abolish",
    "christoomey/vim-sort-motion",
    {
        "junegunn/vim-easy-align",
        lazy = false,
        keys = {
            { "ga", "<Plug>(EasyAlign)", desc = "Align operator" },
        },
    },

    "tpope/vim-eunuch",
    "tpope/vim-dispatch",
    "tpope/vim-repeat",
    "tpope/vim-unimpaired",
    "tpope/vim-surround",
    "tpope/vim-characterize",

    "andymass/vim-matchup",
    "ggandor/lightspeed.nvim",

    {
        "tpope/vim-dadbod",
        config = function()
            -- Run textobject but leave cursor in its place
            _G.run_textobject_query = function(type)
                local bufnr = 0
                local cursor = vim.api.nvim_win_get_cursor(bufnr)

                if type == nil then
                    _G.query_cursor_position = cursor
                    vim.o.operatorfunc = "v:lua.run_textobject_query"
                    return "g@"
                end

                vim.cmd("exe \"'[,']DB\"")
                vim.api.nvim_win_set_cursor(bufnr, _G.query_cursor_position)
            end

            vim.keymap.set(
                "n",
                "<leader>q",
                _G.run_textobject_query,
                { noremap = true, expr = true }
            )

            vim.keymap.set("n", "<leader>qq", function()
                return _G.run_textobject_query() .. "_"
            end, { noremap = true, expr = true })

            vim.keymap.set("v", "<leader>q", function()
                vim.cmd("exe \"'<,'>DB\"")
            end, { noremap = true })
        end,
    },
    { dir = "~/Documents/db-scratch.vim" },

    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<C-G><C-G>", function()
                local windows = vim.api.nvim_list_wins()
                local large_windows = 0

                for _, h in ipairs(windows) do
                    if vim.api.nvim_win_get_width(h) > 35 then
                        large_windows = large_windows + 1
                    end
                end

                if large_windows > 1 then
                    vim.cmd("Git ++curwin")
                else
                    vim.cmd("vert Git")
                end
            end)
        end,
    },
    {
        "ruifm/gitlinker.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {},
    },
    {
        "sindrets/diffview.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    {
        "folke/zen-mode.nvim",
        opts = {
            window = {
                width = 100,
                height = 0.95,
                options = {
                    number = false,
                    relativenumber = false,
                    signcolumn = "no",
                },
            },
            plugins = {
                twilight = { enabled = false },
            },
        },
    },
    {
        "folke/twilight.nvim",
        opts = {
            expand = {
                "function",
                "method",
            },
        },
    },
}
