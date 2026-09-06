---@diagnostic disable: missing-fields
return {
	"mason-org/mason.nvim",
	dependencies = {
		{
			"mason-org/mason-lspconfig.nvim",
			dependencies = { "neovim/nvim-lspconfig" },
		},
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			automatic_enable = true,
			ensure_installed = {
				"lua_ls",
				"gopls",
				"sqlls",
				"pyright",
				"terraformls",
				"buf_ls",
				"ts_ls",
				"jsonls",
				"tailwindcss",
				"yamlls",
				"eslint",
				"prismals",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"gofumpt",
				"goimports",
				"sql-formatter",
				"prettier",
				"stylua",
				"black",
			},
		})
	end,
}
