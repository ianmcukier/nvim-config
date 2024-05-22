return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "NiamhFerns/project.nvim",
    "benfowler/telescope-luasnip.nvim",
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
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("flutter")
    telescope.load_extension("projects")
    telescope.load_extension("luasnip")

    -- set keymaps
    require("which-key").register({
      ["<leader>s"] = {
        name = "Search"
      }
    })
    local keymap = vim.keymap -- for conciseness

    local builtin = require("telescope.builtin")
    keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Search Help" })
    keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "Search Keymaps" })
    keymap.set("n", "<leader>st", builtin.builtin, { desc = "Search Telescope" })
    keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Search Diagnostics" })
    keymap.set("n", "<leader>sl", telescope.extensions.flutter.commands, { desc = "Search Flutter commands" })
    keymap.set("n", "<leader>sp", telescope.extensions.projects.projects, { desc = "Search Projects" })
    keymap.set("n", "<leader>ss", telescope.extensions.luasnip.luasnip, { desc = "Search Snippets" })
  end,
}
