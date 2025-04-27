local utils = require("user.utils")

return {
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
                    ["gd"] = {
                        desc = "Toggle file detail view",
                        callback = function()
                            _G.detail = not _G.detail
                            if _G.detail then
                                require("oil").set_columns({
                                    "icon",
                                    "permissions",
                                    "size",
                                    "mtime",
                                })
                            else
                                require("oil").set_columns({ "icon" })
                            end
                        end,
                    },
                },
                use_default_keymaps = false,
                lsp_file_methods = {
                    enabled = true,
                    timeout_ms = 10000,
                    autosave_changes = true,
                },
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
        opts = {},
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
}
