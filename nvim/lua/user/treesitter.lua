local parsers = prequire("nvim-treesitter.parsers")

if not parsers then
    return
end

local parser_configs = parsers.get_parser_configs()

parser_configs.sql = {
    install_info = {
        url = "~/Documents/tree-sitter-sql",
        files = { "src/parser.c" },
    },
}

require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "dockerfile",
        "haskell",
        "html",
        "javascript",
        "java",
        "json",
        "lua",
        "make",
        "markdown",
        "nix",
        "php",
        "python",
        "rust",
        "scss",
        "svelte",
        "typescript",
        "toml",
        "tsx",
        "vim",
        "vimdoc",
        "vue",
        "yaml",
    },

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
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
})

local installed = pcall(vim.treesitter.language.require_language, "sql")

if installed then
    -- Currently it is hard to override the built in queries except using the
    -- set_query function with a string
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/3146
    local f = io.open(
        os.getenv("HOME") .. "/Documents/tree-sitter-sql/queries/highlights.scm",
        "r"
    )
    local highlight_queries = ""

    if f then
        highlight_queries = f:read("*all")
        f:close()
    end

    require("vim.treesitter.query").set("sql", "highlights", highlight_queries)
    require("vim.treesitter.query").set("sql", "injections", "")
end
