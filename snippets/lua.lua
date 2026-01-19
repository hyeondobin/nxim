local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local c = ls.choice_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local parse = require("luasnip.util.parser").parse_snippet

local function copy(args)
	return args[1]
end

return {
	s(
		"fn",
		fmt("function {name}({param})\n  {}\nend\n{}", {
			i(3),
			name = i(1),
			param = i(2),
			i(0),
		})
	),
	s(
		"if",
		fmta("if <cond> then\n  <body>\nend<>", {
			cond = i(1),
			body = i(2),
			i(0),
		})
	),
}
