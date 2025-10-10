
--fzf
vim.keymap.set({"n", "v", "i"}, "<C-q><C-x>", function()
    require("fzf-lua").complete_path()
end, {silent = true, desc = "Fuzzy complete path"})

--browser
vim.keymap.set("n", "<leader>ub", function()
    vim.ui.input({prompt = "Search: "}, function(input)
        if input then
            Utils.browse.query_browser(input)
        end
    end)
end, {desc = "Browse on the web"})


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
	print("Swap files deleted.")
end

-- Uses normal mode (n), is non-recursive (noremap), and silent
vim.keymap.set("n", "<leader>ds", delete_swap_files, {
	noremap = true,
	silent = true,
	desc = "[D]elete [S]wap", -- Description for which-key
})
