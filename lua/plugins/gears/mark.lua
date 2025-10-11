return {
    'MeanderingProgrammer/render-markdown.nvim',
    event = "VeryLazy",  -- Optional: Lazy-load on events to improve startup time
    dependencies = { 'nvim-treesitter/nvim-treesitter', }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      -- Add keymap for toggling RenderMarkdown
      vim.keymap.set("n", "<leader>um", ":RenderMarkdown toggle<CR>", { buffer = true, desc = "[U]til [M]arkview" }),
    },
}
