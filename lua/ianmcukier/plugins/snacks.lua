return {
	"folke/snacks.nvim",
	lazy = false,
	---@type snacks.Config
	opts = {
		picker = {
			exclude = {
				"tmp",
				"bazel-*",
				".git",
				".vscode",
				".gradle",
				".dart_tool",
				".DS_Store",
				".symlinks",
				"test_data",
				"Pods",
				"node_modules",
			},
			sources = {
				files = { hidden = true, ignored = true },
				grep = { hidden = true, ignored = true },
				explorer = {
					hidden = true,
					ignored = true,
					auto_close = true,
				},
				gh_diff = {
					auto_close = false,
					layout = {
						preset = "right",
						hidden = { "preview" },
					},
				},
			},
			projects = {
				ignored = true,
				hidden = true,
				dev = { "~/dev/rumi/", "~/.config/" },
				patterns = {
					".gitignore",
				},
				recent = false,
				win = {
					preview = { minimal = true },
					input = {
						keys = {
							["<CR>"] = { { "tcd", "picker_files" }, mode = { "n", "i" } },
							["<c-e>"] = { { "tcd", "picker_explorer" }, mode = { "n", "i" } },
							["<c-f>"] = { { "tcd", "picker_files" }, mode = { "n", "i" } },
							["<c-g>"] = { { "tcd", "picker_grep" }, mode = { "n", "i" } },
							["<c-r>"] = { { "tcd", "picker_recent" }, mode = { "n", "i" } },
							["<c-w>"] = { { "tcd" }, mode = { "n", "i" } },
						},
					},
				},
			},
		},
		scope = {},
		scroll = {},
		indent = {},
		explorer = {},
		lazygit = {},
		gitbrowse = {},
		notifier = {},
		input = {},
		dashboard = {
			preset = {
				header = table.concat({
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠹⣿⣿⣿⣿⡇⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⢻⣿⣿⣿⠀⠀⠀⢹⣿⣿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⡉⠛⠿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠘⣿⣿⠇⠀⠀⠀⠸⣿⣿⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠙⠻⣿⣿⣿⣿⠃⠀⠀⣿⡿⠀⠀⠀⠀⠀⣿⡏⠀⣿⣿⣿⣿⠿⣻⣿⣿⡿⠟⠉⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠈⠛⢿⡏⠀⠀⠀⣿⠃⠀⠀⠀⠀⠀⡿⠀⢰⣿⡿⠟⢁⣴⠿⠛⠉⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣭⣍⡙⠛⠿⣿⣿⣧⠀⠀⠀⠈⠁⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠿⠋⠀⠐⠋⠁⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⡉⠻⢷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠛⠋⠉⠉⠁⠈⠁⠀⠀⠀⢠⠆⠀⠀⠀⠀⠀⠀⠉⠲⣄⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⠿⠿⠿⠿⠟⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⣀⠀⠀⢠⡄⠀⠀⠀⠀⠈⠣⠀⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿⡿⠷⢿⣧⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣀⠀⠀⠀⠀⢀⣤⣶⡿⠋⠀⠀⠀⠉⠛⢷⣦⣤⣀⡀⢀⣼⣦⡀⠀⣠⣾⠿⠛⠛⠛⠛⠛⣻⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠶⠶⠆⠀⠀⠀⠀⠀⠈⣿⣶⣤⣶⣾⠿⠋⠁⠀⠀⢀⣀⣀⣀⣀⡀⠀⠙⠻⣿⣿⣿⡋⢳⣄⠀⠀⠀⣀⣤⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⠿⠋⠁⠀⠀⣠⠴⠛⠉⠀⠀⠀⠀⠉⠓⠦⣄⠈⠙⠻⡇⠀⠹⣆⠀⠋⠉⠙⠛⠛⠿⠿⢿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣉⣉⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡿⠀⠀⠀⠀⢀⡜⠁⢀⣠⣴⣾⣿⣿⣿⣶⣤⣀⣈⡇⠀⢠⣧⠀⠀⠹⣆⠀⠀⠀⠀⠀⠀⠀⢀⣀⣹⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣦⣉⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⡞⡇⠀⠀⠀⠀⢾⣦⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⣼⢾⡄⠀⠀⠹⣄⠀⠀⠀⣀⣴⣶⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣵⣿⡀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⢠⠏⠛⢹⠀⠀⠀⠹⣶⠒⢺⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣤⣀⡀⠀⠀⠀⠀⠠⡏⢀⢀⠈⢷⡀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⡿⠿⢿⠏⠀⠀⠀⠀⢀⣯⣀⣠⣤⣶⣿⡻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⢣⠀⠸⠦⠄⠛⠀⠀⠀⠀⠀⠀⠙⠲⠤⠤⠤⠤⠞⠃⠀⠀⡰⠤⠴⠋⠀⠀⠉⠛⠿⣿⣿⣞⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⠳⢄⣀⣀⡠⢦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡞⢀⢀⣀⣀⣀⣀⣀⣀⣀⣈⠻⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⢀⣤⠀⠀⠈⠉⠉⡀⠀⠱⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠚⠁⣇⣈⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣀⣴⣶⣿⣿⡇⠀⠀⢀⣤⣶⣿⠀⠀⢹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡽⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⢀⣰⣾⣿⣿⣿⡏⣰⢰⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣇⣷⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣟⢿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⢿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⢿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣹",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠿⢿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠉⠙⠒⠢⢤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀⢦⣀⠀⠀⠀⠉⠑⠒⠤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠈⠑⠦⣀⠀⠀⠀⠀⠀⠈⠉⠓⠶⢄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⡿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢢⡀⠈⠳⢄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⠀⠠⢤⣀⠐⠒⠒⠂⠉⠉⠁⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿",
					"⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⠀⠀⠀⠙⢦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿",
				}, "\n"),
				keys = {
					{ icon = "", key = "p", desc = "Select Project", action = ":lua Snacks.picker.projects()" },
					{ icon = "", key = "e", desc = "File Explorer", action = ":lua Snacks.explorer()" },
					{ icon = "", key = "f", desc = "Search Files", action = ":lua Snacks.picker.files()" },
					{ icon = "", key = "q", desc = "Quit", action = ":qa" },
				},
			},
			sections = {
				{ section = "header" },
				{ section = "keys", gap = 1, padding = 1 },
				{ section = "startup" },
			},
		},
		gh = {
			wo = {
				foldenable = false,
				foldmethod = "manual",
				foldexpr = "0",
			},
		},
	},
	keys = {
		{
			"<leader>sn",
			function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Find Config File",
		},
		{
			"<leader>sf",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>sp",
			function()
				Snacks.picker.projects()
			end,
			desc = "Projects",
		},
		{
			"<leader>sr",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent",
		},
		{
			"<leader>sR",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "LSP Symbols",
		},
		{
			"<leader>sS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "LSP Workspace Symbols",
		},
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader><space>",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files",
		},
		{
			"<leader>,",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>/",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>n",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},
		{
			"<leader>ef",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.lines()
			end,
			desc = "Buffer Lines",
		},
		{
			"<leader>sB",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Grep Open Buffers",
		},
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Visual selection or word",
			mode = { "n", "x" },
		},
		{
			"<leader>g",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazy git",
		},
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gD",
			function()
				Snacks.picker.lsp_declarations()
			end,
			desc = "Goto Declaration",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>hy",
			function()
				Snacks.gitbrowse({
					open = function(url)
						vim.fn.setreg("+", url)
						vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)
					end,
					notify = false,
				})
			end,
			desc = "Git Browse (copy URL)",
			mode = { "n", "v" },
		},
		{
			"<leader>hg",
			function()
				Snacks.picker.gh_pr()
			end,
			desc = "GitHub Pull Requests (open)",
		},
		{
			"<leader>hG",
			function()
				Snacks.picker.gh_pr({ state = "all" })
			end,
			desc = "GitHub Pull Requests (all)",
		},
	},
}
