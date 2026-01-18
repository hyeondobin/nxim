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
				-- go_in = "e",
				-- go_in_plus = "E",
				-- go_out = "p",
				-- go_out_plus = "P",
			},
			options = {
				use_as_default_explorer = false,
			},
		})
		vim.api.nvim_create_autocmd({ "User" }, {
			pattern = { "MiniFilesWindowOpen" },
			callback = function(args)
				-- vim.keymap.set("n", "h", "j", { buffer = args.data.buf_id })
				-- vim.keymap.set("n", "a", "k", { buffer = args.data.buf_id })
			end,
		})
		nmap("<leader>e", function()
			require("mini.files").open()
		end, "Open mini.files [E]xplorer")

		-- surround
		require("mini.surround").setup({
			mappings = {
				add = "gsa",
				delete = "gsd",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				replace = "gsr",
				update_n_lines = "gsn",

				suffix_last = "l",
				suffix_next = "n",
			},
		})

		-- buf remove
		require("mini.bufremove").setup()
		nmap("<leader>bd", function()
			local bd = require("mini.bufremove").delete
			if vim.bo.modified then
				local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
				if choice == 1 then
					vim.cmd.write()
					bd(0)
				elseif choice == 2 then
					bd(0, true)
				end
			else
				bd(0)
			end
		end, "Delete Buffer")
		nmap("<leader>Bd", function()
			require("mini.bufremove").delete(0, true)
		end, "Force delete buffer")
	end,
}
