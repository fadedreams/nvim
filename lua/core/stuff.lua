vim.api.nvim_set_keymap('n', '<leader>gp', '', {
  noremap = true,
  silent = true,
  callback = function()
    local folder = vim.fn.input('Enter folder path for git files: ')
    if folder == '' then return end

    -- Get unique changed files from git log
    local handle = io.popen('git log --name-only --pretty=format: -- ' .. folder .. ' | sort -u')
    local result = handle:read("*a")
    handle:close()

    local files = {}
    for line in result:gmatch("[^\r\n]+") do
      if line ~= "" then
        table.insert(files, line)
      end
    end

    if #files == 0 then
      print("No changed files found in folder: " .. folder)
      return
    end

    -- Populate quickfix list with just the basename as text
    local qf_list = {}
    for _, f in ipairs(files) do
      table.insert(qf_list, {
        filename = f,           -- full path for opening
        lnum = 1,
        col = 1,
        text = vim.fn.fnamemodify(f, ':t')  -- only filename
      })
    end

    vim.fn.setqflist(qf_list, 'r')
    vim.cmd('copen')
  end,
  desc = "Git changed files → Quickfix (basename)"
})

vim.api.nvim_set_keymap('n', '<leader>gl', '', {
  noremap = true,
  silent = true,
  callback = function()
    -- Prompt the user for a folder path
    local folder = vim.fn.input('Enter folder path for git log: ')
    if folder == '' then return end

    -- Run git log and capture output
    local handle = io.popen('git log -- ' .. folder)
    local result = handle:read("*a")
    handle:close()

    -- Open a new buffer
    vim.cmd('new')
    local buf = vim.api.nvim_get_current_buf()

    -- Set buffer options
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)

    -- Put git log output in buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(result, '\n'))
  end,
  desc = "Git log for folder → new buffer"
})

vim.keymap.set('n', '<leader>gv', ':silent Git commit -v<CR>', { noremap = true, silent = true }) --TODO: 
-- Function to toggle LSP with messages
local function toggle_lsp()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

  if #clients > 0 then
    vim.cmd("LspStop")
    vim.notify("LSP stopped", vim.log.levels.INFO)
  else
    vim.cmd("LspStart")
    vim.notify("LSP started", vim.log.levels.INFO)
  end
end

-- Map leader+ll to toggle LSP
vim.keymap.set("n", "<leader>tl", toggle_lsp, { noremap = true, silent = false, desc = "Toggle LSP" })

-- vim.keymap.set('n', '<leader>ut', '<cmd>silent !tmux neww tmux-sessionizer<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>ut', ':silent !tmux -b ~/.local/bin/tmux-sessionizer<CR>', { noremap = true, silent = true })
-- vim.keymap.set("n", "<c-q><c-u>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<leader>9", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
-- vim.keymap.set("n", "<leader>8", "<cmd>silent !tmux neww tmux-sessionizer -s 1<CR>")
-- vim.keymap.set("n", "<leader>7", "<cmd>silent !tmux neww tmux-sessionizer -s 2<CR>")
-- vim.keymap.set("n", "<leader>6", "<cmd>silent !tmux neww tmux-sessionizer -s 3<CR>")

-- vim.keymap.set('n', '<leader>df', function()
--   local file = vim.fn.input('Enter file to diff: ', 'file2.txt')
--   vim.cmd('vert diffsplit ' .. vim.fn.fnameescape(file))
-- end, { desc = 'Vertical diff split with input file' })

--browser
vim.keymap.set("n", "<leader>ub", function()
    vim.ui.input({prompt = "Search: "}, function(input)
        if input then
            Utils.browse.query_browser(input)
        end
    end)
end, {desc = "[B]rowse web"})


-- Open terminal below
-- keyset("n", "<leader>ot", function()
--     vim.cmd.new()
--     vim.cmd.wincmd("J") -- Move to the window below
--     vim.api.nvim_win_set_height(0, 12)
--     vim.wo.winfixheight = true
--     vim.cmd.term()
-- end, {desc = "[O]pen [T]erminal"})
-- keyset("t", "<C-t>", "<C-\\><C-n>", {desc = "Exit terminal mode"})

vim.keymap.set(
    "n",
    "<Leader>ue",
    ":silent !open %:p:h<CR>",
    { noremap = true, silent = true, desc = "[U]til [E]xplorer" }
)


-- Save current session to ./session.vim
-- vim.keymap.set("n", "<leader>ss", ":mksession! ./session.vim<CR>", {
-- 	noremap = true,
-- 	silent = true,
-- 	desc = "[S]ave [S]ession", -- Shows in which-key
-- })

-- Load session from the current working directory
-- vim.keymap.set("n", "<leader>ls", ":source ./session.vim<CR>", { noremap = true, silent = true, desc = "[L]oad [S]ession" })

-- delete swap files
local function delete_swap_files()
	local cmd = "rm -rf ~/.local/state/nvim/swap/*"
	vim.fn.system(cmd)
	-- print("Swap files deleted.")
  vim.notify("Swap files deleted.")
end

-- Uses normal mode (n), is non-recursive (noremap), and silent
vim.keymap.set("n", "<leader>ud", delete_swap_files, {
	noremap = true,
	silent = true,
	desc = "[D]elete [S]wap", -- Description for which-key
})
