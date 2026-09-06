---@diagnostic disable: missing-fields
return {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},

	version = "*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
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
			completion = {
				list = {
					selection = {
						preselect = false,
						auto_insert = false,
					},
				},
				menu = { auto_show = true },
			},
		},

		appearance = {
			use_nvim_cmp_as_default = false,
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
					preselect = false,
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
					scrollbar = true,
					winblend = 0,
				},
			},
			menu = {
				min_width = 10,
				max_height = 15,
				winblend = 0,
				winhighlight = "Pmenu:BlinkCmpMenu,FloatBorder:FloatBorder",
				draw = {
					align_to = "label", -- or 'none' to disable
					padding = 1,
					gap = 1,

					treesitter = { "lsp" },

					columns = { { "kind_icon" }, { "label" } },
				},
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
