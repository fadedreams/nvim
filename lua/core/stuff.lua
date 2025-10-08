
-- TODO: Opens fugitive 
vim.keymap.set("n", "<leader>gf", ":top Git<CR>", {desc = "Fugitive: Open git console"})

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
-- keyset("n", "<leader>st", function()
--     vim.cmd.new()
--     vim.cmd.wincmd("J") -- Move to the window below
--     vim.api.nvim_win_set_height(0, 12)
--     vim.wo.winfixheight = true
--     vim.cmd.term()
-- end, {desc = "Open terminal below"})
-- keyset("t", "<C-t>", "<C-\\><C-n>", {desc = "Exit terminal mode"})
