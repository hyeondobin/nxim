return {
	"nvim-mini/mini.nvim",
	name = "mini.nvim",
	config = function()
		local nmap = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { silent = true, desc = desc })
		end

		-- notify
		require("mini.notify").setup()
		require("which-key").add({ "<leader>m", group = "Mini" })
		nmap("<leader>mnh", function()
			require("mini.notify").show_history()
		end, "show [N]otification [H]istory")

		-- ai
		require("mini.ai").setup()

		-- files
		require("mini.files").setup({
			mappings = {
				go_in = "e",
				go_in_plus = "E",
				go_out = "p",
				go_out_plus = "P",
			},
			options = {
				use_as_default_explorer = false,
			},
		})
		vim.api.nvim_create_autocmd({ "User" }, {
			pattern = { "MiniFilesWindowOpen" },
			callback = function(args)
				vim.keymap.set("n", "h", "j", { buffer = args.data.buf_id })
				vim.keymap.set("n", "a", "k", { buffer = args.data.buf_id })
			end,
		})
		nmap("<leader>e", function()
			require("mini.files").open()
		end, "Open mini.files [E]xplorer")
	end,
}
