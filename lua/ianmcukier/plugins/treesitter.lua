---@diagnostic disable: missing-fields
return {
	"nvim-treesitter/nvim-treesitter",
	-- dependencies = {
	-- 	"nvim-treesitter/nvim-treesitter-textobjects",
	-- },
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	-- dependencies = {
	--   "windwp/nvim-ts-autotag",
	-- },
	config = function()
		-- import nvim-treesitter plugin
		local treesitter = require("nvim-treesitter.configs")

		-- configure treesitter
		treesitter.setup({ -- enable syntax highlighting
			highlight = {
				enable = true,
			},
			-- enable indentation
			indent = {
				enable = true,
				disable = { "dart" },
			},
			-- enable autotagging (w/ nvim-ts-autotag plugin)
			-- autotag = {
			--   enable = true,
			-- },
			-- ensure these language parsers are installed
			ensure_installed = {
				"json",
				"yaml",
				"html",
				"css",
				"markdown",
				"markdown_inline",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"vimdoc",
				"c",
				"go",
				"gomod",
				"gosum",
				"gowork",
				"regex",
				"sql",
				"python",
				"terraform",
				"swift",
				-- "dart",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
			-- textobjects = {
			-- 	-- select = {
			-- 	--   enable = false,
			-- 	--   -- Automatically jump forward to textobj, similar to targets.vim
			-- 	--   lookahead = true,
			-- 	--   keymaps = {
			-- 	--     -- You can use the capture groups defined in textobjects.scm
			-- 	--     ['af'] = '@function.outer',
			-- 	--     ['if'] = '@function.inner',
			-- 	--     ['ac'] = '@class.outer',
			-- 	--     ['ic'] = '@class.inner',
			-- 	--     ['al'] = '@loop.outer',
			-- 	--     ['il'] = '@loop.inner',
			-- 	--     ['aa'] = '@parameter.outer',
			-- 	--     ['ia'] = '@parameter.inner',
			-- 	--     -- ['uc'] = '@comment.outer',
			-- 	--     -- Or you can define your own textobjects like this
			-- 	--     -- ["iF"] = {
			-- 	--     --     python = "(function_definition) u/function",
			-- 	--     --     cpp = "(function_definition) u/function",
			-- 	--     --     c = "(function_definition) u/function",
			-- 	--     --     java = "(method_declaration) u/function",
			-- 	--     -- },
			-- 	--   },
			-- 	-- },
			-- 	-- move = {
			-- 	-- 	enable = true,
			-- 	-- 	set_jumps = true, -- whether to set jumps in the jumplist
			-- 	-- 	goto_next_start = {
			-- 	-- 		["]f"] = "@function.outer",
			-- 	-- 		["]]"] = "@class.outer",
			-- 	-- 		["]a"] = "@parameter.inner",
			-- 	-- 	},
			-- 	-- 	goto_next_end = {
			-- 	-- 		["]F"] = "@function.outer",
			-- 	-- 		["]["] = "@class.outer",
			-- 	-- 	},
			-- 	-- 	goto_previous_start = {
			-- 	-- 		["[f"] = "@function.outer",
			-- 	-- 		["[["] = "@class.outer",
			-- 	-- 		["[a"] = "@parameter.inner",
			-- 	-- 	},
			-- 	-- 	goto_previous_end = {
			-- 	-- 		["[F"] = "@function.outer",
			-- 	-- 		["[]"] = "@class.outer",
			-- 	-- 	},
			-- 	-- },
			-- },
		})
	end,
}
