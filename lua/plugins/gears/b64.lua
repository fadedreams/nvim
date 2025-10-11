return {
  {
    'taybart/b64.nvim',
    lazy = true, -- Enable lazy loading
    keys = {
      -- Define keymaps that trigger plugin loading
      { '<leader>ue', ':<C-u>lua require("b64").encode()<CR>', mode = 'v', desc = 'Base64 Encode' },
      { '<leader>ud', ':<C-u>lua require("b64").decode()<CR>', mode = 'v', desc = 'Base64 Decode' },
    },
  },
}
