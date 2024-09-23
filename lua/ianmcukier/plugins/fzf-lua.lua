return {
	"ibhagwan/fzf-lua",
	-- optional for icon support
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{ "junegunn/fzf", build = "./install --bin" },
	},
	config = function()
		-- calling `setup` is optional for customization
		local fzf = require("fzf-lua")

		fzf.setup({
			"telescope",
			files = {
				cwd_prompt = false,
				formatter = "path.filename_first", -- places file name first
				-- cwd = vim.loop.cwd(),
			},
			-- grep = {
			-- 	rg_opts = [[--glob "!test" --glob "!.git" --hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e]],
			-- },
		})

		-- Searches
		require("which-key").add({
			{ "<leader>st", group = "Search Tests" },
			{ "<leader>sr", group = "Search Resume" },
		})

		vim.keymap.set("n", "<leader>sf", fzf.files, { desc = "Search Files" })
		vim.keymap.set("n", "<leader>sg", function()
			fzf.live_grep_glob({
				rg_opts = [[ --sort=path --hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 --with-filename --glob "!*_test.*" -g "!.git" --glob !build --glob !spell --glob !lockfiles --glob !LICENSE]],
			})
		end, { desc = "Search Grep" })
		vim.keymap.set("n", "<leader>sG", function()
			fzf.live_grep_glob({
				rg_opts = [[ --sort=path --hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 --with-filename --glob "*_test.*" -g "!.git" --glob !build --glob !spell --glob !lockfiles --glob !LICENSE]],
			})
		end, { desc = "Search Tests Grep" })
		vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = "Search Word" })
		vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = "Search open buffers" })
		vim.keymap.set("n", "<leader>s.", fzf.oldfiles, { desc = 'Search Recent Files ("." for repeat)' })
		vim.keymap.set("v", "<leader>sw", fzf.grep_visual, { desc = "Search Word" })
		-- Resume searches
		vim.keymap.set("n", "<leader>srg", fzf.live_grep_resume, { noremap = true, desc = "Search Resume Grep" })
		vim.keymap.set("n", "<leader>srw", fzf.grep_last, { desc = "Search Resume Word" })
		vim.keymap.set("n", "<leader>srr", fzf.resume, { desc = "Search Resume" })

		local opts = { silent = true }
		opts.desc = "Show LSP references"
		vim.keymap.set("n", "gr", function()
			fzf.lsp_references({
				file_ignore_patterns = { ".*_test.*" },
			})
		end, opts)

		--TODO: how to show only test references?
		vim.keymap.set("n", "gtr", function()
			fzf.lsp_references({
				-- fzf_opts = { ["--query"] = "test" },
			})
		end, opts)
		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set("n", "<leader>sn", function()
			fzf.files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Search Neovim files" }) -- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set("n", "<leader>s/", fzf.lgrep_curbuf, { desc = "Search in current buffer" })
	end,
}
