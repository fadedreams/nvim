
vim.api.nvim_set_hl(0, "lazygitborder", {link = "floatborder"})
--vim.api.nvim_set_hl(0, "Normal", {bg = "NONE"})
vim.api.nvim_set_hl(0, "StatusLine", {bg = "NONE"})
vim.api.nvim_set_hl(0, "StatusLineNC", {bg = "NONE"})

-- Split window
vim.keymap.set("n", "<leader>ss", ":split<Return><C-w>w", {desc = "Split window horizontally"}) -- Horizontal
vim.keymap.set("n", "<leader>sv", ":vsplit<Return><C-w>w", {desc = "Split window vertically"})  -- Vertical


-- Resize splits
vim.keymap.set("n", "<M-Left>", "<C-w>5>", {desc = "Resize window (left)"})
vim.keymap.set("n", "<M-Right>", "<C-w>5<", {desc = "Resize window (right)"})
vim.keymap.set("n", "<M-Down>", "<C-w>5-", {desc = "Resize window (down)"})
vim.keymap.set("n", "<M-Up>", "<C-w>5+", {desc = "Resize window (up)"})
