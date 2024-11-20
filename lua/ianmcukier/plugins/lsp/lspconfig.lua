return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		"rcarriga/nvim-notify",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import mason_lspconfig plugin
		local mason_lspconfig = require("mason-lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("blink.cmp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)

				require("notify")("Attached " .. client.name .. "!", "msg", { title = "LSPConfig" })

				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				-- keymap.set("n", "gr", "<cmd>FzfLua lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>FzfLua lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gtd", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, silent = false }) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				opts.remap = false
				-- keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
				keymap.set("n", "K", function()
					local base_win_id = vim.api.nvim_get_current_win()
					local windows = vim.api.nvim_tabpage_list_wins(0)
					for _, win_id in ipairs(windows) do
						if win_id ~= base_win_id then
							local win_cfg = vim.api.nvim_win_get_config(win_id)
							if win_cfg.relative == "win" and win_cfg.win == base_win_id then
								require("noice.lsp.docs").hide(require("noice.lsp.docs").get("hover"))
								return
							end
						end
					end
					require("noice.lsp").hover()
				end, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

				opts.desc = "Search Symbols"
				keymap.set("n", "<leader>sy", require("telescope.builtin").lsp_dynamic_workspace_symbols, opts)

				-- -- Execute a code action, usually your cursor needs to be on top of an error
				-- -- or a suggestion from your LSP for this to activate.
				-- opts.desc = "Code actions"
				-- keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

				-- The following two autocommands are used to highlight references of the
				-- word under your cursor when your cursor rests there for a little while.
				--    See `:help CursorHold` for information about when this is executed
				--
				-- When you move your cursor, the highlights will be cleared (the second autocommand).
				-- local client = vim.lsp.get_client_by_id(ev.data.client_id)
				-- if client and client.server_capabilities.documentHighlightProvider then
				-- 	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				-- 		buffer = ev.buf,
				-- 		callback = vim.lsp.buf.document_highlight,
				-- 	})
				--
				-- 	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				-- 		buffer = ev.buf,
				-- 		callback = vim.lsp.buf.clear_references,
				-- 	})
				-- end
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = cmp_nvim_lsp.get_lsp_capabilities(capabilities)

		mason_lspconfig.setup_handlers({
			-- default handler for installed servers
			function(server_name)
				lspconfig[server_name].setup({
					capabilities = capabilities,
				})
			end,
			["lua_ls"] = function()
				-- configure lua server (with special settings)
				lspconfig["lua_ls"].setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							-- make the language server recognize "vim" global
							diagnostics = {
								globals = { "vim", "LazyVim" },
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				})
			end,

			["gopls"] = function()
				lspconfig["gopls"].setup({
					capabilities = capabilities,
					cmd = { "gopls" },
					filetypes = { "go", "gomod", "gowork", "gotmpl" },
					root_dir = require("lspconfig/util").root_pattern("gowork", "go.mod", ".git"),
					settings = {
						gopls = {
							completeUnimported = true,
							usePlaceholders = true,
							analyses = {
								unusedparams = true,
							},
						},
					},
				})
			end,

			["sqlls"] = function()
				lspconfig["sqlls"].setup({
					cmd = {
						"/Users/ianmcukier/.local/share/nvim/mason/bin/sql-language-server",
						"up",
						"--method",
						"stdio",
						"-config",
						"/User/ianmcukier/.config/sql-language-server/.sqllsrc.json",
					},
					capabilities = capabilities,
					filetypes = { "sql" },
					root_dir = vim.loop.cwd,
				})
			end,

			["pyright"] = function()
				lspconfig["pyright"].setup({
					capabilities = capabilities,
					filetypes = { "python" },
				})
			end,

			["terraformls"] = function()
				lspconfig["terraformls"].setup({
					capabilities = capabilities,
					filetypes = { "terraform" },
				})
			end,
		})

		-- Non-mason LSP configuraions
		lspconfig.clangd.setup({
			capabilities = capabilities,
			-- init_options = {
			-- 	compilationDatabasePath = "android/build/cmake",
			-- },
			cmd = {
				"clangd",
				"--header-insertion=iwyu",
				"--background-index",
				"--completion-style=detailed",
				"--cross-file-rename",
				"--clang-tidy",
			},
		})

		capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true
		lspconfig.sourcekit.setup({
			filetypes = { "swift" },
			capabilities = capabilities,
			cmd = { "sourcekit-lsp" },
			-- root_dir = function(filename, _)
			-- 	local util = require("lspconfig.util")
			-- 	return util.root_pattern("*xcodeproj", ".xcworkspace")(filename)
			-- 		or util.find_git_ancestor(filename)
			-- 		or util.root_pattern("Package.swift")(filename)
			-- end,
			-- root_dir = "~/Develop/inda_audio/example/ios/",
		})

		-- Set unrecognized filetypes here
		vim.filetype.add({
			extension = {
				arb = "json",
				["swift-format"] = "json",
			},
		})
	end,
}
