---@diagnostic disable: missing-fields
return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	dependencies = {
		"rafamadriz/friendly-snippets",
		"Kaiser-Yang/blink-cmp-avante",
	},

	-- use a release tag to download pre-built binaries
	version = "*",
	-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
	-- build = 'cargo build --release',
	-- If you use nix, you can build from source using latest nightly rust with:
	-- build = 'nix run .#build-plugin',

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept, C-n/C-p for up/down)
		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys for up/down)
		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
		--
		-- All presets have the following mappings:
		-- C-space: Open menu or open docs if already open
		-- C-e: Hide menu
		-- C-k: Toggle signature help
		--
		-- See the full "keymap" documentation for information on defining your own keymap.
		keymap = {
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-e>"] = { "hide", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-b>"] = { "scroll_documentation_up", "fallback" },
			["<C-f>"] = { "scroll_documentation_down", "fallback" },
		},

		cmdline = {
			keymap = {
				["<C-k>"] = { "select_prev", "fallback" },
				["<C-j>"] = { "select_next", "fallback" },
				["<CR>"] = { "accept_and_enter", "fallback" },
			},
			-- (optionally) automatically show the menu
			completion = {
				list = {
					selection = {
						-- When `true`, will automatically select the first item in the completion list
						preselect = false,
						-- When `true`, inserts the completion item automatically when selecting it
						auto_insert = false,
					},
				},
				menu = { auto_show = true },
			},
		},

		appearance = {
			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
			-- Useful for when your theme doesn't support blink.cmp
			-- Will be removed in a future release
			use_nvim_cmp_as_default = true,
			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
			kind_icons = {
				Text = "󰉿 ",
				Method = " ",
				Function = " ",
				Constructor = "󰒓 ",

				Field = "󰜢 ",
				Variable = "󱄑 ",
				Property = "󰖷 ",

				Class = " ",
				Interface = " ",
				Struct = " ",
				Module = " ",

				Unit = "󰪚 ",
				Value = " ",
				Enum = " ",
				EnumMember = " ",

				Keyword = " ",
				Constant = " ",

				Snippet = "󱄽 ",
				Color = " ",
				File = " ",
				Reference = " ",
				Folder = " ",
				Event = " ",
				Operator = " ",
				TypeParameter = " ",
			},
		},

		completion = {
			list = {
				max_items = 50,
				selection = {
					-- When `true`, will automatically select the first item in the completion list
					preselect = false,
					-- When `true`, inserts the completion item automatically when selecting it
					auto_insert = true,
				},
			},
			documentation = {
				auto_show = true,
				treesitter_highlighting = true,
				auto_show_delay_ms = 50,
				update_delay_ms = 50,
				window = {
					min_width = 40,
					max_width = 50,
					max_height = 40,
					border = "double",
					scrollbar = true,
					winblend = 0,
				},
			},
			menu = {
				-- enabled = true,
				min_width = 10,
				max_height = 15,
				border = "double",
				winblend = 0,
				winhighlight = "Pmenu:BlinkCmpMenu,FloatBorder:FloatBorder",
				--
				-- scrolloff = 0,
				-- -- falling back to the next direction when there's not enough space
				-- auto_show = false,
				-- Controls how the completion items are rendered on the popup window
				draw = {
					-- Aligns the keyword you've typed to a component in the menu
					align_to = "label", -- or 'none' to disable
					-- Left and right padding, optionally { left, right } for different padding on each side
					padding = 1,
					-- Gap between columns
					gap = 1,

					treesitter = { "lsp" },

					-- Components to render, grouped by column
					columns = { { "kind_icon" }, { "label" } },
					-- for a setup similar to nvim-cmp: https://github.com/Saghen/blink.cmp/pull/245#issuecomment-2463659508
					-- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
				},
			},
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			providers = {
				avante = {
					module = "blink-cmp-avante",
					name = "Avante",
					opts = {
						-- options for blink-cmp-avante
					},
				},
			},
			default = { "avante", "lsp", "path", "snippets", "buffer" },
		},

		-- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}

-- return {
-- 	"saghen/blink.cmp",
-- 	lazy = false, -- lazy loading handled internally
-- 	enabled = false,
-- 	-- optional: provides snippets for the snippet source
-- 	dependencies = "rafamadriz/friendly-snippets",
--
-- 	-- use a release tag to download pre-built binaries
-- 	version = "v0.*",
-- 	-- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
-- 	-- build = 'cargo build --release',
-- 	-- If you use nix, you can build from source using latest nightly rust with:
-- 	-- build = 'nix run .#build-plugin',
--
-- 	---@module 'blink.cmp'
-- 	---@type blink.cmp.Config
-- 	opts = {
-- 		-- 'default' for mappings similar to built-in completion
-- 		-- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
-- 		-- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
-- 		-- see the "default configuration" section below for full documentation on how to define
-- 		-- your own keymap.
-- 		keymap = {
-- 			["<C-k>"] = { "select_prev", "fallback" },
-- 			["<C-j>"] = { "select_next", "fallback" },
-- 			["<C-e>"] = { "hide", "fallback" },
-- 			["<CR>"] = { "accept", "fallback" },
-- 			["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
-- 			["<C-b>"] = { "scroll_documentation_up", "fallback" },
-- 			["<C-f>"] = { "scroll_documentation_down", "fallback" },
-- 		},
--
-- 		appearance = {
-- 			-- Sets the fallback highlight groups to nvim-cmp's highlight groups
-- 			-- Useful for when your theme doesn't support blink.cmp
-- 			-- will be removed in a future release
-- 			use_nvim_cmp_as_default = false,
-- 			-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
-- 			-- Adjusts spacing to ensure icons are aligned
-- 			nerd_font_variant = "mono",
--
-- 			kind_icons = {
-- 				Text = "  ",
-- 				Method = "  ",
-- 				Function = "  ",
-- 				Constructor = "  ",
--
-- 				Field = "  ",
-- 				Variable = "  ",
-- 				Property = "  ",
--
-- 				Class = "  ",
-- 				Interface = "  ",
-- 				Struct = "  ",
-- 				Module = "  ",
--
-- 				Unit = "  ",
-- 				Value = "  ",
-- 				Enum = "  ",
-- 				EnumMember = "  ",
--
-- 				Keyword = "  ",
-- 				Constant = "  ",
--
-- 				Snippet = "  ",
-- 				Color = "  ",
-- 				File = "  ",
-- 				Reference = "  ",
-- 				Folder = "  ",
-- 				Event = "  ",
-- 				Operator = "  ",
-- 				TypeParameter = "  ",
-- 			},
-- 		},
--
-- 		-- default list of enabled providers defined so that you can extend it
-- 		-- elsewhere in your config, without redefining it, via `opts_extend`
-- 		sources = {
-- 			completion = {
-- 				enabled_providers = { "lsp", "path", "snippets", "buffer" },
-- 			},
-- 		},
-- 	},
-- 	-- allows extending the enabled_providers array elsewhere in your config
-- 	-- without having to redefine it
-- 	opts_extend = { "sources.completion.enabled_providers" },
-- }
--
-- -- keymap = {
-- -- 	["<C-k>"] = { "select_prev", "fallback" },
-- -- 	["<C-j>"] = { "select_next", "fallback" },
-- -- 	["<C-e>"] = { "hide", "fallback" },
-- -- 	["<CR>"] = { "accept", "fallback" },
-- -- 	["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
-- -- 	["<C-b>"] = { "scroll_documentation_up", "fallback" },
-- -- 	["<C-f>"] = { "scroll_documentation_down", "fallback" },
-- -- },
-- --
-- -- completion = {
-- --
-- -- 	accept = {
-- -- 		-- Experimental auto-brackets support
-- -- 		auto_brackets = {
-- -- 			-- Whether to auto-insert brackets for functions
-- -- 			enabled = true,
-- -- 		},
-- -- 	},
-- --
-- -- 	menu = {
-- -- 		min_width = 15,
-- -- 		max_height = 10,
-- -- 		border = "rounded",
-- -- 		winblend = 0,
-- -- 		winhighlight = "Pmenu:BlinkCmpMenu,FloatBorder:FloatBorder",
-- --
-- -- 		-- Keep the cursor X lines away from the top/bottom of the window
-- -- 		scrolloff = 2,
-- -- 		-- Note that the gutter will be disabled when border ~= 'none'
-- -- 		scrollbar = true,
-- -- 		-- Which directions to show the window,
-- -- 		-- falling back to the next direction when there's not enough space
-- -- 		direction_priority = { "s", "n" },
-- -- 		-- Controls how the completion items are rendered on the popup window
-- -- 		draw = {
-- -- 			-- Aligns the keyword you've typed to a component in the menu
-- -- 			align_to_component = "label", -- or 'none' to disable
-- -- 			-- Left and right padding, optionally { left, right } for different padding on each side
-- -- 			padding = 1,
-- -- 			-- Gap between columns
-- -- 			gap = 1,
-- --
-- -- 			-- Components to render, grouped by column
-- -- 			columns = { { "kind_icon" }, { "label" } },
-- -- 			-- for a setup similar to nvim-cmp: https://github.com/Saghen/blink.cmp/pull/245#issuecomment-2463659508
-- -- 			-- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
-- -- 		},
-- -- 	},
-- --
-- -- 	documentation = {
-- -- 		-- Whether to use treesitter highlighting, disable if you run into performance issues
-- -- 		treesitter_highlighting = true,
-- -- 		window = {
-- -- 			min_width = 10,
-- -- 			max_width = 120,
-- -- 			max_height = 40,
-- -- 			border = "rounded",
-- -- 			winblend = vim.o.pumblend,
-- -- 			winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
-- -- 			scrollbar = true,
-- -- 			direction_priority = {
-- -- 				autocomplete_north = { "e", "w", "n", "s" },
-- -- 				autocomplete_south = { "e", "w", "s", "n" },
-- -- 			},
-- -- 		},
-- -- 	},
-- -- 	-- Displays a preview of the selected item on the current line
-- -- 	ghost_text = {
-- -- 		enabled = true,
-- -- 	},
-- -- },
-- --
-- -- -- Experimental signature help support
-- -- signature = {
-- -- 	enabled = false,
-- -- 	trigger = {
-- -- 		blocked_trigger_characters = {},
-- -- 		blocked_retrigger_characters = {},
-- -- 		-- When true, will show the signature help window when the cursor comes after a trigger character when entering insert mode
-- -- 		show_on_insert_on_trigger_character = true,
-- -- 	},
-- -- 	window = {
-- -- 		min_width = 1,
-- -- 		max_width = 100,
-- -- 		max_height = 10,
-- -- 		border = "padded",
-- -- 		winblend = 0,
-- -- 		winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
-- -- 		scrollbar = false, -- Note that the gutter will be disabled when border ~= 'none'
-- -- 		-- Which directions to show the window,
-- -- 		-- falling back to the next direction when there's not enough space,
-- -- 		-- or another window is in the way
-- -- 		direction_priority = { "n", "s" },
-- -- 		-- Disable if you run into performance issues
-- -- 		treesitter_highlighting = true,
-- -- 	},
-- -- },
-- -- sources = {
-- -- 	completion = {
-- -- 		-- Static list of providers to enable, or a function to dynamically enable/disable providers based on the context
-- -- 		enabled_providers = { "lsp", "path", "snippets", "buffer" },
-- -- 	},
-- -- },
-- -- appearance = {
-- -- 	highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
-- -- 	-- Sets the fallback highlight groups to nvim-cmp's highlight groups
-- -- 	-- Useful for when your theme doesn't support blink.cmp
-- -- 	-- Will be removed in a future release
-- -- 	-- use_nvim_cmp_as_default = false,
-- -- 	-- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
-- -- 	-- Adjusts spacing to ensure icons are aligned
-- -- 	use_nvim_cmp_as_default = true,
-- -- 	nerd_font_variant = "normal",
-- -- 	kind_icons = {
-- -- 		Text = "  ",
-- -- 		Method = "  ",
-- -- 		Function = "  ",
-- -- 		Constructor = "  ",
-- -- 		Field = "  ",
-- -- 		Variable = "  ",
-- -- 		Class = "  ",
-- -- 		Interface = "  ",
-- -- 		Module = "  ",
-- -- 		Property = "  ",
-- -- 		Unit = "  ",
-- -- 		Value = "  ",
-- -- 		Enum = "  ",
-- -- 		Keyword = "  ",
-- -- 		Snippet = "  ",
-- -- 		Color = "  ",
-- -- 		File = "  ",
-- -- 		Reference = "  ",
-- -- 		Folder = "  ",
-- -- 		EnumMember = "  ",
-- -- 		Constant = "  ",
-- -- 		Struct = "  ",
-- -- 		Event = "  ",
-- -- 		Operator = "  ",
-- -- 		TypeParameter = "  ",
-- -- 	},
-- -- },
