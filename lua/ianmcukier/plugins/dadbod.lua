return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1

		vim.cmd("let g:db_ui_disable_mappings = 1")
		vim.cmd("let g:db_ui_execute_on_save = 0")
		require("which-key").add({
			{ "<leader>b", group = "DB" },
		})

		vim.keymap.set("n", "<leader>bb", "<cmd>DBUIToggle<CR>", { desc = "UI Toggle" })
		vim.keymap.set("n", "<leader>bq", "<Plug>(DBUI_ExecuteQuery)", { desc = "Query" })
		vim.keymap.set("v", "<leader>bq", "<Plug>(DBUI_ExecuteQuery)", { desc = "Query" })
	end,
	config = function()
		vim.cmd("autocmd FileType dbui nmap <buffer> <CR> <Plug>(DBUI_SelectLine)")
		vim.cmd("autocmd FileType dbui nmap <buffer> d <Plug>(DBUI_DeleteLine)")
		vim.cmd("autocmd FileType dbui nmap <buffer> s <Plug>(DBUI_SaveQuery)")
	end,
}
