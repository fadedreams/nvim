return{
  'nvim-treesitter/nvim-treesitter-context',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    require('treesitter-context').setup({
      enable = true,
      max_lines = 0,  -- No limit on lines
      trim_scope = 'outer',  -- Trim from outer context
      mode = 'cursor',  -- Use cursor line for context
    })
      vim.keymap.set("n", "<c-k>", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { silent = true, desc = "Go to parent context" })
      vim.keymap.set("i", "<c-k>", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { silent = true, desc = "Go to parent context" })
  end,
}
