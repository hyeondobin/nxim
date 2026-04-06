return {
	{
		"nvim-orgmode/orgmode",
		event = "VeryLazy",
		ft = { "org" },
		config = function()
			require("orgmode").setup({
				org_agenda_files = "~/Dropbox/org/**/*",
				org_default_notes_file = "~/Dropbox/org/refile.org",
				mappings = {
					-- prefix = "<localleader>o",
					org = {
						org_edit_special = "<localleader>e",
						org_babel_tangle = "<localleader>bt",
					},
					edit_src = {
						org_edit_src_save_exit = "<localleader>s",
						org_edit_src_abort = "<localleader>k",
						org_edit_src_save = "<localleader>w",
					},
				},
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
