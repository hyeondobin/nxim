local colorschemeName = "catppuccin-macchiato"
vim.cmd.colorscheme(colorschemeName)

local ok, notify = pcall(require, "notify")
if ok then
    notify.setup({
        on_open = function(win)
            vim.api.nvim_win_set_config(win, { focusable = false })
        end,
    })
    vim.notify = notify
    vim.keymap.set("n", "<Esc>", function()
        notify.dismiss({ silent = true, })
    end, { desc = "dismiss notify popup and clear hlsearch" })
end

if nixCats('general.extra') then
    vim.g.loaded_netrwPlugin = 1
    require("oil").setup({
        default_file_explorer = true,
        view_options = {
            show_hidden = true
        },
        columns = {
            "icon",
            "permissions",
            "size",
            -- "mtime",
        },
        keymaps = {

        }
    })
    vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, desc = 'Open Parent Directory' })
    vim.keymap.set("n", "<leader>-", "<cmd>Oil .<CR>", { noremap = true, desc = 'Open nvim root directory' })
end

require('lze').load {
    -- { import = "dbLuaConf.Plugins.telescope", },
    { import = "dbLuaConf.Plugins.treesitter", },
    -- { import = "dbLuaConf.Plugins.completion", },
    {
        "undotree",
        cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeShow", "UndotreeFocus", "UndotreePersistUndo", },
        keys = {
            { "<leader>U", "<cmd>UndotreeToggle<CR>", mode = {"n"}, desc = "Undo Tree" },
        },
        before = function(_)
            vim.g.undotree_WindowLayout = 1
            vim.g.undotree_SplitWidth = 40
        end,
    },
    {
        "comment.nvim",
        event = "DeferredUIEnter",
        after = function(plugin)
            require('Comment').setup()
        end,
    },
    {
        "indent-blankline.nvim",
        event = "DeferredUIEnter",
        after = function(plugin)
            require("ibl").setup()
        end,
    },
    {
        "nvim-surround",
        event = "DeferredUIEnter",
        after = function(plugin)
            require('nvim-surround').setup()
        end,
    },
    {
        "fidget.nvim",
        event = "DeferredUIEnter",
        after = function(plugin)
            require('fidget').setup({})
        end,
    },
    {
        "lualine.nvim",
        event = "DeferredUIEnter",
        after = function(plugin)
            require('lualine').setup({
                options = {
                    theme = colorschemeName,
                    globalstatus = true,
                },
                sections = {
                    lualine_b = {
                        "branch",
                        "diff",
                        "diagnostics",
                    },
                    lualine_c = {
                        { "filename", path = 1, status = true, },
                        "selectioncount",
                    },
                    lualine_x = {
                        "encoding"
                        ,"filetype"
                    } , 
                    lualine_y = {
                        {
                            "macro"
                            , fmt = function()
                                local reg = vim.fn.reg_recording()
                                if reg ~= "" then 
                                    return "Recording @" .. reg
                                end
                                return nil
                            end,
                            draw_empty = false,
                        } ,
                        {
                            "time",
                            fmt = function()
                                return os.date("%T")
                            end,
                        },
                    },
                },
                tabline = {
                    lualine_a = { 'buffers' },
                    lualine_z = { 'tabs' }
                },
            })
        end,
    },
    {
        "gitsigns.nvim",
        event = "DeferredUIEnter",
        after = function(plugin)
            require("gitsigns").setup({
                signs = {
                    add = { text = '+'},
                    change = { text = '~' },
                    delete = { text = '_' },
                    topdelete = { text = '‾' },
                    changedelete = { text = '~' },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map({ 'n', 'v' }, ']c', function()
                        if vim.wo.diff then
                            return ']c'
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Jump to next hunk" })

                    map({ 'n','v'},'[c',function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Jump to previous hunk" })


                    -- Actions
                    -- visual mode
                    map("v", "<leader>hs", function()
                        gs.state_hunk { vim.fn.line ".", vim.fn.line "v" }
                    end, { desc = "stage git hunk" })
                    map("v", "<leader>hr", function()
                        gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
                    end, { desc = "reset git hunk" })
                    -- normal mode
                    map("n", "<leader>gs", gs.stage_hunk, { desc = "git stage hunk" })
                    map("n", "<leader>gr", gs.reset_hunk, { desc = "git reset hunk" })
                    map("n", "<leader>gS", gs.stage_buffer, { desc = "git Stage buffer" })
                    map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "undo stage hunk" })
                    map("n", "<leader>gR", gs.reset_buffer, { desc = "git Reset buffer" })
                    map("n", "<leader>gp", gs.preview_hunk, { desc = "preview git hunk" })
                    map("n", "<leader>gb", function()
                        gs.blame_line { full = false }
                    end, { desc = "git blame line" })
                    map("n", "<leader>gd", gs.diffthis, { desc = "git diff against index" })
                    map("n", "<leader>gD", function()
                        gs.diffthis "~"
                    end, { desc = "git diff against last commit" })
                    
                    -- Toggles 
                    map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "toggle git blame line" })
                    map("n", "<leader>gtd", gs.toggle_deleted, { desc = "toggle git show deleted" })

                    -- Text object
                    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "select git hunk" })
                end
                })
                vim.cmd([[hi GitSignsAdd guifg=#04de21]])
                vim.cmd([[hi GitSignsChange guifg=#83fce6]])
                vim.cmd([[hi GitSignsDelete guifg=#fa2525]])
            end
        },
    }
