return {
  {
    "Mofiqul/vscode.nvim",
    lazy = true, -- Load immediately to ensure theme is available
    event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
    -- priority = 1000, -- High priority to ensure theme loads first
    config = function()
      require("vscode").setup({
        -- Optional customizations; adjust as needed
        transparent = false, -- Set to true if you want transparency
        italic_comments = false,
        disable_nvimtree_bg = true,
        -- Add any color/group overrides here if desired
      })
    end,
  },
}
