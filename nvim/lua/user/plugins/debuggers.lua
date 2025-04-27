return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")

            vim.keymap.set("n", "<leader>bc", dap.continue)
            vim.keymap.set("n", "<leader>bn", dap.step_over)

            vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint)
            vim.keymap.set("n", "<leader>bd", dap.clear_breakpoints)

            dap.adapters.python = {
                type = "executable",
                command = os.getenv("HOME")
                    .. "/.virtualenvs/debugpy/bin/python",
                args = { "-m", "debugpy.adapter" },
            }

            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    console = "integratedTerminal",
                    pythonPath = function()
                        local cwd = vim.fn.getcwd()

                        if vim.fn.executable(cwd .. "/env/bin/python") == 1 then
                            return cwd .. "/env/bin/python"
                        else
                            return "/usr/local/bin/python"
                        end
                    end,
                },
            }
        end,
    },
}
