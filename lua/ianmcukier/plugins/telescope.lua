return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
				},
				file_ignore_patterns = {
					"^.git",
					"cscope.out",
					"cscope.files",
					"cscope.in.out",
					"cscope.po.out",
					"*venv*",
					"__pycache__/",
					"*.py[cod]",
					"^.vscode",
					"*.path",
				},
				set_env = { ["COLORTERM"] = "truecolor" },
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("ui-select")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		local builtin = require("telescope.builtin")
		keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })
		keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
		keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Search Files" })
		keymap.set("n", "<leader>ss", builtin.builtin, { desc = "Search Select Telescope" })
		keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Search current Word" })
		keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Search by Grep" })
		keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search Diagnostics" })
		keymap.set("n", "<leader>sr", builtin.resume, { desc = "Search Resume" })
		keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = 'Search Recent Files ("." for repeat)' })
		keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "Search in current buffer" })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		vim.keymap.set("n", "<leader>s/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "Search in Open Files" })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Search Neovim files" })
	end,
}
