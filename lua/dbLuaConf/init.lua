require("dbLuaConf.globals")
require("dbLuaConf.options")
require("dbLuaConf.keymaps")
require("dbLuaConf.autocmd")

local function getlockfilepath()
	if require("nixCatsUtils").isNixCats and type(nixCats.settings.unwrappedCfgPath) == "string" then
		return nixCats.settings.unwrappedCfgPath .. "/lazy-lock.json"
	else
		return vim.fn.stdpath("config") .. "/lazy-lock.json"
	end
end
local lazyOptions = {
	lockfile = getlockfilepath(),
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
	performance = {
		reset_packpath = false,
	},
}

require("nixCatsUtils.lazyCat").setup(nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" }), {
	{ import = "dbLuaConf.Plugins" },
	{ import = "dbLuaConf.LSPs" },
}, lazyOptions)

-- require("lze").register_handlers(require("nixCatsUtils.lzUtils").for_cat)
--
-- require("lze").register_handlers(require("lzextras").lsp)
--
-- require("dbLuaConf.Plugins")
