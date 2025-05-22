return {
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            -- Adapters
            "marilari88/neotest-vitest",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-vitest"),
                },
            })

            vim.keymap.set("n", "<leader>tn", function()
                require("neotest").summary.toggle()
            end, { desc = "Toggle test summary" })
        end,
    },
}
