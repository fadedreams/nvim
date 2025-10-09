local desc = Utils.plugin_keymap_desc("rust_analyzer")

return {
    settings = {
        ["rust-analyzer"] = {
            checkOnSave = {
                command = "clippy", -- Use clippy for checking on save
            },
            imports = {
                granularity = {
                    group = "module",
                },
                prefix = "self",
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
        },
    },
    keys = {
        {
            "<leader>rr",
            function()
                vim.lsp.buf.code_action({
                    apply = true,
                    context = {
                        only = { "quickfix" },
                        diagnostics = {},
                    },
                })
            end,
            desc = desc("Run quickfix"),
        },
        {
            "<leader>rc",
            function()
                vim.lsp.buf.execute_command({ command = "rust-analyzer.runSingle", arguments = {} })
            end,
            desc = desc("Run single"),
        },
    },
}
