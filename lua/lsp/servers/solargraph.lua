--- ./lua/lsp/servers/solargraph.lua ---
local desc = Utils.plugin_keymap_desc("solargraph")

return {
	settings = {
		solargraph = {
			diagnostics = true,
			completion = true,
			hover = true,
			folding = true,
			autoformat = false,
			useBundler = true,
		},
	},
	keys = {
		-- these are not supported i guess
		-- {
		-- 	"<leader>ro",
		-- 	function()
		-- 		vim.lsp.buf.code_action({
		-- 			apply = true,
		-- 			context = {
		-- 				only = { "source.organizeImports" },
		-- 				diagnostics = {},
		-- 			},
		-- 		})
		-- 	end,
		-- 	desc = desc("Organize imports"),
		-- },
		-- 	{
		-- 		"<leader>rf",
		-- 		function()
		-- 			vim.lsp.buf.format({ async = true })
		-- 		end,
		-- 		desc = desc("Format document"),
		-- 	},
		-- 	{
		-- 		"<leader>rc",
		-- 		function()
		-- 			vim.lsp.buf.code_action({
		-- 				context = {
		-- 					diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
		-- 				},
		-- 			})
		-- 		end,
		-- 		desc = desc("List all code actions"),
		-- 	},
	},
}
