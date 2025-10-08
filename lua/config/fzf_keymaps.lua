local fzf = require("fzf-lua")
-- local actions = require("fzf-lua.actions")

local exclude_list_sp = {
	"all.txt",
	"tree.txt",
}
-- Define an exclude list
-- local exclude_list = { ".git", "node_modules", "dist", ".idea", "build" }
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

-- Function to build the exclude options for fd commands
local function build_exclude_opts_fd(exclude_list)
	local exclude_opts = {}
	for _, exclude in ipairs(exclude_list) do
		table.insert(exclude_opts, "--exclude " .. exclude)
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

-- local exclude_opts_rg = build_exclude_opts_rg(exclude_list)
-- local exclude_opts_sp = build_exclude_opts_rg(exclude_list_sp)
local combined_opts = build_exclude_opts_rg(exclude_list)

local exclude_opts_fd = build_exclude_opts_fd(exclude_list)

local exclude_dirs = {
  "node_modules", -- JavaScript/Node.js
  ".idea", -- JetBrains IDEs
  "venv", -- Python virtual environment
  ".venv", -- Alternative Python virtual environment
  "__pycache__", -- Python bytecode cache
  "_build", -- Lua build directories (e.g., for LuaRocks)
  "dist", -- Common build output directory
  "build", -- Common build output directory
  "vendor", -- Dependency directories (e.g., PHP Composer, Go)
  "target", -- Rust build directory
  ".git", -- Git repository directory
  ".cache", -- Cache directories
  "coverage", -- Test coverage reports
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
  "public/packs", -- Rails Webpacker
  "public/assets", -- Rails asset pipeline
  "storage", -- Laravel storage
  "cache", -- General cache (Django, PHP)
  "migrations", -- Django migrations
  "vendor/bin", -- PHP Composer binaries
  ".cargo", -- Rust package manager
  "go/pkg", -- Go package directory
  "go/bin", -- Go binary directory
}

-- Construct the fd command with dynamic excludes
local fd_command = "fd --type d " .. table.concat(vim.tbl_map(function(dir) return "--exclude " .. dir end, exclude_dirs), " ")
local function folder_grep()
  fzf.fzf_exec(fd_command, {
      prompt = "Folder: ",
      actions = {
          ["default"] = function(selected)
              if selected and #selected > 0 then
                  fzf.live_grep({ cwd = selected[1], rg_opts = "--hidden --no-ignore --ignore-case " .. combined_opts })
              end
          end,
      },
  })
end

-- vim.keymap.set("v", "<leader>/", function()
--   local buffer_file = vim.fn.expand("%:p") -- Get the full path of the current buffer file
--   local search_term = get_visual_selection() -- Get the selected text in visual mode
--
--   -- Search the selected text within the current file (buffer)
--   fzf.live_grep({ search = search_term, files = { buffer_file }, cwd = vim.fn.expand("%:p:h") })
-- end, { noremap = true, silent = true })

-- Example key mappings
-- vim.keymap.set("n", "<leader>ff", fzf.files) -- Find files
-- vim.keymap.set("n", "<leader><leader>", fzf.files) -- Find files

-- Modified keymap for <leader>ff to exclude specific files and folders
-- vim.keymap.set("n", "<leader>ff", function()
--     -- local exclude_opts = build_exclude_opts(exclude_list, "fd")
--     fzf.files({
--         cmd = "fd --type f --hidden " .. exclude_opts, -- Search for files, excluding specified patterns recursively
--         cwd = vim.loop.cwd(), -- Set current working directory
--         prompt = "Files> ", -- Custom prompt for clarity
--     })
-- end, { noremap = true, silent = true, desc = "Find files" })

vim.keymap.set("n", "<leader>ft", ":TodoFzfLua<CR>",  { noremap = true, silent = true, desc = "Find Todo"})

vim.keymap.set("n", "<leader><leader>", function()
	local exclude_opts = build_exclude_opts_fd(exclude_list)
	-- print("exclude_opts: " .. exclude_opts)
	fzf.files({
		cmd = "fd --type f --hidden " .. exclude_opts, -- Search for files, excluding specified patterns recursively
		cwd = vim.loop.cwd(), -- Set current working directory
		prompt = "Files> ", -- Custom prompt for clarity
	})
end, { noremap = true, silent = true, desc = "Find files" })

vim.keymap.set("n", "<leader>fg", function()
  local exclude_opts = build_exclude_opts_fd(exclude_list)
  local input = vim.fn.input("Glob pattern (e.g., *c.lua): ")
  if input == "" then
    print("No glob pattern provided")
    return
  end
  fzf.files({
    cmd = "fd --type f --hidden " .. exclude_opts .. " --glob '" .. input .. "'",
    cwd = vim.loop.cwd(),
    prompt = "Files (" .. input .. ")> ",
  })
end, { noremap = true, silent = true, desc = "Find files with glob" })
-- Keymap to list all files and directories in the current folder
-- vim.keymap.set(
--   "n",
--   "<leader>fl",
--   function()
--     -- Get the current buffer's full file path
--     local current_buffer_path = vim.fn.expand("%:p:h") -- Get the directory of the current buffer
--
--     -- Build the fd command to list all files and directories (including hidden) in the current folder
--     local cmd = "fd --type d --type f --hidden --max-depth 1"
--
--     -- Use fzf-lua to search in the current buffer's directory
--     require("fzf-lua").files({
--       cmd = cmd,
--       cwd = current_buffer_path, -- Set the current buffer directory as the cwd
--     })
--   end,
--   { noremap = true, silent = true, desc = "List all files and directories (including hidden) in the current folder" }
-- )

-- vim.keymap.set(
--   "n",
--   "<leader>v",
--   function()
--     -- Get the current buffer's full file path
--     local current_buffer_path = vim.fn.expand("%:p:h") -- Get the directory of the current buffer
--
--     -- Build the fd command to list all files and directories (including hidden) with recursion
--     local cmd = "fd --type d --type f --hidden" -- Remove --max-depth to allow traversal
--
--     -- Use fzf-lua to search in the current buffer's directory
--     require("fzf-lua").files({
--       cmd = cmd,
--       cwd = current_buffer_path, -- Set the current buffer directory as the cwd
--     })
--   end,
--   {
--     noremap = true,
--     silent = true,
--     desc = "List all files and directories (including hidden) in the current folder with traversal",
--   }
-- )

-- Search for directories
-- vim.keymap.set("n", "<leader>fd", function()
--   local query = vim.fn.input("Search for Dir: ") -- Prompt for input
--   if query ~= "" then
--     local exclude_opts = build_exclude_opts(exclude_list)
--     fzf.files({ query = query, cmd = "fd --type d --hidden " .. exclude_opts }) -- Search directories based on input query
--   else
--     print("No search query entered.")
--   end
-- end, { noremap = true, silent = true, desc = "Search for Directories" })

vim.keymap.set("n", "<leader>fD", function()
	-- local exclude_opts = build_exclude_opts(exclude_list, "fd")
	fzf.files({
		cmd = "fd --type d --hidden " .. exclude_opts_fd, -- Search for directories, including hidden ones
		cwd = vim.loop.cwd(), -- Set current working directory
		prompt = "Directories> ", -- Custom prompt for clarity
	})
end, { noremap = true, silent = true, desc = "Search for Directories" })

-- Search for files
-- vim.keymap.set("n", "<leader>fs", function()
--   local query = vim.fn.input("Search for String: ") -- Prompt for input
--   if query ~= "" then
--     local exclude_opts = build_exclude_opts(exclude_list)
--     fzf.files({ query = query, cmd = "fd --type f --hidden " .. exclude_opts }) -- Search files based on input query
--   else
--     print("No search query entered.")
--   end
-- end, { noremap = true, silent = true, desc = "Search for Strings" })

-- vim.keymap.set("n", "<leader>n", fzf.live_grep) -- Live grep

-- vim.keymap.set("n", "<leader>n", function()
--     local exclude_opts = build_exclude_opts(exclude_list, "rg")
--     fzf.live_grep({
--         exec = "rg --line-number --hidden --no-ignore '!.env' " .. exclude_opts, -- Apply exclude list to ripgrep
--         cwd = vim.loop.cwd(),
--         prompt = "Live Grep",
--     })
-- end, { noremap = true, silent = true, desc = "Live grep" })
--
vim.keymap.set("n", "<leader>fg", function()
	local input = vim.fn.input("Search query: ")
	if input == "" then
		print("No search query provided")
		return
	end
	fzf.grep({
		search = input,
		rg_opts = "--hidden --no-ignore --ignore-case " .. combined_opts,
		cwd = vim.loop.cwd(),
		prompt = "Grep> ",
	})
end, { noremap = true, silent = true, desc = "Grep with query" })


vim.keymap.set("n", "<leader>n", function()
	-- local exclude_opts = build_exclude_opts(exclude_list, "rg")
	fzf.live_grep({ rg_opts = "--hidden --no-ignore --ignore-case " .. combined_opts })
end, { noremap = true, silent = true, desc = "Ignore case" })

vim.keymap.set("n", "<leader>fn", function()
	-- local exclude_opts = build_exclude_opts(exclude_list, "rg")
	fzf.live_grep({ rg_opts = "--hidden --no-ignore " .. combined_opts })
end, { noremap = true, silent = true, desc = "Case sensitive" })

vim.keymap.set("n", "<leader>bn", function()
	fzf.lgrep_curbuf({
		prompt = "Buffer Grep> ",
		rg_opts = "--column --line-number --no-heading --color=always --smart-case",
	})
end, { noremap = true, silent = true, desc = "Live grep current buffer" })

local function get_visual_selection()
	local selection = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
	-- Escape the '@' symbol in the selected text
	selection = string.gsub(selection, "@", "\\@")
	return selection
end

vim.keymap.set("n", "<leader>m", function()
	-- local exclude_opts = build_exclude_opts(exclude_list, "rg")
	fzf.resume()
end, { noremap = true, silent = true, desc = "Resume previous live grep search" })

-- vim.keymap.set("n", "<leader>fs", fzf.sessions, { desc = "Sessions" })
-- vim.keymap.set("n", "<F2>", fzf.spell_suggest, { desc = "Spell suggestions" })
-- vim.keymap.set("n", "<leader>fc", fzf.colorschemes, { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>fh", fzf.search_history, { desc = "Search history" })

vim.keymap.set("n", "<leader>'", fzf.registers, { desc = "Registers" }) -- Find registers
vim.keymap.set("n", "<leader>`", fzf.marks, { desc = "Find marks" }) -- Find marks
-- vim.keymap.set("n", "<leader>,", fzf.buffers, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>,", function()
	fzf.buffers({
		prompt = "Buffers> ",
		fzf_opts = {
			["--preview"] = "bat --style=numbers --color=always --line-range :500 {}",
		},
	})
end, { noremap = true, silent = true, desc = "FZF Buffers with preview" })


-- vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, { desc = "Document Symbols" })
vim.keymap.set("n", "<leader>fw", fzf.lsp_workspace_symbols, { desc = "Workspace Symbols" })
vim.keymap.set("n", "ge", fzf.diagnostics_workspace, { desc = "Workspace Diagnostics" })

-- vim.keymap.set("n", "<leader>fq", fzf.quickfix, { desc = "Quickfix List" })
-- vim.keymap.set("n", "<leader>fl", fzf.loclist, { desc = "Location List" })
-- vim.keymap.set("n", "", fzf.helptags, { desc = "Search Help Tags" })
vim.keymap.set("n", "<leader>fk", fzf.keymaps, { desc = "keymaps" }) -- Find keymaps

-- Recent files
-- vim.keymap.set("n", "<leader>fr", function()
--   fzf.oldfiles({
--     fzf_opts = {
--       ["--height"] = "40%",
--       ["--preview"] = "bat --style=numbers --color=always --line-range :500 {}",
--     },
--   })
-- end, { desc = "Recent files" })

-- vim.keymap.set("n", "<leader>gb", fzf.git_blame, { desc = "Git Blame" })
-- vim.keymap.set("n", "<leader>gf", fzf.git_files, { desc = "Git Files" })
-- vim.keymap.set("n", "<leader>gs", fzf.git_status, { desc = "Git Status" })
-- vim.keymap.set("n", "<leader>gr", fzf.git_branches, { desc = "Git Branches" })
-- vim.keymap.set("n", "<leader>gc", fzf.git_commits, { desc = "Find git commits" }) --S-Down S-Up, a-j, a-k
-- vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "buffers" }) --S-Down S-Up, a-j, a-k

vim.keymap.set("n", "<leader>fo", fzf.oldfiles, { desc = "Old Files" })
vim.keymap.set("n", "<leader>fq", fzf.quickfix, { desc = "Find quickfix" })
vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Find recent buffers" })
-- vim.keymap.set("n", "<leader>fc", fzf.colorschemes, { desc = "Find colorschemes" })
vim.keymap.set("n", "<leader>:", fzf.command_history, { desc = "Find command history" })


vim.keymap.set("n", "<leader>fh", fzf.search_history, { desc = "search_history" })
--vim.keymap.set("n", "<leader>fa", fzf.lsp_document_diagnostics, { desc = "document_diagnostics" })
vim.keymap.set("n", "<leader>fr", fzf.lsp_references, { desc = "references" })
vim.keymap.set("n", "<leader>fy", fzf.lsp_document_symbols, { desc = "document_symbols" })
vim.keymap.set("n", "<leader>fw", fzf.lsp_live_workspace_symbols, { desc = "live_workspace_symbols" })
vim.keymap.set("n", "<leader>fd", folder_grep, { desc = "Grep on selected folder" })


-- vim.keymap.set("n", "<leader>fl", fzf.loclist, { desc = "Location List" })
-- vim.keymap.set("n", "<leader>k", fzf.tabs, { desc = "Switch Between Tabs" })

-- vim.keymap.set("n", "<leader>fo", function()
--   fzf.lsp_document_symbols({
--     symbol_style = 3,
--     no_header_i = true,
--     winopts = {},
--   })
-- end, { desc = "[f]ind LSP [s]ymbols" })

-- vim.keymap.set("n", "<leader>1", require("fzf-lua").grep_cword, { desc = "FZF Word" })

-- vim.keymap.set("n", "<leader>1", function()
--     local word = vim.fn.expand("<cword>") -- Get the word under the cursor
--     local exclude_opts = build_exclude_opts(exclude_list, "rg")
--     fzf.live_grep({
--         search = word, -- Pre-fill the search with the word under cursor
--         exec = "rg  --line-number --hidden " .. exclude_opts, -- Search text in hidden files
--         cwd = vim.loop.cwd(), -- Set current working directory
--         prompt = "Grep Text (hidden)> ", -- Updated prompt to reflect text search
--     })
-- end, { noremap = true, silent = true, desc = "Search text" })

--case sensitive
vim.keymap.set("n", "<leader>f1", function()
	local word = vim.fn.expand("<cword>") -- Get the word under the cursor
	-- local exclude_opts = build_exclude_opts(exclude_list, "rg")
	fzf.live_grep({
		search = word, -- Pre-fill the search with the word under cursor
		rg_opts = "--line-number --hidden " .. combined_opts, -- Search text in hidden files
		cwd = vim.loop.cwd(), -- Set current working directory
		prompt = "Case sensitive", -- Updated prompt to reflect text search
	})
end, { noremap = true, silent = true, desc = "Search text" })

vim.keymap.set("n", "<leader>1", function()
	local word = vim.fn.expand("<cword>") -- Get the word under the cursor
	-- local exclude_opts = build_exclude_opts(exclude_list, "rg")
	fzf.live_grep({
		search = word, -- Pre-fill the search with the word under cursor
		rg_opts = "--line-number --hidden --ignore-case " .. combined_opts, -- Search text in hidden files
		cwd = vim.loop.cwd(), -- Set current working directory
		prompt = "Ignore case", -- Updated prompt to reflect text search
	})
end, { noremap = true, silent = true, desc = "Search text" })

-- vim.keymap.set("n", "<leader>1", function()
--   local word = vim.fn.expand("<cword>") -- Get the word under the cursor
--   fzf.grep({ search = word }) -- Trigger fzf-lua with the search term
-- end, { noremap = true, silent = true })

-- vim.keymap.set("n", "<leader>1", require("fzf-lua").grep_cword, { desc = "FZF Word" })
vim.keymap.set("n", "<leader>4", function()
	local line = vim.fn.getline(".") -- Get the current line
	local cursor_col = vim.fn.col(".") -- Get the cursor column position

	-- Define the pattern to match words, numbers, special characters, spaces, and curly braces
	local pattern = "([%w%.%-%:\\,\\\\_-:?;%%!@#%$%^&*+%s/{}]+)" -- Added /{} to the pattern
	-- local pattern = "([%w%.%-%:\\,\\\\_-:?;%%!@#%$%^&*+%s/{}()[]<>]+)" -- Added /{}()[]<> to the pattern
	-- local pattern = "([%w]+%-[%w]+|[%w%.%:\\,\\\\_/?;%%!@#%$%^&*+%s{}()[]<>\"']+)"
	local match_start, match_end = nil, nil

	-- Search for the match in the line
	for start, word in line:gmatch("()(" .. pattern .. ")") do
		local finish = start + #word - 1
		if cursor_col >= start and cursor_col <= finish then
			match_start, match_end = start, finish
			break
		end
	end

	-- Trigger fzf.grep with the matched word
	if match_start and match_end then
		local match = line:sub(match_start, match_end)
		fzf.grep({ search = match }) -- Use the match as the search term
	else
		print("No matching pattern found at cursor position")
	end
end, { noremap = true, silent = true, desc = "Search text under cursor" })

-- vim.keymap.set("n", "<leader>1q", fzf.grep_cWORD, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>2", function()
	local word = vim.fn.expand("<cword>") -- Get the word under the cursor
	-- local exclude_opts = build_exclude_opts(exclude_list, "fd")
	fzf.files({
		query = word,
		cmd = "fd --type f --type d --hidden " .. exclude_opts_fd, -- Search for hidden files and directories
		cwd = vim.loop.cwd(), -- Set current working directory
	})
end, { noremap = true, silent = true, desc = "Search files under cursor" })

-- vim.keymap.set("n", "<leader>5", function()
--   local line = vim.fn.getline(".") -- Get the current line
--   local cursor_col = vim.fn.col(".") -- Get the cursor column position
--
--   -- Define the pattern to match words, numbers, and special characters
--   -- local pattern = "([%w%.%-%:\\,\\\\_-:?;%%!@#%$%^&*+]+)"
--   local pattern = "([%w%.%-%:\\,\\\\_-:?;%%!@#%$%^&*+%s]+)" --with space %s
--   local match_start, match_end = nil, nil
--
--   -- Search for the match in the line
--   for start, word in line:gmatch("()(" .. pattern .. ")") do
--     local finish = start + #word - 1
--     if cursor_col >= start and cursor_col <= finish then
--       match_start, match_end = start, finish
--       break
--     end
--   end
--
--   -- Trigger fzf.grep with the matched word
--   if match_start and match_end then
--     local match = line:sub(match_start, match_end)
--     fzf.grep({ search = match }) -- Use the match as the search term
--     fzf.files({ query = match }) -- Trigger fzf-lua with the word as the search term in file search
--   else
--     print("No matching pattern found at cursor position")
--   end
-- end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>3", function()
	local word = vim.fn.expand("<cword>") -- Get the word under the cursor
	-- local exclude_opts = build_exclude_opts(exclude_list, "fd")
	fzf.files({
		query = word,
		cmd = "fd --type d --hidden " .. exclude_opts_fd, -- Search for hidden directories
		cwd = vim.loop.cwd(), -- Set current working directory
	})
end, { noremap = true, silent = true, desc = "Search directories under cursor" })

-- Search for directories with specific query
-- vim.keymap.set("n", "<leader>6", function()
--   local word = vim.fn.expand("<cword>") -- Get the word under the cursor
--   local exclude_opts = build_exclude_opts(exclude_list)
--   fzf.files({ query = word, cmd = "fd --type d --hidden " .. exclude_opts })
-- end, { noremap = true, silent = true })

-- search for directories based on the match in the current line
-- vim.keymap.set("n", "<leader>7", function()
--   local line = vim.fn.getline(".") -- get the current line
--   local cursor_col = vim.fn.col(".") -- get the cursor column position
--   local match = line:match("([^%s%[%]%(%)'%\"\\]+)", cursor_col)
--
--   if match then
--     -- if a match is found, use fzf to search for directories based on the match
--     local exclude_opts = build_exclude_opts(exclude_list)
--     print("<leader>7 match: " .. match) -- debugging: print the matched word
--     fzf.files({ query = match, cmd = "fd --type d --hidden " .. exclude_opts }) -- only search for directories
--   else
--     print("no match found at cursor position.")
--   end
-- end, { noremap = true, silent = true })
--
local function get_visual_selection()
	local selection = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
	-- Escape the '@' symbol in the selected text
	selection = string.gsub(selection, "@", "\\@")
	return selection
end

-- vim.keymap.set("v", "<C-f>", function()
--   local word = get_visual_selection()
--   if word and word ~= "" then
--     fzf.files({ search = word }) -- Trigger fzf-lua find_files with the selected text
--   else
--     print("No selection found")
--   end
-- end, { noremap = true, silent = true })

-- files
vim.keymap.set("v", "<leader>1", fzf.grep_visual, { desc = "fzf selection" })
-- vim.keymap.set("v", "<leader>2", fzf.grep_visual, { desc = "fzf selection" })
--string
-- vim.keymap.set("v", "<C-s>", function()
--   local search_term = get_visual_selection() -- get the selected text in visual mode
--   fzf.grep({ search = search_term }) -- trigger fzf-lua with the search term
-- end, { noremap = true, silent = true })

vim.keymap.set("v", "<leader>2", function()
	local search_term = get_visual_selection() -- get the selected text in visual mode
	print("search_term: '" .. search_term .. "'") -- debugging: check the value of search_term
	if search_term == "" then
		print("no text selected.")
		return
	end

	local cwd = vim.loop.cwd() -- Get the current working directory
	-- local exclude_opts = build_exclude_opts(exclude_list, "fd")
	local fzf_opts = {
		query = search_term, -- Set the search term (from the visual selection)
		cwd = cwd, -- Set the current directory as cwd
		find_command = { "fd", "--type", "f", "--hidden", exclude_opts_fd }, -- Only search for directories with fd
	}
	-- Trigger fzf-lua with the find_command option for searching directories
	fzf.files(fzf_opts)
end, { desc = "FZF Directory Search", noremap = true, silent = true })

vim.keymap.set("v", "<leader>3", function()
	local search_term = get_visual_selection() -- get the selected text in visual mode
	print("search_term: '" .. search_term .. "'") -- debugging: check the value of search_term
	if search_term == "" then
		print("no text selected.")
		return
	end

	local cwd = vim.loop.cwd() -- Get the current working directory
	-- local exclude_opts = build_exclude_opts(exclude_list, "fd")
	local fzf_opts = {
		query = search_term, -- Set the search term (from the visual selection)
		cwd = cwd, -- Set the current directory as cwd
		find_command = { "fd", "--type", "d", "--hidden", exclude_opts_fd }, -- Only search for directories with fd
	}
	-- Trigger fzf-lua with the find_command option for searching directories
	fzf.files(fzf_opts)
end, { desc = "FZF Directory Search", noremap = true, silent = true })

vim.keymap.set({ "n", "v", "i" }, "<leader>fp", function()
	require("fzf-lua").complete_path()
end, { silent = true, desc = "Fuzzy complete path" })

vim.keymap.set({ "n", "v" }, "<leader>fp", function()
	require("fzf-lua").complete_path()
end, { silent = true, desc = "Fuzzy complete path" })

-- Live grep with multiple file extensions for text search
-- Add this keymap to your existing configuration

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
	for _, e in ipairs(exclude_list) do
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
	local input = vim.fn.input("Search extensions (space separated, e.g. js yaml): ") -- Prompt for extensions
	if input == "" then
		print("No extensions provided, defaulting to all files.")
		fzf.files({
			cmd = "fd --type f --hidden " .. exclude_opts_fd, -- Fallback to all files with exclusions
			cwd = vim.loop.cwd(),
			prompt = "Files> ",
		})
		return
	end

	local query = vim.fn.input("Search query (optional): ") -- Prompt for search query
	local ext_filters = {}
	for ext in input:gmatch("%S+") do
		if not ext:match("^%.") then
			ext = "." .. ext
		end
		table.insert(ext_filters, "--extension " .. ext:sub(2)) -- Remove leading dot for fd
	end

	local cmd = "fd --type f --hidden " .. table.concat(ext_filters, " ") .. " " .. exclude_opts_fd
	fzf.files({
		cmd = cmd, -- Search files with specified extensions
		query = query ~= "" and query or nil, -- Use query if provided
		cwd = vim.loop.cwd(),
		prompt = "Files (" .. input .. ")> ", -- Custom prompt showing extensions
	})
end, { noremap = true, silent = true, desc = "Search files by user-specified extensions" })

vim.keymap.set("n", "<leader>xn", function()
	local input = vim.fn.input("Search extensions (space separated, e.g. js yaml): ") -- Prompt for extensions
	if input == "" then
		print("No extensions provided, defaulting to all files.")
		fzf.files({
			cmd = "fd --type f --hidden " .. exclude_opts_fd, -- Fallback to all files with exclusions
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
		table.insert(glob_filters, "--glob '*" .. ext .. "'") -- Add glob pattern for ripgrep
	end

	local rg_cmd = "--hidden --no-ignore " .. table.concat(glob_filters, " ") .. " " .. combined_opts
	fzf.live_grep_glob({
		rg_opts = rg_cmd, -- Search files with specified extensions using ripgrep
		cwd = vim.loop.cwd(),
		prompt = "Grep (" .. input .. ")> ", -- Custom prompt showing extensions
	})
end, { noremap = true, silent = true, desc = "Live grep by user-specified extensions" })

vim.keymap.set("n", "<leader>en", function()
	local input = vim.fn.input("Exclude extensions (space separated, e.g. js yaml): ") -- Prompt for extensions to exclude
	if input == "" then
		print("No extensions provided, defaulting to all files.")
		fzf.files({
			cmd = "fd --type f --hidden " .. exclude_opts_fd, -- Fallback to all files with exclusions
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
		table.insert(glob_filters, "--glob '!*" .. ext .. "'") -- Add negative glob pattern for ripgrep
	end

	local rg_cmd = "--hidden --no-ignore " .. table.concat(glob_filters, " ") .. " " .. combined_opts
	fzf.live_grep_glob({
		rg_opts = rg_cmd, -- Search files excluding specified extensions using ripgrep
		cwd = vim.loop.cwd(),
		prompt = "Grep (excluding " .. input .. ")> ", -- Custom prompt showing excluded extensions
	})
end, { noremap = true, silent = true, desc = "Live grep excluding user-specified extensions" })
