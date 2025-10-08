local grep_opts = {
    "rg",
    "--vimgrep",
    "--hidden",
    "--follow",
    "--glob",
    '"!**/.git/*"',
    "--column",
    "--line-number",
    "--no-heading",
    "--color=always",
    "--smart-case",
    "--max-columns=4096",
    "-e",
}

return {
	"ibhagwan/fzf-lua",
	-- lazy = true, -- Enable lazy loading
    event = "VeryLazy",
    cmd = "FzfLua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			fzf_colors = true,
			defaults = {
				formatter = "path.dirname_first",
			},
			fzf_opts = {
				["--tiebreak"] = "begin",
			},
			winopts = {
				width = 0.60,
				height = 0.9,
				backdrop = 100,
				preview = {
					layout = "vertical",
					vertical = "down:45%",
				},
			},
			files = {
				cmd = "fd --type f --hidden ", -- Include hidden files using fd
				cwd_prompt = false,
				-- git_icons = true,
				hidden = true,
				follow = true,
				-- Or, you could use the default fzf command like this:
				-- cmd = "fzf --hidden --preview 'cat {}' --border --layout=horizontal"
			},
			grep = {
				-- cmd = table.concat(grep_opts, " "),
				hidden = true,
				follow = true,
			},
			keymap = {
				fzf = {
					["ctrl-q"] = "select-all+accept", -- Ensure <C-q> sends to quickfix
					["alt-q"] = "accept",
					["ctrl-j"] = "down",
					["ctrl-k"] = "up",
					["ctrl-m"] = "accept", --<CR>
					["ctrl-a"] = "first", -- Go to the first item in the list
					["ctrl-e"] = "last", -- Go to the last item in the list
					["ctrl-l"] = "close",
					-- ["ctrl-j"] = "down", -- Move selection down
					-- ["ctrl-k"] = "up",   -- Move selection up
				},
				builtin = {
					--TODO: test
					["<C-d>"] = "preview-page-down",
					["<C-u>"] = "preview-page-up",
					["<S-down>"] = "preview-page-down",
					["<S-up>"] = "preview-page-up",
				},
			},
			buffers = {
				actions = {
					["ctrl-d"] = { fn = require("fzf-lua").actions.buf_del, reload = true }, -- Custom delete key
				},
			},
			actions = {
				files = {
					["ctrl-v"] = require("fzf-lua").actions.file_vsplit, -- Open file in vertical split
					["ctrl-s"] = require("fzf-lua").actions.file_split, -- Open file in horizontal split
					["default"] = require("fzf-lua").actions.file_edit, -- Default action (e.g., open in current buffer)
				},
			},
		})
	end,
	keys = {
		-- Disable the keymap to grep files
		{ "<leader>ss", false },

		-- {
		--   "<leader>fs",
		--   function()
		--     require("fzf-lua").lsp_document_symbols({
		--       -- regex_filter = true ,
		--       query = "!Constant !Property !Variable !EnumMember",
		--       symbol_style = 1,
		--       winopts = {
		--         height = 0.8,
		--         width = 0.8,
		--         preview = {
		--           vertical = "up:60%",
		--           layout = "horizontal",
		--         },
		--       },
		--     })
		--   end,
		--   desc = "Document Symbols (Functions and Classes)",
		-- },

		-- {
		--   "<leader>fb",
		--   function()
		--     require("fzf-lua").buffers()
		--   end,
		--   desc = "Open Buffers with fzf",
		-- },
	},
}
