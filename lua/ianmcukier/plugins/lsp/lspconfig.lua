return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		"rcarriga/nvim-notify",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},
	config = function()
		-- Set global capabilities for all LSP servers (blink.cmp completion)
		vim.lsp.config("*", {
			capabilities = require("blink.cmp").get_lsp_capabilities(),
		})

		-- Configure lua_ls to recognize the `vim` global
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if not client then
					return
				end

				require("notify")("Attached " .. client.name .. "!", "msg", { title = "LSPConfig" })

				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Code actions"
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>D", function()
					Snacks.picker.diagnostics_buffer()
				end, opts)

				opts.desc = "Search workspace symbols"
				vim.keymap.set("n", "<leader>sy", function()
					Snacks.picker.lsp_workspace_symbols()
				end, opts)

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})
	end,
}
