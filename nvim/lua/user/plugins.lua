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

    -- Lsps
    "neovim/nvim-lspconfig",
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

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    "nvim-treesitter/nvim-treesitter-textobjects",

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

    {
        "stevearc/conform.nvim",
        config = function()
            local formatters_by_ft = {
                css = { "prettierd", "prettier", stop_after_first = true },
                html = { "prettierd", "prettier", stop_after_first = true },
                javascript = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                json = { "prettierd", "prettier", stop_after_first = true },
                jsonc = { "prettierd", "prettier", stop_after_first = true },
                lua = { "stylua" },
                python = function(bufnr)
                    if
                        require("conform").get_formatter_info(
                            "ruff_format",
                            bufnr
                        ).available
                    then
                        return { "ruff_format" }
                    else
                        return { "isort", "black" }
                    end
                end,
                scss = { "prettierd", "prettier", stop_after_first = true },
                sql = { "pg_format" },
                svelte = { "prettierd", "prettier", stop_after_first = true },
                typescript = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                typescript_react = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                vue = { "prettierd", "prettier", stop_after_first = true },
                yaml = { "prettierd", "prettier", stop_after_first = true },
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

    "vmchale/dhall-vim",
}
