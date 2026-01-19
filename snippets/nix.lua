local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local parse = require("luasnip.util.parser").parse_snippet

return {
	s("custog", {
		t("{ config, lib, ...}: {\n"),
		i(1),
		t("}"),
	}),
}
