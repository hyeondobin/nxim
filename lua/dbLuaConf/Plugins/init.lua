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
		notify.dismiss({ silent = true })
	end, { desc = "dismiss notify popup and clear hlsearch" })
end

if nixCats("general.extra") then
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
end

require("lze").load({
	{ import = "dbLuaConf.Plugins.telescope" },
	{ import = "dbLuaConf.Plugins.treesitter" },
	{ import = "dbLuaConf.Plugins.completion" },
	{ import = "dbLuaConf.Plugins.rust" },
	{
		"undotree",
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
		"comment.nvim",
		event = "DeferredUIEnter",
		after = function(plugin)
			require("Comment").setup()
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
			require("nvim-surround").setup()
		end,
	},
	{
		"nvim-autopairs",
		event = "InsertEnter",
		after = function()
			require("nvim-autopairs").setup()
		end,
	},
	{
		"fidget.nvim",
		event = "DeferredUIEnter",
		after = function(plugin)
			require("fidget").setup({})
		end,
	},
	{
		"lualine.nvim",
		event = "DeferredUIEnter",
		after = function(plugin)
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
		"vim-sleuth",
		event = "DeferredUIEnter",
	},
	{
		"which-key.nvim",
		for_cat = "general.extra",
		event = "DeferredUIEnter",
		after = function(plugin)
			require("which-key").setup({})
			require("which-key").add({
				{ "<leader>g", group = "[g]it" },
				{ "<leader>g_", hidden = true },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>s_", hidden = true },
			})
		end,
	},
})
