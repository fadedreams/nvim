local desc = Utils.plugin_keymap_desc("clangd")

return {
	settings = {
		clangd = {
			InlayHints = {
				Enabled = true,
				ParameterNames = true,
				DeducedTypes = true,
			},
			fallbackFlags = { "--std=c++20" }, -- Adjust based on your C++ standard (e.g., c++17, c++20)
		},
	},
	keys = {
		-- {
		-- 	"<leader>lco",
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
		{
			"<leader>lcf",
			function()
				vim.lsp.buf.format({ async = true })
			end,
			desc = desc("Format document"),
		},
		{
			"<leader>lch",
			function()
				vim.lsp.buf.code_action({
					context = {
						diagnostics = vim.lsp.diagnostic.get_line_diagnostics(),
					},
				})
			end,
			desc = desc("List all code actions"),
		},
		-- {
		--   "<leader>lcs",
		--   function()
		--     vim.lsp.buf.code_action({
		--       apply = true,
		--       context = {
		--         only = { "source" }, -- Broad filter to catch source-related actions
		--         diagnostics = {},
		--       },
		--     })
		--   end,
		--   desc = desc("Switch between source/header"),
		-- },
		{
			"<leader>lcs",
			function()
				require("telescope").extensions.file_browser.file_browser({
					path = vim.fn.expand("%:p:h"),
					select_buffer = true,
					hidden = true,
					respect_gitignore = false,
					layout_strategy = "vertical",
					layout_config = {
						vertical = {
							height = 0.9,
							width = 0.6,
							preview_cutoff = 40,
							prompt_position = "top",
							mirror = true,
							preview_height = 0.6,
						},
					},
				})
			end,
			desc = desc("Browse for header/source"),
		},
	},
}
