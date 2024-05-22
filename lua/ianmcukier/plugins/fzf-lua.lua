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
        -- cwd = vim.loop.cwd(),
      }
    })
    -- Searches
    vim.keymap.set("n", "<leader>sf", fzf.files, { desc = 'Search Files' })
    vim.keymap.set("n", "<leader>sg", fzf.live_grep, { desc = 'Search Grep' })
    vim.keymap.set("n", "<leader>sw", fzf.grep_cword, { desc = 'Search Word' })
    vim.keymap.set("n", "<leader><leader>", fzf.buffers, { desc = 'Search open buffers' })
    vim.keymap.set("n", "<leader>s.", fzf.oldfiles, { desc = 'Search Recent Files ("." for repeat)' })
    vim.keymap.set("v", "<leader>sw", fzf.grep_visual, { desc = 'Search Word' })
    -- Resume searches
    vim.keymap.set("n", "<leader>srg", fzf.live_grep_resume, { noremap = true, desc = 'Search Resume Grep' })
    vim.keymap.set("n", "<leader>srw", fzf.grep_last, { desc = 'Search Resume Word' })
    vim.keymap.set("n", "<leader>srr", fzf.resume, { desc = 'Search Resume' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set("n", "<leader>sn", function()
      fzf.files({ cwd = vim.fn.stdpath("config") })
    end, { desc = "Search Neovim files" }) -- Slightly advanced example of overriding default behavior and theme
    vim.keymap.set("n", "<leader>/", fzf.lgrep_curbuf, { desc = "Search in current buffer" })
  end
}
