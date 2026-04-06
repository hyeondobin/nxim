return {
	"nicolasgb/jj.nvim",
	keys = {
		{
			"<leader>j",
			"<cmd>J<cr>",
			desc = "[J]ujutsu",
		},
	},
	config = function()
		require("jj").setup({})
	end,
}
