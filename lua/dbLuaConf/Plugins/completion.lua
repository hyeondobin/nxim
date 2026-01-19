return {
	{
		"saghen/blink.cmp",
		lazy = false,
		version = "1.*",
		build = function()
			if require("nixCatsUtils").isNixCats then
				return "nix run .#build-plugin"
			else
				return false
			end
		end,
		dependencies = {
			"L3MON4D3/luasnip",
			"hrsh7th/cmp-cmdline",
			"xzbdmw/colorful-menu.nvim",
			"saghen/blink.compat",
		},
		-- hjkl; or phaei
		config = function()
			require("blink.cmp").setup({
				keymap = {
					preset = "default",
					["<C-tab>"] = { "accept", "fallback" },
					-- qwerty
					["<C-j>"] = { "snippet_forward" },
					["<C-k>"] = { "snippet_backward" },
					["<C-l>"] = { "select_and_accept" },
					-- yeah
					["<C-h>"] = { "snippet_forward" },
					["<C-a>"] = { "snippet_backward" },

					["<C-,>"] = {
						"show_signature",
						"fallback",
					},
				},
				cmdline = {
					enabled = true,
					completion = {
						menu = {
							auto_show = true,
						},
					},
					sources = function()
						local type = vim.fn.getcmdtype()
						if type == "/" or type == "?" then
							return { "buffer" }
						end
						if type == ":" or type == "@" then
							return { "cmdline", "cmp_cmdline" }
						end
						return {}
					end,
				},
				fuzzy = {
					sorts = {
						"exact",
						"score",
						"sort_text",
					},
				},
				signature = {
					enabled = true,
					window = {
						show_documentation = true,
					},
				},
				completion = {
					menu = {
						draw = {
							treesitter = { "lsp" },
							components = {
								label = {
									text = function(ctx)
										return require("colorful-menu").blink_components_text(ctx)
									end,
									highlight = function(ctx)
										return require("colorful-menu").blink_components_highlight(ctx)
									end,
								},
							},
						},
					},
					documentation = {
						auto_show = true,
					},
				},
				snippets = {
					preset = "luasnip",
					active = function(filter)
						local snippet = require("luasnip")
						local blink = require("blink.cmp")
						if snippet.in_snippet() and not blink.is_visible() then
							return true
						else
							if not snippet.in_snippet() and vim.fn.mode() == "n" then
								snippet.unlink_current()
							end
							return false
						end
					end,
				},
				sources = {
					default = { "lsp", "path", "snippets", "buffer", "omni" },
					providers = {
						path = {
							score_offset = 50,
						},
						lsp = {
							score_offset = 40,
						},
						snippets = {
							score_offset = 40,
						},
						cmp_cmdline = {
							name = "cmp_cmdline",
							module = "blink.compat.source",
							score_offset = -100,
							opts = {
								cmp_name = "cmdline",
							},
						},
					},
				},
			})
		end,
	},
	{
		"L3MON4D3/luasnip",
		config = function()
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_lua").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })
			luasnip.config.setup({})

			local ls = require("luasnip")
			vim.keymap.set({ "i", "s" }, "<M-n>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end)
		end,
	},
}
