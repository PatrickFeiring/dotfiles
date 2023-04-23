local utils = require("user.utils")

return {
    -- Theming
    {
        "arcticicestudio/nord-vim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme nord]])
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
    "j-hui/fidget.nvim",
    "b0o/schemastore.nvim",

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

    -- Completion
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",

    "mfussenegger/nvim-dap",

    -- Window management
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },
    {
        "szw/vim-maximizer",
        config = function()
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
        "preservim/nerdtree",
        config = function()
            vim.g.NERDTreeIgnore = {
                "\\.o$",
                "\\.pyc$",
                "^.DS_Store$",
                "^.git$",
                "^.mypy_cache$",
                "^.pytest_cache$",
                "^__pycache__$",
                "^dist-newstyle$",
                "^env$",
                "^node_modules$",
            }
            vim.g.NERDTreeShowHidden = true
            vim.g.NERDTreeMinimalUI = true
            vim.api.nvim_set_keymap("n", "<leader>n", ":NERDTreeToggle<CR>", {})
            vim.api.nvim_set_keymap("n", "<leader>N", ":NERDTreeFind<CR>", {})
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

    "JoosepAlviste/nvim-ts-context-commentstring",
    "tpope/vim-commentary",
    {
        "glts/vim-textobj-comment",
        dependencies = {
            "kana/vim-textobj-user",
        },
    },

    "tpope/vim-endwise",
    "andrewradev/splitjoin.vim",
    "machakann/vim-swap",
    "tommcdo/vim-exchange",
    "tpope/vim-abolish",
    "christoomey/vim-sort-motion",
    {
        "junegunn/vim-easy-align",
        config = function()
            vim.api.nvim_set_keymap("n", "ga", "<Plug>(EasyAlign)", {})
        end,
    },

    "tpope/vim-eunuch",
    "tpope/vim-dispatch",
    "tpope/vim-repeat",
    "tpope/vim-unimpaired",
    "tpope/vim-surround",
    "tpope/vim-characterize",

    "andymass/vim-matchup",
    "ggandor/lightspeed.nvim",

    -- Snippets
    {
        "mattn/emmet-vim",
        init = function()
            vim.g.user_emmet_leader_key = "<C-E>"
        end,
    },
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    { dir = "~/Documents/typewriter.nvim" },
    {
        "github/copilot.vim",
        config = function()
            vim.cmd([[
                imap <silent><script><expr> <C-f>a copilot#Accept("\<CR>")
                let g:copilot_no_tab_map = v:true
            ]])
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
                dhall = true,
                graphql = true,
                haskell = true,
                html = true,
                java = true,
                javascript = true,
                json = true,
                lua = true,
                nix = true,
                python = true,
                rust = true,
                svelte = true,
                toml = true,
                typescript = true,
                typescriptreact = true,
                vue = true,
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

    "tpope/vim-fugitive",
    {
        "sindrets/diffview.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },

    {
        "junegunn/goyo.vim",
        config = function()
            vim.g.goyo_width = 100
            vim.g.goyo_height = "95%"
        end,
    },
    "junegunn/limelight.vim",

    "vmchale/dhall-vim",
}
