return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		-- Register custom keymap groups for better organization
		local wk = require("which-key")
		wk.add({
			{ "<leader>g", group = "Git" }, -- Group for Git-related keymaps
			{ "<leader>f", group = "File" }, -- Group for File-related keymaps
			{ "<leader>b", group = "Buffer" }, -- Group for Buffer-related keymaps
			{ "<leader>l", group = "Lngs" },
			{ "<leader>lh", group = "PHP" },
			{ "<leader>lp", group = "Py" },
			{ "<leader>lc", group = "Cpp" },
			{ "<leader>lj", group = "Java" },
			{ "<leader>u", group = "Utils" },
		})
	end,
	opts = {
		-- Window configuration
		win = {
			no_overlap = true, -- Avoid overlapping cursor
			col = -1, -- Anchor to the right edge
			row = -4, -- Anchor to top edge
			padding = { 0, 0 }, -- Top/bottom, right/left padding
			title = true, -- Show title
			title_pos = "center", -- Center the title
			zindex = 1000, -- Ensure popup is on top
			width = { min = 20, max = 50 }, -- Match layout width
			border = "single", -- Add a border for better visibility
		},
		-- Layout configuration
		layout = {
			align = "right", -- Align text to the right within the popup
			width = { min = 20, max = 50 }, -- Set reasonable width
			spacing = 3, -- Spacing between columns
		},
		-- Additional options
		icons = {
			mappings = true, -- Enable icons for keybindings (requires nvim-web-devicons)
		},
		triggers = { "<leader>", "<localleader>" }, -- Explicitly define triggers
		delay = 500, -- 500ms delay before showing popup
		disable = {
			filetypes = { "TelescopePrompt", "terminal" }, -- Disable for specific filetypes
		},
		sort = { "order", "group", "alphanum" }, -- Custom sorting for keymaps
		debug = false, -- Enable for troubleshooting (set to true if needed)
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
		{
			"<leader>??",
			function()
				require("which-key").show({ global = true })
			end,
			desc = "Global Keymaps (which-key)",
		},
	},
}
