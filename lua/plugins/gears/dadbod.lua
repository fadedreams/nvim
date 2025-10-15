-- sudo apt install sqlite3
return {
	"tpope/vim-dadbod",
	lazy = true,
	cmd = "DBUIToggle",
	dependencies = {
		"kristijanhusak/vim-dadbod-ui",
		"kristijanhusak/vim-dadbod-completion",
	},
	config = function(_, opts)
		vim.g.db_ui_save_location = vim.fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "sql" },
			command = [[setlocal omnifunc=vim_dadbod_completion#omni]],
		})
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "sql", "mysql", "plsql" },
			callback = function()
				vim.schedule(opts.db_completion)
			end,
		})
	end,
	keys = {
		{ "<leader>Dt", "<cmd>DBUIToggle<cr>", desc = "toggle ui" },
		{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "find buffer" },
		{ "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "rename buffer" },
		{ "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "last query" },
	},
}
