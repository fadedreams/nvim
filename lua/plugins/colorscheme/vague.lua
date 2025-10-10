return {
    "vague2k/vague.nvim",
    --lazy = true,
    event = "VeryLazy", 
    ---@type VagueColorscheme.Config
    opts = {
        italic = false,
        on_highlights = function(highlights, colors)
            highlights.StatusLine = {bg = colors.bg}
        end,
    },
}
