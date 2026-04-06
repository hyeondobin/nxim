return {
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		ft = { "org" },
		config = function()
			require("orgmode").setup({
				org_agenda_files = "~/Dropbox/org/**/*",
				org_default_notes_file = "~/Dropbox/org/refile.org",
			})

			-- Experimental LSP support
			vim.lsp.enable("org")
		end,
	},
	{
		"chipsenkbeil/org-roam.nvim",
		dependencies = {
			{
				"nvim-orgmode/orgmode",
			},
		},
		config = function()
			require("org-roam").setup({
				directory = "~/Dropbox/org/roam",
			})
		end,
	},
}
