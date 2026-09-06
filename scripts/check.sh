#!/usr/bin/env bash
# Acceptance checks for this Neovim config. Run from anywhere; exits non-zero on the first failure.
# Run it before committing and after every Neovim upgrade.
set -euo pipefail
cd "$(dirname "$0")/.."

STARTUP_BUDGET_MS="${STARTUP_BUDGET_MS:-150}"
STYLUA="${STYLUA:-$HOME/.local/share/nvim/mason/bin/stylua}"

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "ok: $*"; }

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

# --- version ---------------------------------------------------------------
ver="$(nvim --version | head -1 | sed -E 's/^NVIM v([0-9]+\.[0-9]+).*/\1/')"
[ "$(printf '%s\n%s\n' 0.12 "$ver" | sort -V | head -1)" = "0.12" ] || fail "nvim $ver < 0.12"
pass "nvim $ver"

# --- tree -------------------------------------------------------------------
[ -z "$(grep -rn $'^\tenabled = false' lua/ || true)" ] || fail "disabled spec present -- delete it, git history is the archive"
pass "no disabled specs"

[ ! -d lua/ianmcukier/plugins/lsp ] || fail "plugins/lsp still exists"
# Identity, not just cardinality: a botched rename that drops one file and adds another
# keeps the count at 27 and would otherwise pass. One name per plugin family.
expected_plugins="blink-cmp catppuccin claudecode conform diffview gitsigns helpview
log-highlight lualine markdown-preview mason neotest nvim-bqf nvim-lspconfig nvim-surround
nvim-treesitter render-markdown sidekick snacks todo-comments trouble vim-dadbod-ui
vim-projectionist vim-tmux-navigator vim-togglelist vim-wordmotion which-key"
diff <(printf '%s\n' $expected_plugins | sort) \
     <(basename -s .lua -a lua/ianmcukier/plugins/*.lua | sort) \
  || fail "plugin set differs from expected ('<' missing, '>' unexpected)"
pass "27 plugin files, names match"

# --- forbidden strings -------------------------------------------------------
pat='require\("notify"\)|telescope|noice|alpha-nvim|require\("alpha"|avante|mcphub|vim\.highlight|~/\.config/nvim'
grep -rnE "$pat" lua/ && fail "reference to a removed plugin or deprecated API"
pass "no references to removed plugins"

# convention violations: which-key groups belong in which-key.lua opts.spec, and config is Lua
pat='which-key"\)\.add|vim\.cmd\("(let|autocmd)|vim\.cmd\(\[\[autocmd'
grep -rnE "$pat" lua/ && fail "convention violation"
pass "no convention violations"

# --- lock -------------------------------------------------------------------
for k in telescope.nvim telescope-fzf-native.nvim telescope-ui-select.nvim telescope-luasnip.nvim \
           telescope-simulators.nvim noice.nvim nui.nvim nvim-notify dressing.nvim alpha-nvim mcphub.nvim \
         blink-cmp-avante mini.nvim neotest-dart fzf project.nvim nvim-lsp-file-operations; do
  jq -e --arg k "$k" 'has($k)' lazy-lock.json >/dev/null && fail "lazy-lock.json still has $k"
done
pass "lock has no removed plugins"

jq -e '."nvim-treesitter".branch == "main"' lazy-lock.json >/dev/null || fail "nvim-treesitter not on main"
pass "treesitter on main"

# --- tracked files -----------------------------------------------------------
git ls-files --error-unmatch lazy-lock.json >/dev/null 2>&1 || fail "lazy-lock.json not tracked"
git ls-files | grep -q '\.DS_Store' && fail ".DS_Store tracked"
for f in stylua.toml scripts/check.sh lsp/lua_ls.lua lua/ianmcukier/core/diagnostics.lua; do
  git ls-files --error-unmatch "$f" >/dev/null 2>&1 || fail "$f not tracked"
done
pass "tracked files"

# --- stylua -----------------------------------------------------------------
# mason-tool-installer fetches stylua asynchronously, so on a fresh clone this binary
# can still be missing after the first nvim launch. Say so, instead of dying on ENOENT.
[ -x "$STYLUA" ] || fail "stylua not found at $STYLUA -- let mason finish (:MasonToolsInstall) and retry"
"$STYLUA" --check . || fail "stylua --check"
pass "stylua"

# --- headless startup must be silent ---------------------------------------------------
err="$(nvim --headless +qa 2>&1 | grep -v '^\[ClaudeCode\]' || true)"
[ -z "$err" ] || fail "startup output: $err"
pass "headless startup silent"

# --- startup time ----------------------------------------------------------------
nvim --headless --startuptime "$TMP/st.log" +qa >/dev/null 2>&1
ms="$(awk '/NVIM STARTED/ { print int($1) }' "$TMP/st.log" | tail -1)"
[ -n "$ms" ] || fail "no 'NVIM STARTED' line in $TMP/st.log -- could not measure startup"
[ "$ms" -le "$STARTUP_BUDGET_MS" ] || fail "startup ${ms}ms > ${STARTUP_BUDGET_MS}ms"
pass "startup ${ms}ms"

# --- in-editor probe: duplicate keymaps, diagnostic signs, deprecations -------------
cat >"$TMP/probe.lua" <<'EOF'
local out = {}
for _, mode in ipairs({ "n", "v", "x", "i" }) do
  local seen = {}
  for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do
    if seen[m.lhs] then table.insert(out, "DUP " .. mode .. " " .. m.lhs) end
    seen[m.lhs] = true
  end
end
local s = vim.diagnostic.config().signs.text
if s[vim.diagnostic.severity.INFO] ~= "󰠠" then table.insert(out, "SIGN INFO wrong") end
if s[vim.diagnostic.severity.HINT] ~= "" then table.insert(out, "SIGN HINT wrong") end
if vim.o.winborder ~= "rounded" then table.insert(out, "winborder=" .. tostring(vim.o.winborder)) end
if vim.o.pumborder ~= "rounded" then table.insert(out, "pumborder=" .. tostring(vim.o.pumborder)) end
-- settings live in lsp/lua_ls.lua and are merged by Neovim; assert the merge, not the file
local globals = vim.tbl_get(vim.lsp.config["lua_ls"] or {}, "settings", "Lua", "diagnostics", "globals")
if type(globals) ~= "table" or not vim.tbl_contains(globals, "vim") then
  table.insert(out, "lua_ls globals not merged: " .. vim.inspect(globals))
end
-- nvim_get_keymap returns ONLY global maps, so the dedup above is blind to a plugin
-- shadowing a global lhs in one buffer -- exactly how <leader>hp was double-bound
-- (gitsigns preview-hunk buffer-local vs the global PR picker) before this cleanup.
local function bufmaps(buf, mode)
  local t = {}
  for _, m in ipairs(vim.api.nvim_buf_get_keymap(buf, mode)) do t[m.lhs] = true end
  return t
end
vim.cmd.edit("lua/ianmcukier/core/options.lua")
local buf = vim.api.nvim_get_current_buf()
if not vim.wait(15000, function() return bufmaps(buf, "n")["]h"] ~= nil end, 100) then
  table.insert(out, "BUFMAPS gitsigns never attached in a tracked buffer")
else
  -- lua_ls is a mason binary and may be missing on a fresh machine: non-fatal, but a
  -- silent skip would mean the LSP half of the keymap surface went unchecked unannounced
  if not vim.wait(10000, function() return bufmaps(buf, "n")[vim.g.mapleader .. "d"] ~= nil end, 100) then
    vim.fn.writefile({ "lua_ls did not attach: LSP buffer-local maps were NOT shadow-checked" }, vim.env.PROBE_NOTES)
  end
  for _, mode in ipairs({ "n", "v", "x", "i", "o" }) do
    local g = {}
    for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do g[m.lhs] = true end
    for _, m in ipairs(vim.api.nvim_buf_get_keymap(buf, mode)) do
      if g[m.lhs] then table.insert(out, "SHADOW " .. mode .. " " .. m.lhs) end
    end
  end
end
vim.cmd("normal! yy")
-- The filetypes this config expects treesitter highlighting and indentation in. Listed here rather
-- than derived from the plugin spec: an acceptance check that reads its expectation out of the code
-- under test asserts nothing. Between them these cover 24 of the 27 parsers.
for _, ft in ipairs({
  "go", "gomod", "gosum", "gowork", "lua", "typescript", "typescriptreact", "javascript",
  "sql", "markdown", "help", "json", "yaml", "html", "css", "sh", "vim", "query",
  "dockerfile", "gitignore", "c", "python", "terraform", "prisma",
}) do
  vim.cmd("enew")
  vim.bo.filetype = ft
  local b = vim.api.nvim_get_current_buf()
  if not vim.treesitter.highlighter.active[b] then
    table.insert(out, "NOHIGHLIGHT " .. ft)
  elseif vim.bo[b].indentexpr == "" then
    table.insert(out, "NOINDENTEXPR " .. ft)
  end
end
-- the remaining 3 parsers are injected into other languages and have no filetype of their own.
  -- "parsers" is required: a bare get_installed() unions in the queries dir, which outlives the .so
local installed = {}
for _, lang in ipairs(require("nvim-treesitter").get_installed("parsers")) do installed[lang] = true end
for _, lang in ipairs({ "markdown_inline", "luadoc", "regex" }) do
  if not installed[lang] then table.insert(out, "NOPARSER " .. lang) end
end
vim.cmd("checkhealth vim.deprecated")
local health = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
if not health:find("No deprecated functions detected", 1, true) then table.insert(out, "DEPRECATED:\n" .. health) end
vim.fn.writefile(out, vim.env.PROBE_OUT)
vim.cmd("qa!")
EOF
PROBE_OUT="$TMP/probe.out" PROBE_FILE="$TMP/probe.lua" PROBE_NOTES="$TMP/probe.notes" \
  nvim --headless -c "lua vim.schedule(function() dofile(vim.env.PROBE_FILE) end)" >/dev/null 2>&1 || true
[ -f "$TMP/probe.out" ] || fail "probe did not run"
[ ! -s "$TMP/probe.out" ] || fail "probe: $(cat "$TMP/probe.out")"
[ ! -s "$TMP/probe.notes" ] || while IFS= read -r n; do echo "note: $n"; done < "$TMP/probe.notes"
pass "keymaps unique (global + buffer-local), signs correct, parsers active, borders set, no deprecations"

echo "ALL CHECKS PASSED"
