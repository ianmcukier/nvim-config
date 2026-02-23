return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	enabled = false,
	config = function()
		-- lua/my_eslintd_lint.lua
		local lint = require("lint")

		-- Walk up from a directory until we find a marker file/dir.
		local function find_up(start_dir, markers)
			local dir = start_dir
			while dir and dir ~= "" do
				for _, name in ipairs(markers) do
					local path = dir .. "/" .. name
					local stat = vim.loop.fs_stat(path)
					if stat then
						return dir
					end
				end
				local parent = vim.fn.fnamemodify(dir, ":h")
				if parent == dir then
					break
				end
				dir = parent
			end
			return nil
		end

		local function repo_root_from_ctx(ctx)
			-- ctx.dirname is available on recent nvim-lint
			local start = ctx and (ctx.dirname or vim.fn.fnamemodify(ctx.filename or "", ":p:h")) or vim.loop.cwd()
			return find_up(start, { "nx.json", "pnpm-workspace.yaml", "package.json", ".git" })
				or (ctx and ctx.cwd)
				or vim.loop.cwd()
		end

		-- Define/overwrite eslint_d linter for nvim-lint
		lint.linters.eslint_d = {
			cmd = "eslint_d",
			stdin = true,
			-- nvim-lint (newer) supports functions here; they must return a *list of strings*
			args = function(ctx)
				local filename = ctx and ctx.filename or vim.api.nvim_buf_get_name(0)
				local root = repo_root_from_ctx(ctx)
				return {
					"--stdin",
					"--stdin-filename",
					filename,
					"--resolve-plugins-relative-to",
					root,
				}
			end,
			-- Must return a *string* directory
			cwd = function(ctx)
				return repo_root_from_ctx(ctx)
			end,
		}

		-- Your filetype setup
		lint.linters_by_ft = {
			typescript = { "eslint_d" },
			javascript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			javascriptreact = { "eslint_d" },
		}

		-- Your autocmds & keymap
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
