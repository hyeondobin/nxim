return {
	"neovim/nvim-lspconfig",
	lazy = false,
	dependencies = {
		{
			"williamboman/mason.nvim",
			enabled = require("nixCatsUtils").lazyAdd(true, false),
			config = true,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			enabled = require("nixCatsUtils").lazyAdd(true, false),
		},
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			enabled = require("nixCatsUtils").lazyAdd(true, false),
		},
		{ "j-hui/fidget.nvim", opts = {} },
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{
						words = { "nixCats" },
						path = (nixCats.nixCatsPath or "") .. "/lua",
					},
				},
			},
		},
	},
	config = function()
		vim.diagnostic.config({
			severity_sort = true,
			float = { border = "rounded", source = "if_many" },
			underline = { severity = vim.diagnostic.severity.ERROR },
			signs = vim.g.have_nerd_font and {
				text = {
					[vim.diagnostic.severity.ERROR] = "󰅚 ",
					[vim.diagnostic.severity.WARN] = "󰀪 ",
					[vim.diagnostic.severity.INFO] = "󰋽 ",
					[vim.diagnostic.severity.HINT] = "󰌶 ",
				},
			} or {},
			virtual_text = {
				source = "if_many",
				spacing = 2,
				format = function(diagnostic)
					local diagnostic_message = {
						[vim.diagnostic.severity.ERROR] = diagnostic.message,
						[vim.diagnostic.severity.WARN] = diagnostic.message,
						[vim.diagnostic.severity.INFO] = diagnostic.message,
						[vim.diagnostic.severity.HINT] = diagnostic.message,
					}
					return diagnostic_message[diagnostic.severity]
				end,
			},
			-- virtual_lines = {
			-- 	enabled = false,
			-- 	current_line = true,
			-- },
		})
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("nxim-lsp-attach", { clear = true }),
			callback = function(event)
				local wk = require("which-key")

				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
				map("K", vim.lsp.buf.hover, "Hover Documentation")
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				wk.add({
					{ "<leader>d", group = "LSP: [D]ocument" },
					{ "<leader>w", group = "LSP: [W]orkspace" },
					{ "<leader>r", group = "LSP: [R]e" },
					{ "<leader>c", group = "LSP: [C]ode" },
				})

				-- clear highlights when moving cursor
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					local highlight_augroup = vim.api.nvim_create_augroup("nxim-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("nxim-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "nxim-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, "[T]oggle Inlay [H]ints")
					wk.add({
						{ "<leader>t", group = "LSP: [T]oggle" },
					})
				end
			end,
		})

		local dbcapabilities = require("blink.cmp").get_lsp_capabilities()
		-- local capabilities = vim.lsp.protocol.make_client_capabilities()
		-- capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
		-- vim.lsp.config("*", { capabilities = capabilities })

		local servers = {}

		if require("nixCatsUtils").isNixCats then
			servers.nixd = {
				-- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
				nixpkgs = {
					-- nixdExtras.nixpkgs = ''import ${pkgs.path} {}''
					expr = nixCats.extra("nixdExtras.nixpkgs") or [[import <nixpkgs> {}]],
				},
				options = {
					nixos = {
						expr = nixCats.extra("nixdExtras.nixos_options"),
					},
					["home-manager"] = {
						expr = nixCats.extra("nixdExtras.home_manager_options"),
					},
				},
				formatting = {
					command = { "nixfmt" },
				},
				diagnostic = {
					suppress = {
						"sema-escaping-with",
					},
				},
			}
		else
			-- servers.rnix = {}
			-- servers.nil_ls = {}
		end

		servers.lua_ls = {
			Lua = {
				runtime = { version = "LuaJIT" },
				formatters = {
					ignoreComments = true,
				},
				signatureHelp = { enabled = true },
				diagnostics = {
					globals = { "nixCats", "vim" },
					disable = { "missing-fields", "mixed_table" },
				},
				telemetry = { enabled = false },
			},
		}

		if require("nixCatsUtils").isNixCats then
			for server_name, cfg in pairs(servers) do
				vim.lsp.config(server_name, cfg)
				vim.lsp.enable(server_name)
			end
		else
			require("mason").setup()

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						vim.lsp.config(server_name, servers[server_name] or {})
						vim.lsp.enable(server_name)
					end,
				},
			})
		end

		-- {
		-- 	"rust_analyzer",
		-- 	enabled = nixCats("rust"),
		-- 	lsp = {
		-- 		filetypes = { "rs" },
		-- 		settings = {
		-- 			["rust-analyzer"] = {
		-- 				checkOnSave = {
		-- 					command = "clippy",
		-- 				},
		-- 				procMacro = { enable = true },
		-- 			},
		-- 		},
		-- 	},
		-- },
	end,
}
