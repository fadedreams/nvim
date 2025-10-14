function search_under_cursor()
	-- local word = vim.fn.expand("<cword>")
	-- local pattern = "([%w%.%-%:\\,\\\\_:?;%!@#%$%^&*+]+)"
	local pattern = "([%w_-]+)"
	local line = vim.fn.getline(".")
	local cursor_col = vim.fn.col(".")

	local match = line:match(pattern, cursor_col)

	if match then
		vim.api.nvim_command('let @/ = "\\V' .. match .. '\\V"')
		vim.api.nvim_command("/\\V\\<" .. vim.fn.escape(match, "\\") .. "\\>")
	end
end

function search_under_cursor_simple()
	-- local word = vim.fn.expand("<cword>")
	-- local pattern = "([%w%.%-%:\\,\\\\_:?;%!@#%$%^&*+]+)"

	local word = vim.fn.expand("<cword>")
	local line = vim.fn.getline(".")
	local cursor_col = vim.fn.col(".")
	local match = line:match(word, cursor_col)

	if match then
		vim.api.nvim_command('let @/ = "\\V' .. match .. '\\V"')
		vim.api.nvim_command("/\\V\\<" .. vim.fn.escape(match, "\\") .. "\\>")
	end
end

local function get_visual_selection()
	return table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
end

-- Map the function to the leader + / key
-- vim.api.nvim_set_keymap("n", "<leader>jj", ":lua search_under_cursor()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>kk", ":lua search_under_cursor_simple()<CR>", { noremap = true, silent = true })
function search_under_visual()
	-- Get the visual selection as a search term
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")
	local lines = vim.fn.getline(start_pos[2], end_pos[2])
	local word = table.concat(lines, "\n"):sub(start_pos[3], end_pos[3] - 1 + (#lines > 1 and 1 or 0))

	-- Escape special characters for Vim's search pattern
	local escaped_word = vim.fn.escape(word, "\\/.*$^~[]")

	-- Start the search in the current file with the escaped word
	vim.api.nvim_command('let @/ = "\\V' .. escaped_word .. '"')
	vim.api.nvim_command("/\\V" .. escaped_word)
end

vim.api.nvim_set_keymap("v", "<C-/>", ":lua search_under_visual()<CR>", { noremap = true, silent = true })

-- Function to search word under cursor in the current file using a custom pattern
function search_text_under_cursor()
	-- Get the current line and cursor position
	local line = vim.fn.getline(".")
	local col = vim.fn.col(".")

	-- Define the pattern to match words (including spaces and specified characters)
	local pattern = "([%w%.%-%:\\,\\\\_-:?;%%!@#%$%^&*+%s]+)"

	-- Find the start and end positions of the word under the cursor
	local start_col, end_col, word = line:find(pattern, col - 1)

	-- Check if a word was found and the cursor is within its bounds
	if not word or col < start_col or col > end_col then
		vim.notify("No valid word under cursor", vim.log.levels.WARN)
		return
	end

	-- Escape special characters for Vim's search pattern
	local escaped_word = vim.fn.escape(word, "\\/.*$^~[]")

	-- Set the search register and start the search
	vim.api.nvim_command('let @/ = "\\V' .. escaped_word .. '"')
	vim.api.nvim_command("/\\V" .. escaped_word)
end

-- Keymap to trigger the search
-- vim.keymap.set(
-- 	"n",
-- 	"<C-f>",
-- 	":lua search_text_under_cursor()<CR>",
-- 	{ noremap = true, silent = true, desc = "Search text under cursor in current file" }
-- )

--- Searches for text under the cursor in a simple manner.
-- @return nil
-- function search_yanked_text()
-- 	-- Get the yanked text from the default register
-- 	local yanked_text = vim.fn.getreg('"')
--
-- 	-- Escape the yanked text for exact match and case insensitivity
-- 	local escaped_text = vim.fn.escape(yanked_text, "\\")
--
-- 	-- Construct a pattern that matches the exact yanked text
-- 	local pattern = "\\V" .. escaped_text
--
-- 	-- Set the search register and perform the search
-- 	vim.api.nvim_command('let @/ = "' .. pattern .. '"')
-- 	vim.api.nvim_command("/" .. pattern)
-- end
--
-- -- Map the function to the leader + y key
-- vim.api.nvim_set_keymap(
-- 	"n",
-- 	"<leader>sy",
-- 	":lua search_yanked_text()<CR>",
-- 	{ noremap = true, silent = true, desc = "search yanked text" }
-- )

function search_clipboard_text()
	-- Get the system clipboard content
	local clipboard_text = vim.fn.getreg("+")

	-- Escape the clipboard text for exact match and case insensitivity
	local escaped_text = vim.fn.escape(clipboard_text, "\\")

	-- Construct a pattern that matches the exact clipboard text
	local pattern = "\\V" .. escaped_text

	-- Set the search register and perform the search
	vim.api.nvim_command('let @/ = "' .. pattern .. '"')
	vim.api.nvim_command("/" .. pattern)
end



-- Map the function to <leader>sc (sc for search clipboard)
vim.keymap.set(
	"n",
	"<leader>ys",
	":lua search_clipboard_text()<CR>",
	{ noremap = true, silent = true, desc = "[Y]ank [S]earch" }
)


-- Search and replace the word under cursor in whole buffer
vim.keymap.set("n", "<leader>rr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {
	desc = "Replace word under cursor", -- Description for which-key
	noremap = true,
	silent = true,
})

-- visual_search_replace
function visual_search_replace()
	-- Save the start and end positions of the visual selection
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	-- Get the lines and columns of the selection
	local start_line = start_pos[2]
	local end_line = end_pos[2]
	local start_col = start_pos[3]
	local end_col = end_pos[3]

	-- Get the text from the selected lines
	local lines = vim.fn.getline(start_line, end_line)

	-- Adjust the end column if the selection spans multiple lines
	if #lines > 1 then
		end_col = #lines[#lines]
	end

	-- Extract the selected text
	local selected_text
	if #lines == 1 then
		selected_text = lines[1]:sub(start_col, end_col)
	else
		selected_text = lines[1]:sub(start_col)
		for i = 2, #lines - 1 do
			selected_text = selected_text .. "\n" .. lines[i]
		end
		selected_text = selected_text .. "\n" .. lines[#lines]:sub(1, end_col)
	end

	-- Escape special characters for Vim's search pattern
	local escaped_text = vim.fn.escape(selected_text, "\\/.*$^~[]")

	-- Prompt for the replacement text
	local replace_text = vim.fn.input("Replace with: ")

	-- Perform the replacement
	vim.cmd("%s/\\V" .. escaped_text .. "/" .. replace_text .. "/gc")
end

-- Map the function to a keybinding in visual mode
vim.api.nvim_set_keymap("v", "<leader>rr", ":lua visual_search_replace()<CR>", { noremap = true, silent = true })

-- visual_search
function visual_search()
	-- Save the start and end positions of the visual selection
	local start_pos = vim.fn.getpos("'<")
	local end_pos = vim.fn.getpos("'>")

	-- Get the lines and columns of the selection
	local start_line = start_pos[2]
	local end_line = end_pos[2]
	local start_col = start_pos[3]
	local end_col = end_pos[3]

	-- Get the text from the selected lines
	local lines = vim.fn.getline(start_line, end_line)

	-- Adjust the end column if the selection spans multiple lines
	if #lines > 1 then
		end_col = #lines[#lines]
	end

	-- Extract the selected text
	local selected_text
	if #lines == 1 then
		selected_text = lines[1]:sub(start_col, end_col)
	else
		selected_text = lines[1]:sub(start_col)
		for i = 2, #lines - 1 do
			selected_text = selected_text .. "\n" .. lines[i]
		end
		selected_text = selected_text .. "\n" .. lines[#lines]:sub(1, end_col)
	end

	-- Escape special characters for Vim's search pattern
	local escaped_text = vim.fn.escape(selected_text, "\\/.*$^~[]")

	-- Search for the text (using very nomagic mode \V)
	vim.cmd("let @/ = '\\V" .. escaped_text .. "'")
	vim.cmd("set hlsearch")
end

-- Map the function to <leader>/ in visual mode
vim.api.nvim_set_keymap("v", "<leader>/", ":lua visual_search()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>t", ":nohlsearch<CR>", { noremap = true, silent = true, desc="Clear Highlight, V <leader>/" }) --c-l do it
