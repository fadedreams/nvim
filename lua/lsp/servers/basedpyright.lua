local desc = Utils.plugin_keymap_desc("basedpyright")
return {
	settings = {
		basedpyright = {
			analysis = {
				autoImportCompletions = true, -- Automatically offer import completions
				autoSearchPaths = true, -- Automatically search for Python files
				diagnosticMode = "workspace", -- Analyze the entire workspace
				typeCheckingMode = "strict", -- Enable strict mode to flag undefined names
				useLibraryCodeForTypes = true, -- Use library code for type information
			},
			-- Disable certain diagnostics if needed
			disableOrganizeImports = false, -- Enable organize imports
			disableLanguageServices = false, -- Keep language services enabled
		},
	},
	keys = {
		{
			"<leader>lpo",
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
			"<leader>lpf",
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
			"<leader>lpa",
			function()
				vim.lsp.buf.code_action({
					apply = true,
					context = {
						only = { "quickfix" },
					},
				})
			end,
			desc = desc("Add missing import (cursor on symbol)"),
		},
		{
			"<leader>lpr",
			function()
				vim.lsp.buf.code_action({
					apply = true,
					context = {
						only = { "source.removeUnusedImports" },
						diagnostics = {},
					},
				})
			end,
			desc = desc("Remove unused imports"),
		},
		{
			"<leader>lpc",
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
