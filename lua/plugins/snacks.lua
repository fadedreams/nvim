local desc = Utils.plugin_keymap_desc("snacks")
local scratch_path = os.getenv("HOME") .. "/notes/scratch"

return {
    "folke/snacks.nvim",
    event = "VeryLazy",
    cmd = "Snacks",
    priority = 1000,
    lazy = false,
    init = function()
        local api = vim.api
        api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            group = api.nvim_create_augroup("zenedit_snacks", { clear = true }),
            callback = function()
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd
                -- Custom function to toggle warning diagnostics
                local warnings_enabled = true
                local function toggle_warning_diagnostics()
                    warnings_enabled = not warnings_enabled
                    -- Reset diagnostics to avoid conflicts
                    vim.diagnostic.config({ virtual_text = false, signs = false, underline = false })
                    if warnings_enabled then
                        -- Show only warning diagnostics
                        vim.diagnostic.config({
                            virtual_text = { severity = vim.diagnostic.severity.WARN },
                            signs = { severity = vim.diagnostic.severity.WARN },
                            underline = { severity = vim.diagnostic.severity.WARN },
                        })
                    else
                        -- Hide warning diagnostics, show errors and above
                        vim.diagnostic.config({
                            virtual_text = { severity = { min = vim.diagnostic.severity.ERROR } },
                            signs = { severity = { min = vim.diagnostic.severity.ERROR } },
                            underline = { severity = { min = vim.diagnostic.severity.ERROR } },
                        })
                    end
                    vim.notify("Warning diagnostics " .. (warnings_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
                end
                -- Custom function to toggle error diagnostics
                local errors_enabled = true
                local function toggle_error_diagnostics()
                    errors_enabled = not errors_enabled
                    -- Reset diagnostics to avoid conflicts
                    vim.diagnostic.config({ virtual_text = false, signs = false, underline = false })
                    if errors_enabled then
                        -- Show only error diagnostics
                        vim.diagnostic.config({
                            virtual_text = { severity = vim.diagnostic.severity.ERROR },
                            signs = { severity = vim.diagnostic.severity.ERROR },
                            underline = { severity = vim.diagnostic.severity.ERROR },
                        })
                    else
                        -- Hide error diagnostics, show warnings only
                        vim.diagnostic.config({
                            virtual_text = { severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.WARN } },
                            signs = { severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.WARN } },
                            underline = { severity = { min = vim.diagnostic.severity.WARN, max = vim.diagnostic.severity.WARN } },
                        })
                    end
                    vim.notify("Error diagnostics " .. (errors_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
                end
                -- Custom function to toggle info diagnostics
                local info_enabled = true
                local function toggle_info_diagnostics()
                    info_enabled = not info_enabled
                    -- Reset diagnostics to avoid conflicts
                    vim.diagnostic.config({ virtual_text = false, signs = false, underline = false })
                    if info_enabled then
                        vim.diagnostic.config({
                            virtual_text = { severity = vim.diagnostic.severity.INFO },
                            signs = { severity = vim.diagnostic.severity.INFO },
                            underline = { severity = vim.diagnostic.severity.INFO },
                        })
                    else
                        vim.diagnostic.config({
                            virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
                            signs = { severity = { min = vim.diagnostic.severity.WARN } },
                            underline = { severity = { min = vim.diagnostic.severity.WARN } },
                        })
                    end
                    vim.notify("Info diagnostics " .. (info_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
                end
                -- Custom function to toggle hint diagnostics
                local hints_enabled = true
                local function toggle_hint_diagnostics()
                    hints_enabled = not hints_enabled
                    -- Reset diagnostics to avoid conflicts
                    vim.diagnostic.config({ virtual_text = false, signs = false, underline = false })
                    if hints_enabled then
                        vim.diagnostic.config({
                            virtual_text = { severity = vim.diagnostic.severity.HINT },
                            signs = { severity = vim.diagnostic.severity.HINT },
                            underline = { severity = vim.diagnostic.severity.HINT },
                        })
                    else
                        vim.diagnostic.config({
                            virtual_text = { severity = { min = vim.diagnostic.severity.INFO } },
                            signs = { severity = { min = vim.diagnostic.severity.INFO } },
                            underline = { severity = { min = vim.diagnostic.severity.INFO } },
                        })
                    end
                    vim.notify("Hint diagnostics " .. (hints_enabled and "enabled" or "disabled"), vim.log.levels.INFO)
                end
                -- Custom function to reset diagnostics
                local function reset_diagnostics()
                    vim.diagnostic.config({
                        virtual_text = true,
                        signs = true,
                        underline = true,
                    })
                    warnings_enabled = true
                    errors_enabled = true
                    info_enabled = true
                    hints_enabled = true
                    vim.notify("All diagnostics restored", vim.log.levels.INFO)
                end
                -- Map the toggles
                vim.keymap.set("n", "<leader>iw", toggle_warning_diagnostics, { desc = "[T]oggle [W]arning [D]iagnostics" })
                vim.keymap.set("n", "<leader>ie", toggle_error_diagnostics, { desc = "[T]oggle [E]rror [D]iagnostics" })
                vim.keymap.set("n", "<leader>ii", toggle_info_diagnostics, { desc = "[T]oggle [I]nfo [D]iagnostics" })
                vim.keymap.set("n", "<leader>ih", toggle_hint_diagnostics, { desc = "[T]oggle [H]int [D]iagnostics" })
                vim.keymap.set("n", "<leader>ir", reset_diagnostics, { desc = "[R]eset [D]iagnostics" })
                -- Other toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>is")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>iw")
                Snacks.toggle.diagnostics():map("<leader>id")
                Snacks.toggle.indent():map("<leader>iI")
            end,
        })
    end,
    ---@type snacks.Config
    opts = {
        bigfile = {enabled = true, size = 1048576},
        quickfile = {enabled = true},
        gitbrowse = {enabled = true},
        dashboard = {enabled = false},
        notifier = {enabled = false, timeout = 7000},
        statuscolumn = {enabled = false},
        words = {enabled = false},
        lazygit = {enabled = false},
        image = {
            doc = {inline = false, float = false},
            convert = {notify = false},
        },
        picker = {
            finder = "explorer",
            hidden = true,
            supports_live = false,
            ui_select = false,
        },
        scratch = {
            root = scratch_path,
            win = {width = 150, height = 40, border = "single"},
        },
        input = { enabled = false }
    },
    keys = function()
        local snacks = require("snacks")
        return {
            {
                "<leader>.",
                function()
                    vim.ui.input({
                        prompt = "Enter scratch buffer title: ",
                        default = "",
                    }, function(t)
                        if not vim.fn.isdirectory(scratch_path) then
                            vim.fn.mkdir(scratch_path, "p")
                        end

                        if not t then
                            return
                        end

                        local title = t ~= "" and t:gsub("%s+", "_") or "Untitled"
                        snacks.scratch.open({
                            ft = "markdown",
                            name = title .. "_" .. os.date("%Y-%m-%d-%H-%M-%S"),
                            win = {
                                title = title,
                            },
                        })
                    end)
                end,
                desc = desc("[O]pen [S]cratch"),
            },
            {
                "<leader>S",
                -- function() snacks.scratch.select() end,
                function() Utils.fzf.scratch_select() end,
                desc = desc("[S]elect [S]cratch"),
            },
            {
                "<leader>cR",
                function() snacks.rename.rename_file() end,
                desc = desc("[R]ename [F]ile"),
            },
            {
                "<leader>gY",
                function() snacks.gitbrowse() end,
                desc = desc("[S]hare [G]it [O]pen"),
                mode = {"n", "v"},
            },
            {
                "<leader>gy",
                function()
                    snacks.gitbrowse.open({
                        open = function(url)
                            vim.fn.setreg("+", url)
                            vim.notify("Yanked url to clipboard")
                        end,
                    })
                end,
                desc = desc("[S]hare [G]it [L]ink"),
                mode = {"n", "v"},
            },
            {
                "<leader>oe",
                snacks.picker.explorer,
                desc = desc("[O]pen [E]xplorer"),
            },
            -- { "<leader>.h", function() snacks.notifier.show_history() end, desc = "[N]otification [H]istory" },
            -- { "<leader>ud", function() snacks.notifier.hide() end, desc = "[D]ismiss [A]ll [N]otifications" },
            { "<leader>b.", function() snacks.scratch() end, desc = "[N]ew [S]cratch" },
        }
    end,
}
