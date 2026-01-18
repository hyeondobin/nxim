return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = require("nixCatsUtils").lazyAdd(":TSUpdate"),
		lazy = false,
		branch = "main",
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects", name = "treesitter-textobjects" },
			"nvim-treesitter/nvim-treesitter-context",
		},
		config = function(_, opts)
			---@param buf integer
			---@param language string
			local function treesitter_try_attach(buf, language)
				-- check if parser exists and load it
				if not vim.treesitter.language.add(language) then
					return false
				end
				vim.treesitter.start(buf, language)
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
				return true
			end

			local installable_parsers = require("nvim-treesitter").get_available()
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local buf, filetype = args.buf, args.match
					local language = vim.treesitter.language.get_lang(filetype)
					if not language then
						vim.print("No lang found:" .. language)
						return
					end

					if not treesitter_try_attach(buf, language) then
						if vim.tbl_contains(installable_parsers, language) then
							require("nvim-treesitter").install(language):await(function()
								treesitter_try_attach(buf, language)
							end)
						end
					end
				end,
			})
			-- require("nvim-treesitter").setup({
			-- 	highlight = { enable = true },
			-- 	indent = {
			-- 		enable = true,
			-- 	},
			-- 	autopairs = {
			-- 		enable = true,
			-- 	},
			-- 	autotag = {
			-- 		enable = true,
			-- 	},
			-- 	--[[ context_commentstring = {
			-- 		enable = true,
			-- 		enable_autocmd = false,
			-- 	}, ]]
			-- 	incremental_selection = {
			-- 		enable = true,
			-- 		keymaps = {
			-- 			init_selection = "<c-space>",
			-- 			node_incremental = "<c-space>",
			-- 			scope_incremental = "<c-s>",
			-- 			node_decremental = "<c-backspace>",
			-- 		},
			-- 	},
			-- 	textobjects = {
			-- 		select = {
			-- 			enable = true,
			-- 			lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
			-- 			keymaps = {
			-- 				-- You can use the capture groups defined in textobjects.scm
			-- 				["aa"] = "@parameter.outer",
			-- 				["ia"] = "@parameter.inner",
			-- 				["af"] = "@function.outer",
			-- 				["if"] = "@function.inner",
			-- 				["ac"] = "@class.outer",
			-- 				["ic"] = "@class.inner",
			-- 			},
			-- 		},
			-- 		move = {
			-- 			enable = true,
			-- 			set_jumps = true, -- whether to set jumps in the jumplist
			-- 			goto_next_start = {
			-- 				["]m"] = "@function.outer",
			-- 				["]]"] = "@class.outer",
			-- 			},
			-- 			goto_next_end = {
			-- 				["]M"] = "@function.outer",
			-- 				["]["] = "@class.outer",
			-- 			},
			-- 			goto_previous_start = {
			-- 				["[m"] = "@function.outer",
			-- 				["[["] = "@class.outer",
			-- 			},
			-- 			goto_previous_end = {
			-- 				["[M"] = "@function.outer",
			-- 				["[]"] = "@class.outer",
			-- 			},
			-- 		},
			-- 	},
			-- })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			vim.g.no_plugin_maps = true
		end,
	},
}
