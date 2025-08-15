return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            {
                "microsoft/vscode-js-debug",
                version = "1.x",
                build = "npm i && npm run compile dapDebugServer && mv dist out",
            },
        },
        config = function()
            local dap = require("dap")

            vim.keymap.set("n", "<leader>xx", dap.continue)

            vim.keymap.set("n", "<C-X><C-X>", dap.continue)
            vim.keymap.set("n", "<C-X><C-J>", dap.step_over)
            vim.keymap.set("n", "<C-X><C-K>", dap.restart_frame)
            vim.keymap.set("n", "<C-X><C-L>", dap.step_into)
            vim.keymap.set("n", "<C-X><C-H>", dap.step_out)

            vim.keymap.set("n", "<C-X><C-N>", dap.repl.toggle)
            vim.keymap.set("n", "<C-X><C-V>", function()
                local widgets = require("dap.ui.widgets")
                local my_sidebar = widgets.sidebar(widgets.scopes)
                my_sidebar.open()

                local widgets = require("dap.ui.widgets")
                local my_sidebar = widgets.sidebar(widgets.frames)
                my_sidebar.open()
            end)

            -- vim.cmd([[
            --     function! s:execute_line() abort
            --         if &ft == 'lua'
            --             call execute(printf(':lua %s', getline('.')))
            --         elseif &ft == 'vim'
            --             exe getline('.')
            --         endif
            --     endfunction
            --
            --     function! s:save_and_execute_file() abort
            --         if &ft == 'lua'
            --             :silent! write
            --             :luafile %
            --         elseif &ft == 'vim'
            --             :silent! write
            --             :source %
            --         endif
            --     endfunction
            --
            --     nnoremap <leader>x :call <SID>execute_line()<CR>
            --     vnoremap <leader>x :<C-w>exe join(get("'<", "'>"), '<Bar>')<CR>
            --     nnoremap <leader><leader>x :call <SID>save_and_execute_file()<CR>
            -- ]])

            vim.keymap.set("n", "<C-B><C-B>", dap.toggle_breakpoint)
            vim.keymap.set("n", "<C-B><C-E>", dap.set_exception_breakpoints)
            vim.keymap.set("n", "<C-B><C-L>", function()
                require("dap").set_breakpoint(
                    nil,
                    nil,
                    vim.fn.input("Message: ")
                )
            end)
            vim.keymap.set("n", "<C-B><C-D>", dap.clear_breakpoints)

            vim.fn.sign_define("DapBreakpoint", {
                text = "B",
                texthl = "DiagnosticError",
                linehl = "",
                numhl = "",
            })
            vim.fn.sign_define("DapLogPoint", {
                text = "L",
                texthl = "DiagnosticWarn",
                linehl = "",
                numhl = "",
            })
            vim.fn.sign_define("DapStopped", {
                text = "→",
                texthl = "DiagnosticHint",
                linehl = "",
                numhl = "",
            })

            dap.adapters.python = {
                type = "executable",
                command = os.getenv("HOME") .. "/nvim-env/bin/python",
                args = { "-m", "debugpy.adapter" },
            }

            dap.adapters["pwa-node"] = {
                type = "server",
                host = "localhost",
                port = "${port}",
                executable = {
                    command = "node",
                    args = {
                        vim.fn.stdpath("data")
                            .. "/lazy/vscode-js-debug/out/src/dapDebugServer.js",
                        "${port}",
                    },
                },
            }
            -- TODO
            -- "pwa-chrome",
            -- "pwa-msedge",
            -- "node-terminal",
            -- "pwa-extensionHost",

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
                            return "/usr/bin/python3"
                        end
                    end,
                },
            }

            for _, language in ipairs({ "typescript", "javascript", "svelte" }) do
                require("dap").configurations[language] = {
                    {
                        type = "pwa-node",
                        request = "attach",
                        processId = function()
                            require("dap.utils").pick_process({
                                filter = "node",
                            })
                        end,
                        name = "Attach debugger to existing `node --inspect` process",
                        sourceMaps = true,
                        resolveSourceMapLocations = {
                            "${workspaceFolder}/**",
                            "!**/node_modules/**",
                        },
                        cwd = "${workspaceFolder}/src",
                        skipFiles = {
                            "${workspaceFolder}/node_modules/**/*.js",
                        },
                    },
                    {
                        type = "pwa-chrome",
                        name = "Launch Chrome to debug client",
                        request = "launch",
                        url = "http://localhost:5173",
                        sourceMaps = true,
                        protocol = "inspector",
                        port = 9222,
                        webRoot = "${workspaceFolder}/src",
                        -- skip files from vite's hmr
                        skipFiles = {
                            "**/node_modules/**/*",
                            "**/@vite/*",
                            "**/src/client/*",
                            "**/src/*",
                        },
                    },
                    language == "javascript"
                            and {
                                type = "pwa-node",
                                request = "launch",
                                name = "Launch file in new node process",
                                program = "${file}",
                                cwd = "${workspaceFolder}",
                            }
                        or nil,
                }
            end
        end,
    },
    {
        "igorlfs/nvim-dap-view",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {},
    },
    {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
    },
}
