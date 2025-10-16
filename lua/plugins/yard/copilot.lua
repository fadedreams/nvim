local status = {} ---@type table<number, "ok" | "error" | "pending">

return {
    handlers = {
        didChangeStatus = function(err, res, ctx)
            if err then
                return
            end
            status[ctx.client_id] = res.kind ~= "Normal" and "error" or res.busy and "pending" or "ok"
            if res.status == "Error" then
                print("Please use `:LspCopilotSignIn` to sign in to Copilot")
            end
        end,
    },
}
-- return{
--   "zbirenbaum/copilot.lua",
--     cmd = "Copilot",
--     opts = {
--       filetypes = {
--         markdown = true,
--         sh = function()
--           if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
--             -- disable for .env files
--               return false
--               end
--               return true
--               end,
--       },
--       suggestion = {
--         enabled = true,
--         auto_trigger = true,
--         keymap = {
--           accept = "<M-a>",
--           next = "<M-]>",
--           prev = "<M-[>",
--           dismiss = "<A-r>",
--         },
--       },
--     },
-- }
