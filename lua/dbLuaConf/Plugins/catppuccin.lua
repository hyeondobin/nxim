local flavor = "macchiato"
return {
	{
		"catppuccin/nvim",
		enabled = true,
		name = "catppuccin-nvim",
		priority = 1000,
		lazy = false,
		config = function()
			local color = require("catppuccin.palettes").get_palette(flavor)
			require("catppuccin").setup({
				flavour = flavor,
				background = {
					light = "latte",
					dark = "mocha",
				},
				-- transparent_background = not vim.g.neovide,
				transparent_background = false,
				term_colors = true,
				integrations = {
					aerial = true,
					alpha = true,
					blink_cmp = true,
					-- cmp = true,
					dashboard = true,
					flash = true,
					gitsigns = true,
					harpoon = true,
					headlines = true,
					illuminate = true,
					indent_blankline = {
						enabled = true,
						scope_color = "sapphire",
						colored_indent_levels = true,
					},
					mason = true,
					markdown = true,
					mini = true,
					native_lsp = {
						enabled = true,
						virtual_text = {
							errors = {},
							hints = {},
							warnings = {},
							information = {},
						},
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
					neotest = true,
					notify = true,
					noice = true,
					semantic_tokens = true,
					snacks = true,
					symbols_outline = true,
					telescope = true,
					treesitter = true,
					treesitter_context = true,
					which_key = true,
				},
				custom_highlights = {
					BlinkCmpMenuBorder = { fg = color.lavender },
					BlinkCmpDocBorder = { fg = color.lavender },
					-- Oil Vcs Status Config
					OilVcsStatusAdded = { fg = color.green },
					OilVcsStatusUpstreamAdded = { fg = color.green },

					-- Copied
					OilVcsStatusCopied = { fg = color.pink },
					OilVcsStatusUpstreamCopied = { fg = color.pink },

					-- Untracked
					OilVcsStatusUntracked = { fg = color.sky, background = "none" },
					OilVcsStatusUpstreamUntracked = { fg = color.sky, background = "none" },

					-- Modified
					OilVcsStatusModified = { fg = color.yellow },
					OilVcsStatusUpstreamModified = { fg = color.yellow },

					-- Deleted
					OilVcsStatusDeleted = { fg = color.maroon },
					OilVcsStatusUpstreamDeleted = { fg = color.maroon },

					-- Ignored
					OilVcsStatusIgnored = { fg = color.overlay0 },
					OilVcsStatusUpstreamIgnored = { fg = color.overlay0 },

					-- Renamed
					OilVcsStatusRenamed = { fg = color.mauve },
					OilVcsStatusUpstreamRenamed = { fg = color.mauve },
				},
			})

			vim.cmd.colorscheme("catppuccin")

			-- for _, group in ipairs(vim.fn.getcompletion("@lsp", "highlight")) do
			-- 	vim.api.nvim_set_hl(0, group, {})
			-- end
		end,
	},
}
