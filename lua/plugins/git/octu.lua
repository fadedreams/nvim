-- https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian
-- gh auth login
return {
  "pwntester/octo.nvim",
  cmd = "Octo",
  event = {{event = "BufReadPost", pattern = "octo://*"}},
  opts = {
    -- enable_builtin = true,
    -- default_to_projects_v2 = true,
    -- default_merge_method = "squash",
    -- picker = "fzf-lua",
    -- picker_config = {
    --   use_emojis = true,
    -- },
  },
  keys = {
    {"<leader>oi", "<cmd>Octo issue list<CR>", desc = "[O]ctu List Issues"},
    {"<leader>oI", "<cmd>Octo issue search<CR>", desc = "[O]ctu Search Issues"},
    {"<leader>op", "<cmd>Octo pr list<CR>", desc = "[O]ctu List PRs"},
    {"<leader>oP", "<cmd>Octo pr search<CR>", desc = "[O]ctu Search PRs"},
    {"<leader>or", "<cmd>Octo repo list<CR>", desc = "[O]ctu List Repos"},
    {"<leader>oS", "<cmd>Octo search<CR>", desc = "[O]ctu Search"},
    {"<localleader>a", "", desc = "+assignee", ft = "octo"},
    {"<localleader>c", "", desc = "+comment/code", ft = "octo"},
    {"<localleader>l", "", desc = "+label", ft = "octo"},
    {"<localleader>i", "", desc = "+issue", ft = "octo"},
    {"<localleader>r", "", desc = "+react", ft = "octo"},
    {"<localleader>p", "", desc = "+pr", ft = "octo"},
    {"<localleader>pr", "", desc = "+rebase", ft = "octo"},
    {"<localleader>ps", "", desc = "+squash", ft = "octo"},
    {"<localleader>v", "", desc = "+review", ft = "octo"},
    {"<localleader>g", "", desc = "+goto_issue", ft = "octo"},
    {"@", "@<C-x><C-o>", mode = "i", ft = "octo", silent = true},
    {"#", "#<C-x><C-o>", mode = "i", ft = "octo", silent = true},
  },
}
-- return {
-- 	{
-- 		"pwntester/octo.nvim",
--     --lazy = true, -- Enable lazy loading
--     event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
-- 		dependencies = {
-- 			"nvim-lua/plenary.nvim",
-- 			"nvim-telescope/telescope.nvim",
-- 			"nvim-tree/nvim-web-devicons",
-- 		},
-- 		cmd = { "Octo" },
-- 		event = { "BufReadPost */issues/*", "BufReadPost */pull/*" },
-- 		keys = {
-- 			{ "<leader>gil", "<cmd>Octo issue list<cr>", desc = "List GitHub Issues" },
--       { "<leader>gic", "<cmd>Octo issue create<cr>", desc = "Create GitHub Issue" },
--       { "<leader>gic", "<cmd>Octo issue close<cr>", desc = "Close GitHub Issue" },
--       { "<leader>gie", "<cmd>Octo issue edit<cr>", desc = "Edit GitHub Issue" },
--       { "<leader>gib", "<cmd>Octo issue browser<cr>", desc = "Open Issue/PR in Browser" },
--       { "<leader>gir", "<cmd>Octo issue reopen<cr>", desc = "Reopen GitHub Issue" },
--
-- 			{ "<leader>gpl", "<cmd>Octo pr list<cr>", desc = "List GitHub PRs" },
--       { "<leader>gpc", "<cmd>Octo pr create<cr>", desc = "Create GitHub PR" },
--
-- 			{ "<leader>gcc", "<cmd>Octo comment add<cr>", desc = "Add Comment to Issue" },
--
-- 			{ "<leader>grs", "<cmd>Octo review start<cr>", desc = "Start PR Review" },
-- 			{ "<leader>gre", "<cmd>Octo review submit<cr>", desc = "Submit PR Review" },
-- 		},
-- 		opts = function()
-- 			return {}
-- 		end,
-- 		config = function(_, opts)
-- 			require("octo").setup(opts)
-- 		end,
-- 	},
-- }
