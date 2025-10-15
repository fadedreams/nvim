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
vim.keymap.set("n", "<leader>ll", toggle_lsp, { noremap = true, silent = false, desc = "Toggle LSP" })

-- vim.keymap.set('n', '<leader>ut', '<cmd>silent !tmux neww tmux-sessionizer<CR>', { noremap = true, silent = true })
-- vim.keymap.set('n', '<leader>ut', ':silent !tmux -b ~/.local/bin/tmux-sessionizer<CR>', { noremap = true, silent = true })
vim.keymap.set("n", "<c-q><c-s>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<leader>9", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
-- vim.keymap.set("n", "<leader>8", "<cmd>silent !tmux neww tmux-sessionizer -s 1<CR>")
-- vim.keymap.set("n", "<leader>7", "<cmd>silent !tmux neww tmux-sessionizer -s 2<CR>")
-- vim.keymap.set("n", "<leader>6", "<cmd>silent !tmux neww tmux-sessionizer -s 3<CR>")
--fzf
vim.keymap.set({"n", "v", "i"}, "<C-q><C-x>", function()
    require("fzf-lua").complete_path()
end, {silent = true, desc = "Fuzzy complete path"})

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
