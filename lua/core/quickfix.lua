-- Quickfix navigation keybindings (from previous request)
-- vim.keymap.set('n', '<c-m>', ':cnext<CR>', { noremap = true, silent = true, desc="cnext" })      -- Next item
-- vim.keymap.set('n', '<c-n>', ':cprev<CR>', { noremap = true, silent = true, desc="cprev"  })      -- Previous item
-- Quickfix navigation
vim.keymap.set("n", "[q", ":cprev<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "]q", ":cnext<CR>", { noremap = true, silent = true })
-- Location list navigation
-- vim.keymap.set('n', '[l', ':lprev<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', ']l', ':lnext<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>qq", ":copen<CR>", { noremap = true, silent = true, desc = "copen" }) -- Open quickfix window
vim.keymap.set("n", "q", ":cclose<CR>", { noremap = true, silent = true, desc = "cclose" }) -- Close quickfix window
-- vim.keymap.set("n", "<leader>qf", ":cfirst<CR>", { noremap = true, silent = true, desc = "cfirst" }) -- First item
-- vim.keymap.set("n", "<leader>ql", ":clast<CR>", { noremap = true, silent = true, desc = "clast" }) -- Last item
-- vim.keymap.set('n', '<leader>qr', ':crewind<CR>', { noremap = true, silent = true, desc="crewind"  }) -- Rewind to first item
-- vim.keymap.set("n", "<leader>qo", ":colder<CR>", { noremap = true, silent = true, desc = "colder" }) -- Older quickfix list
-- vim.keymap.set("n", "<leader>qn", ":cnewer<CR>", { noremap = true, silent = true, desc = "cnewer" }) -- Newer quickfix list
vim.keymap.set("n", "<leader>qc", ":cexpr []<CR>", { noremap = true, silent = true, desc = "Clear quickfix list" }) -- Clear quickfix list
vim.keymap.set("n", "<leader>qi", ":cfile ", { noremap = true, silent = true, desc = "cfile" }) -- Load from file
-- vim.keymap.set("n", "<leader>qb", ":cbuffer<CR>", { noremap = true, silent = true, desc = "cbuffer" }) -- Load from buffer
-- vim.keymap.set("n", "<leader>qc", ":cc ", { noremap = true, silent = true, desc = "Go to specific item" }) -- Go to specific item
-- vim.keymap.set("n", "<leader>qd", ":cfdo ", { noremap = true, silent = true, desc = "Batch command" }) -- Batch command
-- vim.keymap.set("n", "<leader>qC", ":cdo ", { noremap = true, silent = true, desc = "cdo" }) -- Batch command -- conflict with search fzf(leader>qs)

-- Keybindings for setting makeprg for different languages/tools
-- vim.keymap.set('n', '<leader>qtp', ":set makeprg=pytest\\ --tb=line<CR>", { noremap = true, silent = true }) -- Python (pytest)
-- vim.keymap.set('n', '<leader>qtn', ":set makeprg=npm\\ test<CR>", { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>qtg', ":set makeprg=go\\ test\\ ./...<CR>", { noremap = true, silent = true })  -- Go (go test)
-- vim.keymap.set('n', '<leader>qth', ":set makeprg=php\\ artisan\\ test<CR>", { noremap = true, silent = true }) -- PHP (Laravel artisan test)
-- vim.keymap.set('n', '<leader>qtu', ":set makeprg=vendor/bin/phpunit<CR>", { noremap = true, silent = true }) -- PHP (PHPUnit)

-- Keybindings for setting for linting
-- vim.keymap.set('n', '<leader>qln', ":set makeprg=npx\\ eslint<CR>", { noremap = true, silent = true })  -- Node.js (ESLint)
-- vim.keymap.set('n', '<leader>qlp', ":set makeprg=flake8<CR>", { noremap = true, silent = true })  -- Python (flake8)
-- vim.keymap.set('n', '<leader>qlg', ":set makeprg=golangci-lint\\ run\\ --out-format\\ line-number<CR>", { noremap = true, silent = true })  -- Go (golangci-lint)
-- vim.keymap.set('n', '<leader>qlh', ":set makeprg=vendor/bin/phpstan\\ analyse\\ --error-format=raw<CR>", { noremap = true, silent = true })  -- PHP (PHPStan)
-- Optional: Run makeprg and populate quickfix list
vim.keymap.set("n", "<leader>qm", ":make<CR>", { noremap = true, silent = true }) -- Run :make to execute the configured makeprg

local function quickfix_replace()
	-- Check if quickfix list is populated
	local qf_list = vim.fn.getqflist()
	if #qf_list == 0 then
		vim.notify("Error: Quickfix list is empty", vim.log.levels.ERROR)
		return
	end

	-- Prompt user for the text to replace (foo)
	local search = vim.fn.input({
		prompt = "Enter text to replace: ",
		cancelreturn = "",
	})
	if search == "" then
		vim.notify("Error: No search text provided", vim.log.levels.ERROR)
		return
	end

	-- Validate search string
	if string.match(search, "[/\\]") then
		vim.notify("Error: Search text contains invalid characters ('/' or '\\')", vim.log.levels.ERROR)
		return
	end

	-- Prompt user for the replacement string (bar)
	local replacement = vim.fn.input({
		prompt = "Enter replacement: ",
		cancelreturn = "",
	})
	if replacement == "" then
		vim.notify("Error: No replacement text provided", vim.log.levels.ERROR)
		return
	end

	-- Construct the cdo command for literal replacement
	local cmd =
		string.format("cdo %%s/%s/%s/g | update", vim.fn.escape(search, "/\\"), vim.fn.escape(replacement, "/\\"))

	-- Execute the command with error handling
	local success, error_msg = pcall(function()
		vim.cmd(cmd)
	end)

	if success then
		vim.notify(
			string.format("Successfully replaced '%s' with '%s' in %d files", search, replacement, #qf_list),
			vim.log.levels.INFO
		)
	else
		vim.notify("Error during replacement: " .. error_msg, vim.log.levels.ERROR)
	end
end

-- Create a user command :QuickFixReplace to call the function
vim.api.nvim_create_user_command("QuickFixReplace", quickfix_replace, {
	desc = "Replace text in all files in the quickfix list",
})

-- Optional: Map the function to a keybinding (e.g., <leader>qr)
vim.keymap.set("n", "<leader>qr", quickfix_replace, {
	noremap = true,
	silent = true,
	desc = "Prompt and replace in quickfix list",
})



-- Dump quickfix list to file or clipboard
local function dump_quickfix(opts)
  local qf = vim.fn.getqflist()
  if vim.tbl_isempty(qf) then
    print("Quickfix list is empty")
    return
  end

  -- Format lines: filename:lnum:col:text (escape colons in filename)
  local lines = {}
  for _, item in ipairs(qf) do
    local fname = (item.filename or ""):gsub(":", "\\:") -- Escape colons in filename
    table.insert(lines, string.format("%s:%d:%d:%s", 
      fname, item.lnum or 0, item.col or 0, item.text or ""))
  end

  if opts == "clipboard" then
    vim.fn.setreg("+", table.concat(lines, "\n"))
    print("✅ Quickfix list copied to clipboard (" .. #lines .. " items)")
  else
    local file = opts or "quickfix_dump.txt"
    vim.fn.writefile(lines, file)
    print("💾 Quickfix list saved to " .. file .. " (" .. #lines .. " items)")
  end
end

-- Load quickfix list from a saved file
local function load_quickfix(file)
  file = file or "quickfix_dump.txt"
  if vim.fn.filereadable(file) == 0 then
    print("❌ File not found: " .. file)
    return
  end

  local lines = vim.fn.readfile(file)
  local qf = {}

  for i, line in ipairs(lines) do
    if line == "" then goto continue end -- Skip empty lines
    
    -- Robust parsing: split by LAST two colons (handles colons in filename)
    local parts = {}
    for part in line:gmatch("[^:]+") do
      table.insert(parts, part)
    end
    
    if #parts >= 3 then
      local fname = table.concat(vim.list_slice(parts, 1, #parts-3), ":"):gsub("\\:", ":") -- Unescape & join
      local lnum = tonumber(parts[#parts-2])
      local col = tonumber(parts[#parts-1])
      local text = table.concat(vim.list_slice(parts, #parts-2+1), ":")
      
      if lnum and col then
        table.insert(qf, {
          filename = fname,
          lnum = lnum,
          col = col,
          text = text,
        })
      else
        print("⚠️  Warning: Invalid line " .. i .. " - skipped")
      end
    else
      print("⚠️  Warning: Invalid format line " .. i .. " - skipped")
    end
    
    ::continue::
  end

  -- Replace quickfix list
  vim.fn.setqflist(qf, "r")
  print("📜 Quickfix list loaded from " .. file .. " (" .. #qf .. " items)")
  
  -- Open quickfix window automatically
  if not vim.tbl_isempty(qf) then
    vim.cmd("copen")
  end
end

-- 🔥 KEYMAPS (Enhanced with descriptions)
vim.keymap.set("n", "<leader>qs", function()
  dump_quickfix("quickfix_dump.txt")
end, { desc = "💾 Save quickfix list to file" })

vim.keymap.set("n", "<leader>qc", function()
  dump_quickfix("clipboard")
end, { desc = "📋 Copy quickfix list to clipboard" })

vim.keymap.set("n", "<leader>ql", function()
  load_quickfix("quickfix_dump.txt")
end, { desc = "📂 Load quickfix list from file" })

-- 🎁 BONUS: Paste from clipboard directly
vim.keymap.set("n", "<leader>qp", function()
  local lines = vim.fn.split(vim.fn.getreg("+"), "\n")
  local qf = {}
  
  for i, line in ipairs(lines) do
    if line == "" then goto continue end
    
    local parts = {}
    for part in line:gmatch("[^:]+") do
      table.insert(parts, part)
    end
    
    if #parts >= 3 then
      local fname = table.concat(vim.list_slice(parts, 1, #parts-3), ":"):gsub("\\:", ":")
      local lnum = tonumber(parts[#parts-2])
      local col = tonumber(parts[#parts-1])
      local text = table.concat(vim.list_slice(parts, #parts-2+1), ":")
      
      if lnum and col then
        table.insert(qf, {filename = fname, lnum = lnum, col = col, text = text})
      end
    end
    ::continue::
  end
  
  vim.fn.setqflist(qf, "r")
  print("📋 Quickfix list pasted from clipboard (" .. #qf .. " items)")
  if not vim.tbl_isempty(qf) then vim.cmd("copen") end
end, { desc = "📋 Paste quickfix list from clipboard" })
