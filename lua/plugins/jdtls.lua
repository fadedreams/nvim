-- brew install jdtls --MasonInstall jdtls fails because ir ips
return {
	{
		"mfussenegger/nvim-jdtls",
		lazy = true,
		ft = { "java" },
	},
	-- {
	-- "nvim-java/nvim-java",
	-- -- lazy = true, -- Enable lazy loading
	-- -- event = "VeryLazy", -- Optional: Lazy-load on events to improve startup time
	-- },
}
