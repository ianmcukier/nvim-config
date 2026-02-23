return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	enabled = false,
	build = "make",
	version = false, -- Never set this value to "*"! Never!
	---@module 'avante'
	---@type avante.Config- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
	opts = {
		-- add any opts here
		-- for example
		mode = "legacy",

		provider = "claude",
		providers = {
			claude = {
				endpoint = "https://api.anthropic.com",
				model = "claude-sonnet-4-20250514",
				timeout = 30000, -- Timeout in milliseconds
				extra_request_body = {
					temperature = 0.75,
					max_tokens = 20480,
				},
			},
		},

		-- vendors = {
		-- 	llama4_openrouter = {
		-- 		__inherited_from = "openai",
		-- 		disable_tools = true,
		-- 		endpoint = "https://openrouter.ai/api/v1",
		-- 		api_key_name = "OPENROUTER_API_KEY",
		-- 		model = "meta-llama/llama-4-maverick:free",
		-- 	},
		-- 	deepseek_openrouter = {
		-- 		__inherited_from = "openai",
		-- 		disable_tools = true,
		-- 		endpoint = "https://openrouter.ai/api/v1",
		-- 		api_key_name = "OPENROUTER_API_KEY",
		-- 		model = "deepseek/deepseek-chat-v3-0324:free",
		-- 	},
		-- },
		-- disabled_tools = {
		-- 	"list_files",
		-- 	"search_files",
		-- 	"read_file",
		-- 	"create_file",
		-- 	"rename_file",
		-- 	"delete_file",
		-- 	"create_dir",
		-- 	"rename_dir",
		-- 	"delete_dir",
		-- 	"bash",
		-- },
		--
		-- rag_service = {
		-- 	enabled = false, -- Enables the RAG service
		-- 	host_mount = vim.fn.getcwd(), -- Host mount path for the rag service
		-- 	provider = "llama4_openrouter", -- The provider to use for RAG service (e.g. openai or ollama)
		-- 	-- llm_model = "", -- The LLM model to use for RAG service
		-- 	-- embed_model = "", -- The embedding model to use for RAG service
		-- 	-- endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
		-- },

		selector = {
			--- @alias avante.SelectorProvider "native" | "fzf_lua" | "mini_pick" | "snacks" | "telescope" | fun(selector: avante.ui.Selector): nil
			--- @type avante.SelectorProvider
			provider = "snacks",
			-- Options override for custom providers
			provider_opts = {},
		},

		-- windows = {
		-- 	input = {
		-- 		prefix = "> ",
		-- 		height = 10, -- Height of the input window in vertical layout
		-- 	},
		-- 	ask = {
		-- 		floating = false, -- Open the 'AvanteAsk' prompt in a floating window
		-- 		start_insert = false, -- Start insert mode when opening the ask window
		-- 	},
		-- },

		-- mappings = {
		-- 	--- @class AvanteConflictMappings
		-- 	diff = {
		-- 		ours = "co",
		-- 		theirs = "ct",
		-- 		all_theirs = "ca",
		-- 		both = "cb",
		-- 		cursor = "cc",
		-- 		next = "]x",
		-- 		prev = "[x",
		-- 	},
		-- 	suggestion = {
		-- 		accept = "<Tab>",
		-- 		next = "<C-n>",
		-- 		prev = "<C-p>",
		-- 		dismiss = "<C-]>",
		-- 	},
		-- 	jump = {
		-- 		next = "]]",
		-- 		prev = "[[",
		-- 	},
		-- 	submit = {
		-- 		normal = "<CR>",
		-- 		insert = "<C-s>",
		-- 	},
		-- 	sidebar = {
		-- 		apply_all = "A",
		-- 		apply_cursor = "a",
		-- 		retry_user_request = "r",
		-- 		edit_user_request = "e",
		-- 		switch_windows = "<Tab>",
		-- 		reverse_switch_windows = "<S-Tab>",
		-- 		remove_file = "d",
		-- 		add_file = "@",
		-- 		close = { "<Esc>", "q" },
		-- 		close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
		-- 	},
		-- },
		--
		-- system_prompt = function()
		-- 	local hub = require("mcphub").get_hub_instance()
		--
		-- 	return hub:get_active_servers_prompt()
		-- end,
		-- -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
		-- custom_tools = function()
		-- 	return {
		-- 		require("mcphub.extensions.avante").mcp_tool(),
		-- 	}
		-- end,
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"echasnovski/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
		"ibhagwan/fzf-lua", -- for file_selector provider fzf
		"stevearc/dressing.nvim", -- for input provider dressing
		"folke/snacks.nvim", -- for input provider snacks
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for Windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
