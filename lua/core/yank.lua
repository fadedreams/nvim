
-- when you paste over a selection, the pasted text is automatically yanked back into the register.
vim.keymap.set("x", "p", "pgvy")
-- vim.keymap.set("n", "<leader>-p", "A<C-r>\"<Esc>", { desc = "Paste yanked text at end of line with leading space" }) --no space
-- vim.keymap.set("n", "<leader>-p", "A <C-r>\"<Esc>", { desc = "Paste yanked text at end of line with leading space" }) --extra space

--paste in insert mode
-- vim.api.nvim_set_keymap("i", "<a-o>", "<C-r>*", { noremap = true })
-- vim.api.nvim_set_keymap("i", "<C-A-p>", "<C-r>+<CR>", { noremap = true })

-- vim.api.nvim_set_keymap("n", "gp", "_:put<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "gp", "v_p", { noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<a-p>", ":put!<cr>", { noremap = true, silent = true }) --paste above
vim.api.nvim_set_keymap("n", "<leader>p", ":put<cr>", { noremap = true, silent = true }) --paste below
--vim.api.nvim_set_keymap("n", "<leader>p", ":put<cr>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<a-p>", "<c-r>+", { noremap = true }) --system clipboard
-- vim.api.nvim_set_keymap("i", "<a-s-p>", "<C-o>:put!<CR>", { noremap = true, silent = true }) --paste above
-- vim.api.nvim_set_keymap("i", "<c-s-p>", "<C-o>:put<CR>", { noremap = true, silent = true }) -- paste below


-- Yank the current file path to the system clipboard
function yank_file_path()
	local file_path = vim.fn.expand("%:p")
	vim.fn.setreg("+", file_path)
	vim.fn.setreg("*", file_path)
	-- print("File path copied to clipboard: " .. file_path)
  vim.notify("File path copied to clipboard: " .. file_path)
end

-- Map the function to a key combination (e.g., <Leader>y in normal mode)
vim.keymap.set("n", "<Leader>yp", ":lua yank_file_path()<CR>", { noremap = true, silent = true, desc = "yank path" })

-- Yank the directory path of the current file to the system clipboard
function yank_directory_path()
	local file_path = vim.fn.expand("%:p:h")
	vim.fn.setreg("+", file_path)
	vim.fn.setreg("*", file_path)
	-- print("Directory path copied to clipboard: " .. file_path)
  vim.notify("Directory path copied to clipboard: " .. file_path)
end

-- Map the function to a key combination (e.g., <Leader>yd in normal mode)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>yd",
	":lua yank_directory_path()<CR>",
	{ noremap = true, silent = true, desc = "yank dir" }
)

--- Yanks the relative file path of the current buffer to the clipboard.
-- Retrieves the relative path of the current file and copies it to both the '+' (system)
-- and '*' (primary) clipboard registers. Prints a confirmation message with the path.
-- @return nil
function yank_relative_file_path()
	local relative_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	vim.fn.setreg("+", relative_path)
	vim.fn.setreg("*", relative_path)
	-- print("Relative file path copied to clipboard: " .. relative_path)
  vim.notify("Relative file path copied to clipboard: " .. relative_path)
end

vim.keymap.set(
	"n",
	"<Leader>yr",
	":lua yank_relative_file_path()<CR>",
	{ noremap = true, silent = true, desc = "yank relative" }
)

--- Yanks the relative file path and entire content of the current buffer to the clipboard.
-- Retrieves the relative path of the current file and its full content, combines them with
-- a separator, and copies the result to both the '+' (system) and '*' (primary) clipboard
-- registers. Prints a confirmation message with the file path.
-- @return nil
local function yank_relative_file_path_and_all()
	local relative_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	if relative_path == "" then
		-- print("Error: No file associated with the current buffer")
    vim.notify("Error: No file associated with the current buffer")
		return
	end
	local file_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
	local combined = relative_path .. ":    " .. file_content
	vim.fn.setreg("+", combined)
	vim.fn.setreg("*", combined)
	-- print("Copied to clipboard: " .. relative_path)
  vim.notify("Copied to clipboard: " .. relative_path)
end

-- Use a Lua function call directly in the key mapping
vim.keymap.set("n", "<Leader>yu", function()
	yank_relative_file_path_and_all()
end, { noremap = true, silent = false, desc = "yank relative path and file content" })

-- yank all
vim.keymap.set(
	"n",
	"<Leader>ya",
	":cd $PWD<CR>:!/home/m/.config/nvim/file_dir_to_txt_exclude.sh && xclip -selection clipboard all.txt<CR>",
	{ noremap = true, silent = false, desc = "yank all" }
)
-- vim.keymap.set("n", "<Leader>ya", ":cd %:p:h<CR>:!/home/m/.config/nvim/file_dir_to_txt_exclude.sh && xclip -selection clipboard all.txt<CR>", { noremap = true, silent = false, desc = "yank all" })
-- yank all input exclusions
function YankWithCustomExclusions()
	-- Default directories to exclude (always included)
	local default_exclude_dirs = {
		"node_modules",
		"target",
		".git",
		"resources",
		".idea",
		".vscode",
		"__pycache__",
		"venv",
		".venv",
		".mypy_cache",
		".pytest_cache",
		"build",
		"dist",
		"out",
		"docs",
		"env",
	}
	-- Default files to exclude (always included)
	local default_exclude_files = {
		"file_dir_to_txt_exclude.sh",
		"file_dir_to_txt_exclude2.sh",
		".css",
		".svg",
		".gitignore",
		"serverall.js",
		".env",
		"all.txt",
		"tree.txt",
		"go.sum",
		"package-lock.json",
		"yarn.lock",
		".next",
		".env.local",
		".env.development.local",
		".env.production.local",
		".env.test.local",
		".env.development",
		".env.production",
		".env.test",
		".DS_Store",
		"Thumbs.db",
		"desktop.ini",
		"*.swp",
		"*.swo",
		"*.swn",
		"*.swm",
		"*.swl",
		"*.swk",
		"*.swj",
		"*.swh",
		"*.swc",
		"*.swb",
	}

	-- Prompt for additional directories and files to exclude in one input
	local user_exclusions =
		vim.fn.input("Enter additional directories and files to exclude (space-separated, press Enter to skip): ")
	local exclude_dirs = default_exclude_dirs
	local exclude_files = default_exclude_files

	if user_exclusions ~= "" then
		for item in user_exclusions:gmatch("%S+") do
			-- Assume items with a dot (.) are files, otherwise directories
			if item:match("%.") then
				table.insert(exclude_files, item)
			else
				table.insert(exclude_dirs, item)
			end
		end
	end

	-- Convert tables to space-separated strings for the shell command
	local exclude_dirs_str = table.concat(exclude_dirs, " ")
	local exclude_files_str = table.concat(exclude_files, " ")

	-- Change to the current working directory
	vim.cmd("cd " .. vim.fn.getcwd())
	-- Construct and execute the shell command
	local shell_cmd = string.format(
		"!/home/m/.config/nvim/file_dir_to_txt_exclude2.sh %s %s && xclip -selection clipboard all.txt",
		exclude_dirs_str,
		exclude_files_str
	)
	vim.cmd(shell_cmd)
end

vim.keymap.set(
	"n",
	"<Leader>ye",
	":lua YankWithCustomExclusions()<CR>",
	{ noremap = true, silent = false, desc = "yank all with custom exclusions" }
)

--- Yanks the relative file path of the current buffer without its extension to the clipboard.
-- Retrieves the relative path of the current file, removes its extension, and copies it to
-- both the '+' (system) and '*' (primary) clipboard registers. Prints a confirmation message.
-- @return nil
function yank_relative_file_path_without_ex()
	-- Get the relative file path
	local relative_path = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
	-- Remove the file extension
	local path_without_extension = vim.fn.fnamemodify(relative_path, ":r")
	-- Copy to clipboard registers
	vim.fn.setreg("+", path_without_extension)
	vim.fn.setreg("*", path_without_extension)
	-- Print confirmation message
	-- print("Relative file path (without extension) copied to clipboard: " .. path_without_extension)
  vim.notify("Relative file path (without extension) copied to clipboard: " .. path_without_extension)
end

-- vim.keymap.set("n", "<Leader>yt", ":cd %:p:h<CR>:!tree -I 'node_modules|venv|.git|.idea|vendor|__pycache__|.pytest_cache|target|dist|bin|obj|.next' -L 4 > tree.txt<CR>", { noremap = true, silent = false })
-- vim.keymap.set("n", "<Leader>yt", ":cd %:p:h<CR>:!tree -I 'node_modules|venv|.git|.ide' -L 4 | tee tree.txt | xclip -selection clipboard<CR>", { noremap = true, silent = false, desc = "yank tree" })
vim.keymap.set(
	"n",
	"<Leader>yt",
	":cd $PWD<CR>:!tree -I 'node_modules|venv|.git|.ide|all.txt|tree.txt' -L 4 | tee tree.txt | xclip -selection clipboard<CR>",
	{ noremap = true, silent = false, desc = "yank tree" }
)

-- Combine yank tree and yank all, with tree output at the end in all.txt
vim.keymap.set(
	"n",
	"<Leader>yh",
	":cd $PWD<CR>:!tree -I 'node_modules|venv|.git|.ide|all.txt|tree.txt' -L 4 > tree.txt && /home/m/.config/nvim/file_dir_to_txt_exclude.sh > all.txt && cat tree.txt >> all.txt && xclip -selection clipboard all.txt<CR>",
	{ noremap = true, silent = false, desc = "yank tree and all" }
)

--- Yanks the current buffer name (file name with extension) to the clipboard.
-- Retrieves the file name of the current buffer, including its extension, and copies it to
-- both the '+' (system) and '*' (primary) clipboard registers. Prints a confirmation message.
-- @return nil
function yank_buffer_name()
    local buffer_name = vim.fn.fnamemodify(vim.fn.expand("%"), ":t")
    if buffer_name == "" then
        -- print("Error: No file associated with the current buffer")
        vim.notify("Error: No file associated with the current buffer")
        return
    end
    vim.fn.setreg("+", buffer_name)
    vim.fn.setreg("*", buffer_name)
    -- print("Buffer name copied to clipboard: " .. buffer_name)
    vim.notify("Buffer name copied to clipboard: " .. buffer_name)
end

vim.keymap.set(
    "n",
    "<Leader>yn",
    ":lua yank_buffer_name()<CR>",
    { noremap = true, silent = true, desc = "yank buffer name with extension" }
)
