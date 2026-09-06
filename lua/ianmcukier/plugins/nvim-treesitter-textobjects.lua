local function select(capture)
	return function()
		require("nvim-treesitter-textobjects.select").select_textobject(capture, "textobjects")
	end
end

local function move(direction, capture)
	return function()
		require("nvim-treesitter-textobjects.move")[direction](capture, "textobjects")
	end
end

return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "main",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		select = {
			lookahead = true,
			include_surrounding_whitespace = false,
		},
		move = {
			set_jumps = true,
		},
	},
	keys = {
		{ "af", select("@function.outer"), mode = { "x", "o" }, desc = "a function" },
		{ "if", select("@function.inner"), mode = { "x", "o" }, desc = "inner function" },
		{ "ac", select("@class.outer"), mode = { "x", "o" }, desc = "a class" },
		{ "ic", select("@class.inner"), mode = { "x", "o" }, desc = "inner class" },
		{ "aa", select("@parameter.outer"), mode = { "x", "o" }, desc = "a parameter" },
		{ "ia", select("@parameter.inner"), mode = { "x", "o" }, desc = "inner parameter" },
		{ "]f", move("goto_next_start", "@function.outer"), mode = { "n", "x", "o" }, desc = "Next function start" },
		{
			"[f",
			move("goto_previous_start", "@function.outer"),
			mode = { "n", "x", "o" },
			desc = "Previous function start",
		},
		{ "]F", move("goto_next_end", "@function.outer"), mode = { "n", "x", "o" }, desc = "Next function end" },
		{ "[F", move("goto_previous_end", "@function.outer"), mode = { "n", "x", "o" }, desc = "Previous function end" },
		{ "]]", move("goto_next_start", "@class.outer"), mode = { "n", "x", "o" }, desc = "Next class start" },
		{ "[[", move("goto_previous_start", "@class.outer"), mode = { "n", "x", "o" }, desc = "Previous class start" },
		{ "]a", move("goto_next_start", "@parameter.inner"), mode = { "n", "x", "o" }, desc = "Next parameter" },
		{ "[a", move("goto_previous_start", "@parameter.inner"), mode = { "n", "x", "o" }, desc = "Previous parameter" },
	},
}
