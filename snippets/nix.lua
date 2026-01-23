local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local parse = require("luasnip.util.parser").parse_snippet
local fmt = require("luasnip.extras.fmt").fmta

return {
	s("custog", {
		t("{ config, lib, ...}: {\n"),
		i(0),
		t("}"),
	}),
	s(
		"moduleTog",
		fmt(
			[[
	{ config, lib, ...}:
	let
	  cfg = config.dbConfig;
	in
	{
	  options = {
	    dbConfig.<toggleName> = lib.mkEnableOption "Enable <toggleName>";
	  };
	  config = lib.mkIf cfg.<toggleName> {
		<body>
	  };
	<>
	}
	]],
			{
				toggleName = i(1, "Name_of_toggle"),
				body = i(2),
				i(0),
			},
			{ repeat_duplicates = true }
		)
	),
}
