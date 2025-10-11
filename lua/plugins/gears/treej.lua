return {
	"Wansmer/treesj",
  event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
	keys = {
		{ "<a-s-j>", "<cmd>TSJToggle<cr>", desc = "Toggle Treesj" },
	},
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("treesj").setup({
			-- Your configuration options here
			use_default_keymaps = false, -- Disable default keymaps to avoid conflicts
			check_syntax_error = true,
			max_join_length = 120,
			cursor_behavior = "hold",
			notify = true,
		})
	end,
}
