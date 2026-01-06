if nixCats("lint") then
	return {
		"mfussenegger/nvim-lint",
		event = "FileType",
		config = function(plugin)
			require("lint").linters_by_ft = {
				lua = { "selene" },
			}
			-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			-- 	callback = function()
			-- 		require("lint").try_lint()
			-- 	end,
			-- })
		end,
	}
end
