---@diagnostic disable: missing-fields
return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"hrsh7th/cmp-cmdline",
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
	},
	config = function()
		local cmp = require("cmp")

		local luasnip = require("luasnip")

		local lspkind = require("lspkind")

		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,preview,noselect",
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ { name = "nvim_lsp" } },
				{ { name = "luasnip" } }, -- snippets
				{ { name = "buffer" } }, -- text within current buffer
				{ { name = "path" } }, -- file system paths
			}),
			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				format = lspkind.cmp_format({
					maxwidth = 50,
					ellipsis_char = "...",
				}),
			},
			sorting = {
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					cmp.config.compare.recently_used,
					cmp.config.compare.kind,
				},
			},
		})
		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline({
				["<C-k>"] = cmp.mapping({
					c = function(fallback)
						if cmp.visible() then
							return cmp.select_prev_item()
						end
						fallback()
					end,
				}),
				["<C-j>"] = cmp.mapping({
					c = function(fallback)
						if cmp.visible() then
							return cmp.select_next_item()
						end
						fallback()
					end,
				}), -- next suggestion
			}),
			sources = {
				{ name = "buffer" },
			},
		})

		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline({
				["<C-k>"] = cmp.mapping({
					c = function(fallback)
						if cmp.visible() then
							return cmp.select_prev_item()
						end
						fallback()
					end,
				}),
				["<C-j>"] = cmp.mapping({
					c = function(fallback)
						if cmp.visible() then
							return cmp.select_next_item()
						end
						fallback()
					end,
				}), -- next suggestion
			}),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
			}),
			formatting = {
				fields = { "abbr", "kind" },
				format = lspkind.cmp_format({
					mode = "symbol_text", -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
					maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
					before = function(_, vim_item)
						if vim_item.kind == "Variable" then
							vim_item.kind = ""
							return vim_item
						end
						-- just show the icon
						vim_item.kind = lspkind.symbolic(vim_item.kind) and lspkind.symbolic(vim_item.kind)
							or vim_item.kind
						return vim_item
					end,
				}),
			},
		})
	end,
}
