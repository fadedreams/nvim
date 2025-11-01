return {
  {
    "aaron-p1/match-visual.nvim",
    event = "VeryLazy",  -- Load on VeryLazy event to avoid startup impact
    opts = {
      -- Minimum length of text to match (default: 1)
      min_length = 1,
      -- Highlight group to use (default: "Visual"; you can override "VisualMatch" manually in your colorscheme)
      hl_group = "Visual",
    },
  },
}
