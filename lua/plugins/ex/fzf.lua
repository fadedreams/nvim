
-- local grep_opts = {
-- 	"rg",
-- 	"--vimgrep",
-- 	"--hidden",
-- 	"--follow",
-- 	"--glob",
-- 	'"!**/.git/*"',
-- 	"--column",
-- 	"--line-number",
-- 	"--no-heading",
-- 	"--color=always",
-- 	"--smart-case",
-- 	"--max-columns=4096",
-- 	"-e",
-- }

-- Define an exclude list (simplified for testing)
local exclude_list = {
	"all.txt",
	"tree.txt",
	"LICENSE",
	".git",
	"venv",
	"*.pyc", -- Python compiled files
	"*.pyo", -- Python optimized files
	"*.log", -- Log files (Ruby, Laravel, Django)
	"*.bak", -- Backup files
	"*.exe", -- Executables
	"*.out", -- Compiled output
	"*.o", -- Object files
	"*.a", -- Static libraries (Golang, C)
	"*.rlib", -- Rust libraries
	"*.phtml", -- PHP templates
	"*.phar", -- PHP archives
	"*.tsx", -- TypeScript React
	"*.luarocks", -- Lua package manager
	"*.rock", -- Lua Rocks
	"*.class", -- Java classes
	"*.jar", -- Java archives
	"*.war", -- Java web archives
	"*.swp", -- Vim swap files
	"*.swo", -- Vim swap files
	"*.min.js", -- Minified JavaScript
	"*.min.css", -- Minified CSS
	"*.map", -- Source maps
	"*.lock", -- Lock files (package-lock.json, Gemfile.lock)
	"*.DS_Store", -- macOS system files
	"*.tmp", -- Temporary files
	"*.temp", -- Alternative temporary files
	"*.rb~", -- Ruby backup files
	"*.erb~", -- Ruby ERB template backups
	"Gemfile.lock", -- Ruby Bundler lock file
	"*.rbc", -- Ruby compiled files
	"*.gem", -- Ruby gem files
	"*.rs.bk", -- Rust backup files
	"*.php~", -- PHP backup files
	"*.blade.php~", -- Laravel Blade template backups
	"*.phps", -- PHP source files
	"*.cache", -- Laravel/Django cache files
	"*.sqlite", -- Django default database
	"*.sqlite3", -- Django SQLite database
	"db.sqlite3", -- Django default database
	"*.py.bak", -- Python backup files
	"*.go~", -- Go backup files
	"go.sum", -- Go module checksums
	"go.mod.bak", -- Go module backup
}

local exclude_dirs = {
	"node_modules", -- JavaScript/Node.js
	".idea", -- JetBrains IDEs
	"venv", -- Python virtual environment
	".venv", -- Alternative Python virtual environment
	"__pycache__", -- Python bytecode cache
	-- "_build", -- Lua build directories (e.g., for LuaRocks)
	-- "dist", -- Common build output directory
	-- "build", -- Common build output directory
	-- "vendor", -- Dependency directories (e.g., PHP Composer, Go)
	-- "target", -- Rust build directory
	".git", -- Git repository directory
	".cache", -- Cache directories
	-- "coverage", -- Test coverage reports
	"tmp", -- Temporary directories
	"temp", -- Alternative temporary directories
	".pytest_cache", -- Pytest cache
	".tox", -- Python tox testing
	"out", -- Common output directory
	"bin", -- Binary output directory
	"obj", -- Object files directory (e.g., C/C++)
	".next", -- Next.js build directory
	".nuxt", -- Nuxt.js build directory
	".bundle", -- Ruby Bundler
	"log", -- Ruby/Rails, Laravel, Django logs
	-- "public/packs", -- Rails Webpacker
	-- "public/assets", -- Rails asset pipeline
	-- "storage", -- Laravel storage
	-- "cache", -- General cache (Django, PHP)
	-- "migrations", -- Django migrations
	"vendor/bin", -- PHP Composer binaries
	".cargo", -- Rust package manager
	-- "go/pkg", -- Go package directory
	-- "go/bin", -- Go binary directory
}

-- Function to build the exclude options for fd commands
local function build_exclude_opts_fd(exclude_list)
  local exclude_opts = {}
  for _, exclude in ipairs(exclude_list) do
    table.insert(exclude_opts, "--exclude '" .. exclude .. "'")
  end
  return table.concat(exclude_opts, " ")
end

-- Combine exclude_list and exclude_dirs
local combined_excludes = {}
for _, exclude in ipairs(exclude_list) do
  table.insert(combined_excludes, exclude)
end
for _, exclude in ipairs(exclude_dirs) do
  table.insert(combined_excludes, exclude)
end

-- Build the exclude options for fd
local combined_opts = build_exclude_opts_fd(combined_excludes)
-- print("combined_opts: " .. combined_opts) -- Debug output

return {
	"ibhagwan/fzf-lua",
	-- lazy = true, -- Enable lazy loading
	event = "VeryLazy",
	cmd = "FzfLua",
	-- optional for icon support
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local action = require("fzf-lua.actions")
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
					["ctrl-q"] = action.file_sel_to_qf, -- Send selected files to quickfix
					["ctrl-j"] = "down",
					["ctrl-k"] = "up",
					-- ["ctrl-m"] = "accept", --<CR>
					["ctrl-a"] = "first", -- Go to the first item in the list
					["ctrl-e"] = "last", -- Go to the last item in the list
					["ctrl-h"] = "close",
					["ctrl-l"] = "accept",
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
					["ctrl-x"] = { fn = require("fzf-lua").actions.buf_del, reload = true }, -- Custom delete key
				},
        winopts = {
          width = 0.40,
          height = 0.5,
          -- backdrop = 100,
          preview = {
            layout = "vertical",
            vertical = "down:45%",
          },
        },
			},
			actions = {
				files = {
					["ctrl-q"] = action.file_sel_to_qf, -- Added to support quickfix action
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
		-- { "<leader>,", false },
    {
      "<leader>dff",
      function()
        require('fzf-lua').files({
          cmd = 'fd --type f --hidden --ignore-case ' .. combined_opts,
          actions = {
            ['default'] = function(selected)
              if selected[1] then
                vim.cmd('diffsplit ' .. vim.fn.fnameescape(selected[1]))
              end
            end,
          },
        })
      end,
      desc = "Vertical diff split with file selected via fzf-lua",
    },
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
