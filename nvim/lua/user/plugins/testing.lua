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
            local neotest = require("neotest")

            neotest.setup({
                adapters = {
                    require("neotest-vitest"),
                },
            })

            vim.keymap.set(
                "n",
                "<leader>tn",
                neotest.summary.toggle,
                { desc = "Toggle test summary" }
            )

            vim.keymap.set(
                "n",
                "<leader>tt",
                neotest.run.run,
                { desc = "Run closest test" }
            )
        end,
    },
}
