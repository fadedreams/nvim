vim.keymap.set("n", "<Leader>bb", "<C-^>", { noremap = true, silent = true, desc = "Toggle last buffer" })
-- vim.keymap.set("n", "<leader>bdo", ":%bd|e#|bd#<CR>", { noremap = true, silent = true, desc = "delete other buffers" })
-- vim.keymap.set("n", "<leader>bda", ":%bd<CR>", { noremap = true, silent = true, desc = "delete all buffers" })
vim.keymap.set('n', '<c-h>', '<cmd>bd<CR>', { desc = 'kill' })
vim.keymap.set("i", "<c-h>", "<Esc>:bdelete<CR>", { desc = 'kill' })
vim.keymap.set('n', '<leader>bd', '<cmd>bd<CR>', { desc = 'Close buffer and window' })

vim.keymap.set('n', '<leader>bn', '<cmd>ene<CR>', { desc = 'New buffer and window' })
vim.keymap.set('n', '<leader>bv', '<cmd>vnew<CR>', { desc = 'New buffer in vsplit' })

vim.keymap.set('n', '[b', '<cmd>:bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', ']b', '<cmd>:bnext<CR>', { desc = 'Next buffer' })

-- vim.keymap.set("n", "<c-k>", ":bnext<CR>", { noremap = true, silent = true })
-- vim.keymap.set("n", "<c-j>", ":bprevious<CR>", { noremap = true, silent = true })


-- vim.keymap.set("n", "<c-l>", "<cmd>b#<cr>", { noremap = true, silent = true }) --Move to last buffer

-- vim.keymap.set("n", "<leader>bn", "<cmd>ene <bar> startinsert <cr>", { noremap = true, silent = true, desc="[B]uffer [N]ew" })
-- { "n", "<leader>fn", "<cmd>ene <bar> startinsert <cr>", "[B]uffer [N]ew" },
-- vim.keymap.set("n", "<leader>bn", ":enew<CR>", { noremap = true, silent = true })

-- vim.keymap.set("i", "<c-k>", "<Esc>:bnext<CR>", { noremap = true, silent = true })
-- vim.keymap.set("i", "<c-j>", "<Esc>:bprevious<CR>", { noremap = true, silent = true })

-- Store the last closed buffer's file path
vim.api.nvim_create_autocmd("BufDelete", {
    callback = function(event)
        local bufname = vim.api.nvim_buf_get_name(event.buf)
        if bufname ~= "" then -- Ensure the buffer has a valid file path
            vim.g.last_closed_buffer = bufname
        end
    end,
})

-- Function to reopen the last closed buffer
function ReopenLastBuffer()
    if vim.g.last_closed_buffer and vim.fn.filereadable(vim.g.last_closed_buffer) == 1 then
        vim.cmd("badd " .. vim.fn.fnameescape(vim.g.last_closed_buffer))
        vim.cmd("b " .. vim.fn.fnameescape(vim.g.last_closed_buffer))
    else
        print("No recently closed buffer or file does not exist")
    end
end

vim.keymap.set("n", "<c-'>", ":lua ReopenLastBuffer()<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>bx", ":!chmod +x %<CR>", {desc = "Make file executable"})


-- keyset('n', '-', function()
--   local cur_file = vim.fn.expand('%:t')
--   vim.cmd.Ex()
--   vim.fn.search('^' .. cur_file .. '$')
-- end, {desc = 'Open Netrw'})
-- keyset('n', '<C-c>', vim.cmd.Rex, {desc = 'Open last visited file'})
