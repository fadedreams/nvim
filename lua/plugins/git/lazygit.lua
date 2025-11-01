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
  end,
}
