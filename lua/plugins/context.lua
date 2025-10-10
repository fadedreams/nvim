return {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable = true, -- Enable the plugin by default
      multiwindow = false, -- Disable multiwindow support (optional)
      max_lines = 0, -- No limit on context lines (default)
      min_window_height = 0, -- No minimum window height (default)
      line_numbers = true, -- Show line numbers in context (default)
      multiline_threshold = 20, -- Max lines for a single context (default)
      trim_scope = "outer", -- Discard outer lines if max_lines exceeded (default)
      mode = "cursor", -- Update context based on cursor position (default)
      separator = nil, -- No separator by default
      zindex = 20, -- Z-index for context window (default)
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)
    --TODO: change k
      vim.keymap.set("n", "<c-k>", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { silent = true, desc = "Go to parent context" })
      vim.keymap.set("i", "<c-k>", function()
        require("treesitter-context").go_to_context(vim.v.count1)
      end, { silent = true, desc = "Go to parent context" })
    end,
}
