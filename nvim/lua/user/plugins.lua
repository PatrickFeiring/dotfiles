local utils = require("user.utils")

return {
    -- Theming
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

    "google/vim-maktaba",
    {
        "google/vim-glaive",
        dependencies = {
            "google/vim-maktaba",
        },
    },

    -- Lsps
    "neovim/nvim-lspconfig",
    {
        "j-hui/fidget.nvim",
        tag = "legacy", -- Pin until rewrite is finished
        event = "LspAttach",
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

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    "nvim-treesitter/nvim-treesitter-textobjects",
    "nvim-treesitter/playground",

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

    "mfussenegger/nvim-dap",

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

    -- Project
    "airblade/vim-rooter",
    {
        "nvim-tree/nvim-web-devicons",
        opts = {
            -- SvelteKit icons inspired by
            -- https://twitter.com/JohnPhamous/status/1661054406253748226/photo/1
            override_by_filename = {
                ["+server.ts"] = {
                    icon = "\u{eae9}",
                },
                ["+layout.server.ts"] = {
                    icon = "\u{ebeb}",
                },
                ["+layout.ts"] = {
                    icon = "\u{ebeb}",
                },
                ["+layout.svelte"] = {
                    icon = "\u{ebeb}",
                },
                ["+page.server.ts"] = {
                    icon = "\u{ea7b}",
                },
                ["+page.ts"] = {
                    icon = "\u{ea7b}",
                },
                ["+error.svelte"] = {
                    icon = "\u{ea7b}",
                },
                ["+page.svelte"] = {
                    icon = "\u{ea7b}",
                },
            },
        },
    },
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        lazy = false,
        opts = {
            enable_git_status = false,
            enable_diagnostics = false,
            sort_function = utils.sort_project_paths,
            window = {
                mappings = {
                    ["o"] = "open",
                },
            },
            filesystem = {
                filtered_items = {
                    visible = false,
                    hide_dotfiles = false,
                    hide_gitignored = true,
                    hide_by_name = { ".git" },
                    show_hidden_count = false,
                },
            },
        },
        keys = {
            {
                "<leader>n",
                "<cmd>Neotree reveal<CR>",
                desc = "Open tree at file",
            },
            {
                "<leader>N",
                "<cmd>Neotree toggle<CR>",
                desc = "Toggle file explorer",
            },
        },
    },
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<C-t>"] = "actions.select_tab",
                    ["<C-s>"] = "actions.select_split",
                    ["<C-v>"] = "actions.select_vsplit",
                    ["<C-c>"] = "actions.close",
                    ["<C-r>"] = "actions.refresh",
                    ["-"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["`"] = "actions.cd",
                    ["~"] = "actions.tcd",
                    ["gs"] = "actions.change_sort",
                    ["gx"] = "actions.open_external",
                    ["g."] = "actions.toggle_hidden",
                },
                use_default_keymaps = false,
                view_options = {
                    show_hidden = true,
                    is_always_hidden = function(name)
                        return name == ".git" or name == ".DS_Store"
                    end,
                },
            })

            vim.keymap.set(
                "n",
                "-",
                "<CMD>Oil<CR>",
                { desc = "Open parent directory" }
            )
        end,
    },
    {
        "antosha417/nvim-lsp-file-operations",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neo-tree/neo-tree.nvim",
            "stevearc/oil.nvim",
        },
        config = function()
            require("lsp-file-operations").setup({})
        end,
    },
    {
        "tpope/vim-projectionist",
        config = function()
            vim.api.nvim_set_keymap("n", "<leader>a", ":A<CR>", {})

            vim.g.projectionist_heuristics = {
                ["*"] = {
                    -- C header and source files
                    ["*.hpp"] = {
                        alternate = "{}.cpp",
                        type = "header",
                    },
                    ["*.cpp"] = {
                        alternate = "{}.hpp",
                        type = "source",
                    },
                    -- Django
                    ["urls.py"] = {
                        alternate = "views.py",
                        type = "urls",
                    },
                    ["views.py"] = {
                        alternate = "urls.py",
                        type = "views",
                    },
                    ["serializers.py"] = {
                        alternate = "models.py",
                        type = "serializers",
                    },
                    ["models.py"] = {
                        alternate = "serializers.py",
                        type = "models",
                    },
                    ["tests.py"] = {
                        type = "tests",
                    },
                    -- Lua
                    ["*_spec.lua"] = {
                        alternate = "{}.lua",
                        type = "source",
                    },
                    ["*.lua"] = {
                        alternate = "{}_spec.lua",
                        type = "tests",
                    },
                    -- Svelte
                    ["+page.ts"] = {
                        alternate = "+page.svelte",
                        type = "view",
                    },
                    ["+page.svelte"] = {
                        alternate = "+page.ts",
                        type = "data",
                    },
                    -- Vue
                    ["*.vue"] = {
                        alternate = "index.vue",
                        type = "index",
                    },
                },
            }
        end,
    },

    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    {
        "nvim-telescope/telescope.nvim",
        config = function()
            vim.api.nvim_set_keymap(
                "n",
                "<leader>e",
                ":Telescope buffers<CR>",
                { noremap = true }
            )
        end,
    },
    "junegunn/fzf",
    "junegunn/fzf.vim",

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
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            require("ts_context_commentstring").setup({})
        end,
    },
    "tpope/vim-commentary",
    {
        "glts/vim-textobj-comment",
        dependencies = {
            "kana/vim-textobj-user",
        },
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

    -- Completion and snippets
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    {
        "github/copilot.vim",
        config = function()
            vim.cmd([[
                imap <silent><script><expr> <C-f>a copilot#Accept("\<CR>")
                let g:copilot_no_tab_map = v:true
                let g:copilot_enabled = v:false
            ]])
        end,
    },
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    { dir = "~/Documents/typewriter.nvim" },
    {
        "mattn/emmet-vim",
        init = function()
            vim.g.user_emmet_leader_key = "<C-E>"
        end,
    },

    -- Formatters
    {
        "google/vim-codefmt",
        dependencies = {
            "google/vim-maktaba",
            "google/vim-glaive",
        },
        config = function()
            local opts = { noremap = true, silent = true }

            vim.api.nvim_set_keymap("n", "<leader>ff", ":FormatLines<CR>", opts)
            vim.api.nvim_set_keymap(
                "n",
                "<leader>f",
                ":set opfunc=codefmt#FormatMap<CR>g@",
                opts
            )
            vim.api.nvim_set_keymap("v", "<leader>f", ":FormatLines<CR>", opts)
        end,
    },
    {
        "sbdchd/neoformat",
        config = function()
            vim.g.neoformat_enabled_haskell = { "ormolu" }
            vim.g.neoformat_enabled_html = { "prettierd" }
            vim.g.neoformat_enabled_javascript = { "prettierd" }
            vim.g.neoformat_enabled_json = { "prettierd" }
            vim.g.neoformat_enabled_svelte = { "prettierd" }
            vim.g.neoformat_enabled_typescript = { "prettierd" }
            vim.g.neoformat_enabled_typescript_react = { "prettierd" }
            vim.g.neoformat_enabled_vue = { "prettierd" }

            vim.g.neoformat_only_msg_on_error = 1

            _G.format_on_write_enabled = true
            _G.format_filetypes_on_write = {
                cabal = true,
                cpp = true,
                css = true,
                dhall = true,
                graphql = true,
                haskell = true,
                html = true,
                java = true,
                javascript = true,
                json = true,
                jsonc = true,
                lua = true,
                nix = true,
                prisma = true,
                python = true,
                rust = true,
                scss = true,
                svelte = true,
                toml = true,
                typescript = true,
                typescriptreact = true,
                vue = true,
                yaml = true,
            }

            vim.api.nvim_create_user_command("FormatToggle", function()
                _G.format_on_write_enabled = not _G.format_on_write_enabled
                P(
                    string.format(
                        "Format on write is %s",
                        _G.format_on_write_enabled and "on" or "off"
                    )
                )
            end, {})

            vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                group = vim.api.nvim_create_augroup("fmt", { clear = true }),
                callback = function(opts)
                    if
                        _G.format_on_write_enabled
                        and _G.format_filetypes_on_write[vim.bo[opts.buf].filetype]
                    then
                        if vim.bo.filetype == "cpp" then
                            if utils.has_project_file(".clang-format") then
                                vim.cmd("Neoformat! cpp clangformat")
                            end
                        elseif vim.bo.filetype == "python" then
                            -- Since there is substantial variation accross
                            -- projects in formatters and tooling, we do this
                            -- dynamically
                            -- TODO: consider caching it
                            local tools = utils.get_tools_listed_in_pyproject()

                            if tools["isort"] then
                                vim.cmd("Neoformat! python isort")
                            end
                            if tools["black"] then
                                vim.cmd("Neoformat! python black")
                            end
                        elseif vim.bo.filetype == "java" then
                            if utils.has_project_file(".clang-format") then
                                vim.cmd("Neoformat! java clangformat")
                            end
                        else
                            vim.cmd("Neoformat")
                        end
                    end
                end,
            })

            vim.api.nvim_create_user_command(
                "ISort",
                "Neoformat! python isort",
                {}
            )
        end,
    },

    {
        "tpope/vim-dadbod",
        config = function()
            -- Run textobject but leave cursor in its place
            _G.run_textobject = function(type)
                local bufnr = 0
                local cursor = vim.api.nvim_win_get_cursor(bufnr)

                if type == nil then
                    _G.query_cursor_position = cursor
                    vim.o.operatorfunc = "v:lua.run_textobject"
                    return "g@"
                end

                vim.cmd("exe \"'[,']DB\"")
                vim.api.nvim_win_set_cursor(bufnr, _G.query_cursor_position)
            end

            local run_current_line = function()
                return _G.run_textobject() .. "_"
            end

            local opts = { noremap = true, expr = true }

            vim.keymap.set("n", "<leader>q", _G.run_textobject, opts)
            vim.keymap.set("n", "<leader>qq", run_current_line, opts)
        end,
    },
    { dir = "~/Documents/db-scratch.vim" },
    "edgedb/edgedb-vim",

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

    "vmchale/dhall-vim",
}
