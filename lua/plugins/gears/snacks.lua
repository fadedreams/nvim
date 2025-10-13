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
                -- Other toggle mappings
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>is")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>wW")
                Snacks.toggle.diagnostics():map("<leader>id")
                Snacks.toggle.indent():map("<leader>ii")
            end,
        })
    end,
    ---@type snacks.Config
    opts = {
        -- bigfile = {enabled = true, size = 1048576},
        bigfile = {enabled = true, size = 2097152},
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
                "<leader>>",
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
            -- {
            --     "<leader>ue",
            --     snacks.picker.explorer,
            --     desc = desc("[U]til [T]ree"),
            -- },
            { "<leader>.", function() snacks.scratch() end, desc = "[N]ew [S]cratch" },
        }
    end,
}
