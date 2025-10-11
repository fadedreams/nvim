-- Organize go imports (https://github.com/harrisoncramer/nvim/blob/main/lua/lsp/servers/gopls.lua)
-- local function goimports()
--   local params = vim.lsp.util.make_range_params()
--   params.context = {only = {'source.organizeImports'}}
--   local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
--   for cid, res in pairs(result or {}) do
--     for _, r in pairs(res.result or {}) do
--       if r.edit then
--         local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
--         vim.lsp.util.apply_workspace_edit(r.edit, enc)
--       end
--     end
--   end
--   vim.lsp.buf.format({async = false})
-- end
--
-- vim.api.nvim_create_autocmd('BufWritePre', {
--   pattern = '*.go',
--   callback = function()
--     goimports()
--   end,
--   desc = 'Run goimports on save in Golang files',
-- })


-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
-- --original g
return {
    settings = {
        gopls = {
            analyses = {
                fillstruct = false,
            },
            -- staticcheck = true, -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md#staticcheck-bool
            completeFunctionCalls = false,
            gofumpt = true,
            completeUnimported = true,
        },
    },
}

-- return {
-- 	settings = {
-- 		gopls = {
-- 			analyses = {
-- 				fillstruct = false,
-- 				unusedparams = true, -- Enable unused parameters analysis
-- 				shadow = true, -- Enable shadow variable analysis
-- 				unusedwrite = true, -- Enable unused write analysis
-- 				useany = true, -- Enable use of interface{} analysis
-- 			},
-- 			staticcheck = true, -- Enable staticcheck for additional diagnostics
-- 			completeFunctionCalls = true, -- Complete function calls with parameter names (changed from false to true for more features)
-- 			gofumpt = true,
-- 			completeUnimported = true,
-- 			usePlaceholders = true, -- Use placeholders in completion snippets
-- 			matcher = "Fuzzy", -- Use fuzzy matching for completions
-- 			experimentalPostfixCompletions = true, -- Enable postfix completions
-- 			hints = { -- Enable inlay hints
-- 				assignVariableTypes = true,
-- 				compositeLiteralFields = true,
-- 				compositeLiteralTypes = true,
-- 				constantValues = true,
-- 				functionTypeParameters = true,
-- 				parameterNames = true,
-- 				rangeVariableTypes = true,
-- 			},
-- 			codelens = { -- Enable various code lenses
-- 				generate = true,
-- 				gc_details = true,
-- 				regenerate_cgo = true,
-- 				tidy = true,
-- 				upgrade_dependency = true,
-- 				vendor = true,
-- 			},
-- 			diagnosticsDelay = "500ms", -- Delay diagnostics to reduce CPU usage
-- 		},
-- 	},
-- }

