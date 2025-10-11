return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = { 'VeryLazy', 'BufReadPost', 'BufNewFile' },
    config = function()
      -- Initialize nvim-ufo
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          -- Use lsp as main, indent as fallback
          return {'lsp', 'indent'}
        end
      })
      -- Keymaps
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
    end,
  },
}
