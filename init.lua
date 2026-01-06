require("nixCatsUtils").setup({
	non_nix_value = true,
})

vim.g.have_nerd_font = nixCats("have_nerd_font")

require("dbLuaConf")
