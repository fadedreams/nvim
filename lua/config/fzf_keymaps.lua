local fzf = require("fzf-lua")
-- local actions = require("fzf-lua.actions")
local exclude_list_sp = {
	"all.txt",
	"tree.txt",
}

-- Define an exclude list
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

-- Function to build the exclude options for rg commands
local function build_exclude_opts_rg(exclude_list)
	local exclude_opts = {}
	for _, exclude in ipairs(exclude_list) do
		table.insert(exclude_opts, "--glob '!*" .. exclude .. "'")
	end
	return table.concat(exclude_opts, " ")
end

-- Combine exclude_list and exclude_dirs into a single table
local combined_excludes = {}
for _, exclude in ipairs(exclude_list) do
	table.insert(combined_excludes, exclude)
end
for _, exclude in ipairs(exclude_dirs) do
	table.insert(combined_excludes, exclude)
end

-- Build the exclude options for fd and rg
local exclude_opts_fd = build_exclude_opts_fd(combined_excludes) -- Use combined_excludes
local combined_opts = build_exclude_opts_rg(combined_excludes)

-- Construct the fd command with dynamic excludes
local fd_command = "fd --type d " .. build_exclude_opts_fd(exclude_dirs)

local function folder_grep()
	fzf.fzf_exec(fd_command, {
		prompt = "Folder: ",
		actions = {
			["default"] = function(selected)
				if selected and #selected > 0 then
					fzf.live_grep({
						cwd = selected[1],
						rg_opts = "--hidden --no-ignore --ignore-case " .. combined_opts, -- Use combined_opts
					})
				end
			end,
		},
	})
end

vim.keymap.set("n", "<leader>ft", ":TodoFzfLua<CR>", { noremap = true, silent = true, desc = "Find Todo" })

vim.keymap.set("n", "<leader><leader>", function()
	fzf.files({
		cmd = "fd --type f --hidden " .. exclude_opts_fd, -- Search for files, excluding specified patterns
		cwd = vim.loop.cwd(),
		prompt = "Files> ",
	})
end, { noremap = true, silent = true, desc = "Find files" })

vim.keymap.set("n", "<leader>fg", function()
	local input = vim.fn.input("Glob pattern (e.g., *c.lua): ")
	if input == "" then
		-- print("No glob pattern provided")
    vim.notify("No glob pattern provided")
		return
	end
	fzf.files({
		cmd = "fd --type f --hidden " .. exclude_opts_fd .. " --glob '" .. input .. "'",
		cwd = vim.loop.cwd(),
		prompt = "Files (" .. input .. ")> ",
	})
end, { noremap = true, silent = true, desc = "Find files with glob" })

vim.keymap.set("n", "<leader>fD", function()
	fzf.files({
		cmd = "fd --type d --hidden " .. exclude_opts_fd, -- Search for directories
		cwd = vim.loop.cwd(),
		prompt = "Directories> ",
	})
end, { noremap = true, silent = true, desc = "Search for Directories" })

vim.keymap.set("n", "<leader>fg", function()
	local input = vim.fn.input("Search query: ")
	if input == "" then
		-- print("No search query provided")
    vim.notify("No search query provided")
		return
	end
	fzf.grep({
		search = input,
		rg_opts = "--hidden --no-ignore --ignore-case " .. combined_opts, -- Use combined_opts
		cwd = vim.loop.cwd(),
		prompt = "Grep> ",
	})
end, { noremap = true, silent = true, desc = "Grep with query" })

vim.keymap.set("n", "<leader>qf", function()
	fzf.grep_quickfix({ rg_opts = "--hidden --no-ignore --ignore-case " .. combined_opts }) -- Use combined_opts
end, { noremap = true, silent = true, desc = "find text in Quickfix fzf" })

-- vim.keymap.set("n", "<leader>qS", function()
-- 	fzf.grep_quickfix({ rg_opts = "--hidden --no-ignore " .. combined_opts }) -- Use combined_opts
-- end, { noremap = true, silent = true, desc = "Quickfix Case sensitive" })

vim.keymap.set("n", "<leader>n", function()
	fzf.live_grep({ rg_opts = "--hidden --no-ignore --ignore-case " .. combined_opts }) -- Use combined_opts
end, { noremap = true, silent = true, desc = "Live grep" })

vim.keymap.set("n", "<leader>fn", function()
	fzf.live_grep({ rg_opts = "--hidden --no-ignore " .. combined_opts }) -- Use combined_opts
end, { noremap = true, silent = true, desc = "Live grep Case sensitive" })

vim.keymap.set("n", "<leader>N", function()
	fzf.lgrep_curbuf({
		prompt = "Buffer Grep> ",
		rg_opts = "--column --line-number --no-heading --color=always --smart-case",
	})
end, { noremap = true, silent = true, desc = "Live grep Current buffer" })

local function get_visual_selection()
	local selection = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
	selection = string.gsub(selection, "@", "\\@")
	return selection
end

vim.keymap.set("n", "<leader>m", function()
	fzf.resume()
end, { noremap = true, silent = true, desc = "Resume previous live grep search" })


vim.keymap.set("n", "<F2>", fzf.spell_suggest, { desc = "Spell suggestions" })
vim.keymap.set("n", "<leader>i8", fzf.colorschemes, { desc = "Colorschemes" })

vim.keymap.set("n", "<leader>fh", fzf.search_history, { desc = "Search history" })
vim.keymap.set("n", "<leader>'", fzf.registers, { desc = "Registers" })
vim.keymap.set("n", "<leader>`", fzf.marks, { desc = "Find marks" })

vim.keymap.set("n", "<leader>,", function()
	fzf.buffers({
		prompt = "Buffers> ",
		fzf_opts = {
			["--preview"] = "bat --style=numbers --color=always --line-range :500 {}",
		},
	})
end, { noremap = true, silent = true, desc = "FZF Buffers with preview" })

vim.keymap.set("n", "<leader>fw", fzf.lsp_workspace_symbols, { desc = "Workspace Symbols" })
vim.keymap.set("n", "ge", fzf.diagnostics_workspace, { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "<leader>fk", fzf.keymaps, { desc = "keymaps" })
vim.keymap.set("n", "<leader>fo", fzf.oldfiles, { desc = "Old Files" })
vim.keymap.set("n", "<leader>fq", fzf.quickfix, { desc = "Find quickfix" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find recent buffers" })
vim.keymap.set("n", "<leader>:", fzf.command_history, { desc = "Find command history" })
vim.keymap.set("n", "<leader>fr", fzf.lsp_references, { desc = "references" })
vim.keymap.set("n", "<leader>fy", fzf.lsp_document_symbols, { desc = "document_symbols" })
vim.keymap.set("n", "<leader>fw", fzf.lsp_live_workspace_symbols, { desc = "live_workspace_symbols" })
vim.keymap.set("n", "<leader>fd", folder_grep, { desc = "Grep on selected folder" })

vim.keymap.set("n", "<leader>f1", function()
	local word = vim.fn.expand("<cword>")
	fzf.live_grep({
		search = word,
		rg_opts = "--line-number --hidden " .. combined_opts, -- Use combined_opts
		cwd = vim.loop.cwd(),
		prompt = "",
    silent = true,
	})
end, { noremap = true, silent = true, desc = "Case sensitive" })

vim.keymap.set("n", "<leader>1", function()
	local word = vim.fn.expand("<cword>")
	fzf.live_grep({
		search = word,
		rg_opts = "--line-number --hidden --ignore-case " .. combined_opts, -- Use combined_opts
		cwd = vim.loop.cwd(),
		prompt = "Ignore case",
    silent = true,
	})
end, { noremap = true, silent = true, desc = "Search text" })

vim.keymap.set("n", "<leader>4", function()
	local line = vim.fn.getline(".")
	local cursor_col = vim.fn.col(".")
	local pattern = "([%w%.%-%:\\,\\\\_-:?;%%!@#%$%^&*+%s/{}]+)"
	local match_start, match_end = nil, nil
	for start, word in line:gmatch("()(" .. pattern .. ")") do
		local finish = start + #word - 1
		if cursor_col >= start and cursor_col <= finish then
			match_start, match_end = start, finish
			break
		end
	end
	if match_start and match_end then
		local match = line:sub(match_start, match_end)
		fzf.grep({ search = match })
	else
		-- print("No matching pattern found at cursor position")
    vim.notify("No matching pattern found at cursor position")
	end
end, { noremap = true, silent = true, desc = "Search text under cursor" })

vim.keymap.set("n", "<leader>2", function()
	local word = vim.fn.expand("<cword>")
	fzf.files({
		query = word,
		cmd = "fd --type f --type d --hidden " .. exclude_opts_fd,
		cwd = vim.loop.cwd(),
	})
end, { noremap = true, silent = true, desc = "Search files/dirs under cursor" })

vim.keymap.set("n", "<leader>3", function()
	local word = vim.fn.expand("<cword>")
	fzf.files({
		query = word,
		cmd = "fd --type d --hidden " .. exclude_opts_fd,
		cwd = vim.loop.cwd(),
	})
end, { noremap = true, silent = true, desc = "Search directories under cursor" })

vim.keymap.set("v", "<leader>1", fzf.grep_visual, { desc = "fzf selection" })

vim.keymap.set("v", "<leader>2", function()
	local search_term = get_visual_selection()
	-- print("search_term: '" .. search_term .. "'")
  vim.notify("search_term: '" .. search_term .. "'")
	if search_term == "" then
		-- print("no text selected.")
    vim.notify("no text selected.")
		return
	end
	local cwd = vim.loop.cwd()
	local fzf_opts = {
		query = search_term,
		cwd = cwd,
		find_command = { "fd", "--type", "f", "--hidden", exclude_opts_fd },
	}
	fzf.files(fzf_opts)
end, { desc = "FZF Directory Search", noremap = true, silent = true })

vim.keymap.set("v", "<leader>3", function()
	local search_term = get_visual_selection()
	-- print("search_term: '" .. search_term .. "'")
  vim.notify("search_term: '" .. search_term .. "'")
	if search_term == "" then
		-- print("no text selected.")
    vim.notify("no text selected.")
		return
	end
	local cwd = vim.loop.cwd()
	local fzf_opts = {
		query = search_term,
		cwd = cwd,
		find_command = { "fd", "--type", "d", "--hidden", exclude_opts_fd },
	}
	fzf.files(fzf_opts)
end, { desc = "FZF Directory Search", noremap = true, silent = true })

vim.keymap.set({ "n", "v", "i" }, "<C-q><C-x>", function()
	require("fzf-lua").complete_path()
end, { silent = true, desc = "Fuzzy complete path" })

vim.keymap.set("n", "<leader>fe", function()
	local input = vim.fn.input("Exclude extensions (space separated, e.g. js ts): ")
	if input == "" then
		fzf.files({
			cmd = "fd --type f --hidden " .. exclude_opts_fd,
			cwd = vim.loop.cwd(),
			prompt = "Files> ",
		})
		return
	end
	local glob_filters = {}
	for ext in input:gmatch("%S+") do
		if not ext:match("^%.") then
			ext = "." .. ext
		end
		table.insert(glob_filters, "--glob '*" .. ext .. "'")
	end
	local all_excludes = {}
	for _, e in ipairs(combined_excludes) do -- Use combined_excludes
		table.insert(all_excludes, e)
	end
	for _, e in ipairs(glob_filters) do
		table.insert(all_excludes, e)
	end
	local temp_exclude_opts = build_exclude_opts_fd(all_excludes)
	fzf.files({
		cmd = "fd --type f --hidden " .. temp_exclude_opts,
		cwd = vim.loop.cwd(),
		prompt = "Files (excluding " .. input .. ")> ",
	})
end, { noremap = true, silent = true, desc = "Find files excluding custom extensions" })

vim.keymap.set("n", "<leader>fx", function()
	local input = vim.fn.input("Search extensions (space separated, e.g. js yaml): ")
	if input == "" then
		print("No extensions provided, defaulting to all files.")
		fzf.files({
			cmd = "fd --type f --hidden " .. exclude_opts_fd,
			cwd = vim.loop.cwd(),
			prompt = "Files> ",
		})
		return
	end
	local query = vim.fn.input("Search query (optional): ")
	local ext_filters = {}
	for ext in input:gmatch("%S+") do
		if not ext:match("^%.") then
			ext = "." .. ext
		end
		table.insert(ext_filters, "--extension " .. ext:sub(2))
	end
	local cmd = "fd --type f --hidden " .. table.concat(ext_filters, " ") .. " " .. exclude_opts_fd
	fzf.files({
		cmd = cmd,
		query = query ~= "" and query or nil,
		cwd = vim.loop.cwd(),
		prompt = "Files (" .. input .. ")> ",
	})
end, { noremap = true, silent = true, desc = "Search files by user-specified extensions" })

vim.keymap.set("n", "<leader>xn", function()
	local input = vim.fn.input("Search extensions (space separated, e.g. js yaml): ")
	if input == "" then
		-- print("No extensions provided, defaulting to all files.")
    vim.notify("No extensions provided, defaulting to all files.")
		fzf.files({
			cmd = "fd --type f --hidden " .. exclude_opts_fd,
			cwd = vim.loop.cwd(),
			prompt = "Files> ",
		})
		return
	end
	local glob_filters = {}
	for ext in input:gmatch("%S+") do
		if not ext:match("^%.") then
			ext = "." .. ext
		end
		table.insert(glob_filters, "--glob '*" .. ext .. "'")
	end
	local rg_cmd = "--hidden --no-ignore " .. table.concat(glob_filters, " ") .. " " .. combined_opts -- Use combined_opts
	fzf.live_grep_glob({
		rg_opts = rg_cmd,
		cwd = vim.loop.cwd(),
		prompt = "Grep (" .. input .. ")> ",
	})
end, { noremap = true, silent = true, desc = "Live grep by user-specified extensions" })

vim.keymap.set("n", "<leader>en", function()
	local input = vim.fn.input("Exclude extensions (space separated, e.g. js yaml): ")
	if input == "" then
		-- print("No extensions provided, defaulting to all files.")
    vim.notify("No extensions provided, defaulting to all files.")
		fzf.files({
			cmd = "fd --type f --hidden " .. exclude_opts_fd,
			cwd = vim.loop.cwd(),
			prompt = "Files> ",
		})
		return
	end
	local glob_filters = {}
	for ext in input:gmatch("%S+") do
		if not ext:match("^%.") then
			ext = "." .. ext
		end
		table.insert(glob_filters, "--glob '!*" .. ext .. "'")
	end
	local rg_cmd = "--hidden --no-ignore " .. table.concat(glob_filters, " ") .. " " .. combined_opts -- Use combined_opts
	fzf.live_grep_glob({
		rg_opts = rg_cmd,
		cwd = vim.loop.cwd(),
		prompt = "Grep (excluding " .. input .. ")> ",
	})
end, { noremap = true, silent = true, desc = "Live grep excluding user-specified extensions" })
