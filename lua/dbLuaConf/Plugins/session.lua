return {
	{
		"folke/persistence.nvim",
		event = "VeryLazy",
		keys = {
			{
				"<leader>xl",
				function()
					require("persistence").load()
				end,
				desc = "Load Session",
			},
			{
				"<leader>xs",
				function()
					require("persistence").select()
				end,
				desc = "Select Session",
			},
			{
				"<leader>x.",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Load Last Session",
			},
			{
				"<leader>xd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't save Session",
			},
		},
		config = function()
			require("persistence").setup()
			local wk = require("which-key")
			wk.add({ "<leader>x", group = "Session:" })
		end,
	},
}
