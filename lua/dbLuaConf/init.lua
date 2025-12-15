require("dbLuaConf.globals")
require("dbLuaConf.options")
require("dbLuaConf.keymaps")

require("lze").register_handlers(require("nixCatsUtils.lzUtils").for_cat)

require("lze").register_handlers(require("lzextras").lsp)

require("dbLuaConf.Plugins")

require("dbLuaConf.LSPs")

if nixCats("lint") then
	require("dbLuaConf.lint")
end
if nixCats("format") then
	require("dbLuaConf.format")
end
