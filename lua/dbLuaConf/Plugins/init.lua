-- local ok, notify = pcall(require, "notify")
-- if ok then
-- 	notify.setup({
-- 		on_open = function(win)
-- 			vim.api.nvim_win_set_config(win, { focusable = false })
-- 		end,
-- 	})
-- 	vim.notify = notify
-- 	vim.keymap.set("n", "<Esc>", function()
-- 		notify.dismiss({ silent = true })
-- 	end, { desc = "dismiss notify popup and clear hlsearch" })
-- end

return {
	{
		"rcarriga/nvim-notify",
		lazy = false,
	},
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},
		config = function()
			vim.g.loaded_netrwPlugin = 1
			require("oil").setup({
				default_file_explorer = true,
				view_options = {
					show_hidden = true,
				},
				columns = {
					"icon",
					"permissions",
					"size",
					-- "mtime",
				},
				keymaps = {},
			})
			vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, desc = "Open Parent Directory" })
			vim.keymap.set("n", "<leader>-", "<cmd>Oil .<CR>", { noremap = true, desc = "Open nvim root directory" })
		end,
		-- Optional dependencies
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
		lazy = false,
	},
	{
		"mbbill/undotree",
		cmd = { "UndotreeToggle", "UndotreeHide", "UndotreeShow", "UndotreeFocus", "UndotreePersistUndo" },
		keys = {
			{ "<leader>U", "<cmd>UndotreeToggle<CR>", mode = { "n" }, desc = "Undo Tree" },
		},
		before = function(_)
			vim.g.undotree_WindowLayout = 1
			vim.g.undotree_SplitWidth = 40
		end,
	},
	{
		"numToStr/comment.nvim",
		event = "VeryLazy",
		config = function(plugin)
			require("Comment").setup()
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = "VeryLazy",
		config = function(plugin)
			require("ibl").setup()
		end,
	},
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		config = function(plugin)
			require("nvim-surround").setup()
		end,
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup()
		end,
	},
	{
		"fidget.nvim",
		event = "VeryLazy",
		config = function(plugin)
			require("fidget").setup({})
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function(plugin)
			require("lualine").setup({
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
						{ "filename", path = 1, status = true },
						"selectioncount",
					},
					lualine_x = {
						"encoding",
						"filetype",
					},
					lualine_y = {
						{
							"macro",
							fmt = function()
								local reg = vim.fn.reg_recording()
								if reg ~= "" then
									return "Recording @" .. reg
								end
								return nil
							end,
							draw_empty = false,
						},
						{
							"time",
							fmt = function()
								return os.date("%T")
							end,
						},
					},
				},
				tabline = {
					lualine_a = { "buffers" },
					lualine_z = { "tabs" },
				},
			})
		end,
	},
	{ import = "dbLuaConf.Plugins.git" },
	{
		"tpope/vim-sleuth",
		event = "VeryLazy",
	},
	{
		"folke/which-key.nvim",
		for_cat = "general.extra",
		event = "VeryLazy",
		config = function(plugin)
			require("which-key").setup({})
			require("which-key").add({
				{ "<leader>g", group = "[g]it" },
				{ "<leader>g_", hidden = true },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>s_", hidden = true },
			})
		end,
	},
	{
		import = "dbLuaConf.lint",
	},
	{ import = "dbLuaConf.format" },
}
