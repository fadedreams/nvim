
--fzf
vim.keymap.set({"n", "v", "i"}, "<C-y>", function()
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
