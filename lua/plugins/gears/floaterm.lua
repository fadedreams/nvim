return {
  "voldikss/vim-floaterm",
  lazy = false,
  config = function()
    -- Toggle floating terminal
    vim.keymap.set("n", "<c-q><c-t>", [[:FloatermToggle!<CR>]], { noremap = true, silent = true })
    
    -- Create new floating terminal
    -- vim.keymap.set("n", "<Space>it", [[:FloatermNew<CR>]], { noremap = true, silent = true })
    -- 
    -- -- Navigate to next terminal
    -- vim.keymap.set("n", "<Space>in", [[:FloatermNext<CR>]], { noremap = true, silent = true })
    -- 
    -- -- Navigate to previous terminal
    -- vim.keymap.set("n", "<Space>ip", [[:FloatermPrev<CR>]], { noremap = true, silent = true })
    -- 
    -- -- Kill current terminal
    -- vim.keymap.set("n", "<Space>ik", [[:FloatermKill<CR>]], { noremap = true, silent = true })
    -- 
    -- -- Open a specific command in floaterm (e.g., htop)
    -- vim.keymap.set("n", "<Space>ih", [[:FloatermNew htop<CR>]], { noremap = true, silent = true })
    -- 
    -- -- Toggle terminal in terminal mode
    -- vim.keymap.set("t", "<Space>i0", [[<C-\><C-n>:FloatermToggle!<CR>]], { noremap = true, silent = true })
    
    -- Exit terminal mode
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap = true, silent = true })

    -- Optional: Customize floaterm appearance
    vim.g.floaterm_width = 0.8
    vim.g.floaterm_height = 0.8
    vim.g.floaterm_title = 'Terminal $1/$2'
    vim.g.floaterm_borderchars = '─│─│╭╮╯╰'
  end,
}
