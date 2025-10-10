local desc = Utils.plugin_keymap_desc("phpactor")

return {
	settings = {
		phpactor = {
			-- No specific settings needed for basic usage
		},
	},
	keys = {
		{
			"<leader>lho",
			function()
				vim.lsp.buf.code_action({
					apply = true,
					context = {
						only = { "source.organizeImports" },
						diagnostics = {},
					},
				})
			end,
			desc = desc("Organize imports PHP"),
		},
		{
			"<leader>lhf",
			function()
				vim.lsp.buf.format({ async = true })
			end,
			desc = desc("Format document PHP"),
		},
		{
			"<leader>lhc",
			function()
				vim.lsp.buf.code_action({
					context = {
						diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
					},
				})
			end,
			desc = desc("List all code actions"),
		},
	},
}
