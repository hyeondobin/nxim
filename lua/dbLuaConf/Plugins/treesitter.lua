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
			-- vim.opt.rtp:prepend(require("nixCats").pawsible.allPlugins.start["nvim-treesitter"] .. "/runtime")
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
