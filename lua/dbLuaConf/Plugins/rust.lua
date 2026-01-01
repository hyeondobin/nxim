if nixCats("rust") then
	require("lze").load({
		{
			"rustaceanvim",
			ft = { "rust" },
			after = function()
				vim.g.rustaceanvim = {
					server = {
						default_settings = {
							["rust-analyzer"] = {
								checkOnSave = {
									command = "clippy",
								},
							},
						},
					},
				}
			end,
		},
	})
end
