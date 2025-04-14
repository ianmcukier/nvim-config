return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
	opts = {
		-- add any opts here
		-- for example
		provider = "deepseek_openrouter",

		auto_suggestions_provider = "claude-haiku", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
		claude = {
			endpoint = "https://api.anthropic.com",
			model = "claude-3-7-sonnet-20250219",
			timeout = 30000, -- timeout in milliseconds
			temperature = 0, -- adjust if needed
			max_tokens = 8000,
			disable_tools = false, -- disable tools!
			-- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
		},

		vendors = {
			llama4_openrouter = {
				__inherited_from = "openai",
				disable_tools = true,
				endpoint = "https://openrouter.ai/api/v1",
				api_key_name = "OPENROUTER_API_KEY",
				model = "meta-llama/llama-4-maverick:free",
			},
			deepseek_openrouter = {
				__inherited_from = "openai",
				disable_tools = true,
				endpoint = "https://openrouter.ai/api/v1",
				api_key_name = "OPENROUTER_API_KEY",
				model = "deepseek/deepseek-chat-v3-0324:free",
			},
		},
		disabled_tools = {
			"list_files",
			"search_files",
			"read_file",
			"create_file",
			"rename_file",
			"delete_file",
			"create_dir",
			"rename_dir",
			"delete_dir",
			"bash",
		},

		rag_service = {
			enabled = false, -- Enables the RAG service
			host_mount = vim.fn.getcwd(), -- Host mount path for the rag service
			provider = "llama4_openrouter", -- The provider to use for RAG service (e.g. openai or ollama)
			-- llm_model = "", -- The LLM model to use for RAG service
			-- embed_model = "", -- The embedding model to use for RAG service
			-- endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
		},

		file_selector = { provider = "snacks" },

		windows = {
			input = {
				prefix = "> ",
				height = 10, -- Height of the input window in vertical layout
			},
			ask = {
				floating = false, -- Open the 'AvanteAsk' prompt in a floating window
				start_insert = false, -- Start insert mode when opening the ask window
			},
		},

		mappings = {
			--- @class AvanteConflictMappings
			diff = {
				ours = "co",
				theirs = "ct",
				all_theirs = "ca",
				both = "cb",
				cursor = "cc",
				next = "]x",
				prev = "[x",
			},
			suggestion = {
				accept = "<M-l>",
				next = "<M-]>",
				prev = "<M-[>",
				dismiss = "<C-]>",
			},
			jump = {
				next = "]]",
				prev = "[[",
			},
			submit = {
				normal = "<CR>",
				insert = "<C-s>",
			},
			sidebar = {
				apply_all = "A",
				apply_cursor = "a",
				retry_user_request = "r",
				edit_user_request = "e",
				switch_windows = "<Tab>",
				reverse_switch_windows = "<S-Tab>",
				remove_file = "d",
				add_file = "@",
				close = { "<Esc>", "q" },
				close_from_input = nil, -- e.g., { normal = "<Esc>", insert = "<C-d>" }
			},
		},

		behaviour = {
			auto_suggestions = false, -- Experimental stage
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = false,
			minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
			enable_token_counting = true, -- Whether to enable token counting. Default to true.
			enable_cursor_planning_mode = true, -- Whether to enable Cursor Planning Mode. Default to false.
		},

		system_prompt = function()
			local hub = require("mcphub").get_hub_instance()

			return hub:get_active_servers_prompt()
		end,
		-- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
		custom_tools = function()
			return {
				require("mcphub.extensions.avante").mcp_tool(),
			}
		end,
	},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"folke/snacks.nvim",
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"ravitemer/mcphub.nvim",
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
