return {
	"saghen/blink.cmp",
	enabled = true,
	lazy = false, -- lazy loading handled internally
	-- optional: provides snippets for the snippet source
	dependencies = "rafamadriz/friendly-snippets",

	-- use a release tag to download pre-built binaries
	version = "v0.*",
	-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' for mappings similar to built-in completion
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		-- see the "default configuration" section below for full documentation on how to define
		-- your own keymap.
		keymap = {
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},
		accept = {
			auto_brackets = {
				enabled = true,
				-- default_brackets = { "(", ")" },
				-- override_brackets_for_filetypes = {},
				-- -- Overrides the default blocked filetypes
				-- force_allow_filetypes = {},
				-- blocked_filetypes = {},
				-- -- Synchronously use the kind of the item to determine if brackets should be added
				-- kind_resolution = {
				-- 	enabled = true,
				-- 	blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
				-- },
				-- -- Asynchronously use semantic token to determine if brackets should be added
				-- semantic_token_resolution = {
				-- 	enabled = true,
				-- 	blocked_filetypes = {},
				-- 	-- How long to wait for semantic tokens to return before assuming no brackets should be added
				-- 	timeout_ms = 400,
				-- },
			},
		},
		fuzzy = {
			max_items = 30,
			-- controls which sorts to use and in which order, these three are currently the only allowed options
			sorts = { "label", "score", "kind" },
		},
		sources = {
			-- list of enabled providers
			completion = {
				enabled_providers = { "lsp", "path", "snippets", "buffer" },
			},
		},
		windows = {
			autocomplete = {
				min_width = 10,
				max_height = 10,
				border = "rounded",
				winblend = vim.o.pumblend,
				winhighlight = "Pmenu:BlinkCmpMenu,FloatBorder:FloatBorder",
				-- keep the cursor X lines away from the top/bottom of the window
				scrolloff = 2,
				-- note that the gutter will be disabled when border ~= 'none'
				scrollbar = true,
				-- which directions to show the window,
				-- falling back to the next direction when there's not enough space
				direction_priority = { "s", "n" },
				-- Controls whether the completion window will automatically show when typing
				auto_show = false,
				-- Controls how the completion items are selected
				-- 'preselect' will automatically select the first item in the completion list
				-- 'manual' will not select any item by default
				-- 'auto_insert' will not select any item by default, and insert the completion items automatically when selecting them
				selection = "preselect",
				-- Controls how the completion items are rendered on the popup window
				-- 'simple' will render the item's kind icon the left alongside the label
				-- 'reversed' will render the label on the left and the kind icon + name on the right
				-- 'minimal' will render the label on the left and the kind name on the right
				-- 'function(blink.cmp.CompletionRenderContext): blink.cmp.Component[]' for custom rendering
				draw = "simple",
				-- Controls the cycling behavior when reaching the beginning or end of the completion list.
				cycle = {
					-- When `true`, calling `select_next` at the *bottom* of the completion list will select the *first* completion item.
					from_bottom = true,
					-- When `true`, calling `select_prev` at the *top* of the completion list will select the *last* completion item.
					from_top = true,
				},
			},
			documentation = {
				min_width = 10,
				max_width = 120,
				max_height = 40,
				border = "rounded",
				winblend = vim.o.pumblend,
				winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
				-- note that the gutter will be disabled when border ~= 'none'
				scrollbar = true,
				-- which directions to show the documentation window,
				-- for each of the possible autocomplete window directions,
				-- falling back to the next direction when there's not enough space
				direction_priority = {
					autocomplete_north = { "e", "w", "n", "s" },
					autocomplete_south = { "e", "w", "s", "n" },
				},
				-- Controls whether the documentation window will automatically show when selecting a completion item
				auto_show = false,
				auto_show_delay_ms = 500,
				update_delay_ms = 50,
			},
		},
		kind_icons = {
			Text = "  ",
			Method = "  ",
			Function = "  ",
			Constructor = "  ",
			Field = "  ",
			Variable = "  ",
			Class = "  ",
			Interface = "  ",
			Module = "  ",
			Property = "  ",
			Unit = "  ",
			Value = "  ",
			Enum = "  ",
			Keyword = "  ",
			Snippet = "  ",
			Color = "  ",
			File = "  ",
			Reference = "  ",
			Folder = "  ",
			EnumMember = "  ",
			Constant = "  ",
			Struct = "  ",
			Event = "  ",
			Operator = "  ",
			TypeParameter = "  ",
		},
		highlight = {
			-- sets the fallback highlight groups to nvim-cmp's highlight groups
			-- useful for when your theme doesn't support blink.cmp
			-- will be removed in a future release, assuming themes add support
			use_nvim_cmp_as_default = true,
		},
		-- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		-- adjusts spacing to ensure icons are aligned
		nerd_font_variant = "normal",

		-- experimental auto-brackets support
		-- accept = { auto_brackets = { enabled = true } }

		-- experimental signature help support
		-- trigger = { signature_help = { enabled = true } }
	},
	-- allows extending the enabled_providers array elsewhere in your config
	-- without having to redefining it
	opts_extend = { "sources.completion.enabled_providers" },
}

-- keymap = {
-- 	show = "<C-space>",
-- 	hide = "<C-space>",
-- 	accept = "<Tab>",
-- 	select_prev = { "<C-p>", "<C-k>" },
-- 	select_next = { "<C-n>", "<C-j>" },
--
-- 	show_documentation = {},
-- 	hide_documentation = {},
-- 	scroll_documentation_up = {},
-- 	scroll_documentation_down = {},
--
-- 	snippet_forward = {},
-- 	snippet_backward = {},
-- },
