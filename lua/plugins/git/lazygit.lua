return {
  "kdheepak/lazygit.nvim",
  cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = {
    { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit: Open" },
  },
  config = function()
    require("lazygit").setup()

    -- Auto-remap <Esc> in lazygit terminal buffers
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*lazygit*",
      callback = function()
        -- Only apply in terminal buffers started by lazygit
        if vim.bo.filetype == "lazygit" then
          local opts = { buffer = true, silent = true }

          -- CRITICAL: Send literal <Esc> to the terminal job
          vim.keymap.set("t", "<Esc>", [[<C-\><C-n>:lua vim.api.nvim_feedkeys('i', 'n', false)<CR><Esc>]], opts)
          
          -- Better: Use `vim.api.nvim_feedkeys` with 't' mode to send raw input
          vim.keymap.set("t", "<Esc>", function()
            -- Stay in terminal-insert mode and send <Esc> to lazygit
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "t", false)
          end, opts)

          -- Optional: Quit lazygit cleanly with 'q'
          vim.keymap.set("t", "q", "<Cmd>close<CR>", opts)
        end
      end,
    })
  end,
}
