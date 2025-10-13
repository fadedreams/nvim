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
			"<leader>lro",
			function()
				vim.lsp.buf.code_action({
					apply = true,
					context = {
						only = { "source.organizeImports" },
						diagnostics = {},
					},
				})
			end,
			desc = desc("Organize imports"),
		},
		{
			"<leader>lrf",
			function()
				vim.lsp.buf.code_action({
					apply = true,
					context = {
						only = { "source.fixAll" },
						diagnostics = {},
					},
				})
			end,
			desc = desc("Fix all"),
		},
		{
			"<leader>lrr",
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
			"<leader>lrc",
			function()
				vim.lsp.buf.execute_command({ command = "rust-analyzer.runSingle", arguments = {} })
			end,
			desc = desc("Run single"),
		},
	},
}
