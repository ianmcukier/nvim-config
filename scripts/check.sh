#!/usr/bin/env bash
# Acceptance checks for this Neovim config. Run from anywhere; exits non-zero on the first failure.
# PHASE gates checks that only hold after a given phase: A < B < C < D < F (default F = everything).
set -euo pipefail
cd "$(dirname "$0")/.."

PHASE="${PHASE:-F}"
STARTUP_BUDGET_MS="${STARTUP_BUDGET_MS:-150}"   # warm baseline on 2026-09-05: 85-90 ms; cold: 148 ms
STYLUA="${STYLUA:-$HOME/.local/share/nvim/mason/bin/stylua}"

phase_idx() { case "$1" in A) echo 0;; B) echo 1;; C) echo 2;; D) echo 3;; F|E) echo 4;; *) return 1;; esac; }
PHASE_IDX="$(phase_idx "$PHASE")" || { echo "FAIL: bad PHASE '$PHASE' (want A, B, C, D, F or E)" >&2; exit 2; }
after() { [ "$PHASE_IDX" -ge "$(phase_idx "$1")" ]; }
fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "ok: $*"; }

TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

# --- version ---------------------------------------------------------------
ver="$(nvim --version | head -1 | sed -E 's/^NVIM v([0-9]+\.[0-9]+).*/\1/')"
if after C; then
  [ "$(printf '%s\n%s\n' 0.12 "$ver" | sort -V | head -1)" = "0.12" ] || fail "nvim $ver < 0.12"
fi
pass "nvim $ver"

# --- tree -------------------------------------------------------------------
if after B; then
  [ -z "$(grep -rn $'^\tenabled = false' lua/ || true)" ] || fail "'enabled = false' still present"
  pass "no disabled specs"
fi
if after F; then
  [ ! -d lua/ianmcukier/plugins/lsp ] || fail "plugins/lsp still exists"
  n="$(ls lua/ianmcukier/plugins/*.lua | wc -l | tr -d ' ')"
  [ "$n" -eq 27 ] || fail "expected 27 plugin files, got $n"
  pass "27 plugin files"
fi

# --- forbidden strings -------------------------------------------------------
if after B; then
  pat='require\("notify"\)|telescope|noice|alpha-nvim|require\("alpha"|avante|mcphub|vim\.highlight|~/\.config/nvim'
  grep -rnE "$pat" lua/ && fail "forbidden string (phase B set)"
  pass "no phase-B forbidden strings"
fi
if after F; then
  pat='which-key"\)\.add|vim\.cmd\("(let|autocmd)|vim\.cmd\(\[\[autocmd'
  grep -rnE "$pat" lua/ && fail "forbidden string (phase F set)"
  pass "no phase-F forbidden strings"
fi

# --- lock -------------------------------------------------------------------
if after B; then
  for k in telescope.nvim telescope-fzf-native.nvim telescope-ui-select.nvim telescope-luasnip.nvim \
           telescope-simulators.nvim noice.nvim nui.nvim nvim-notify dressing.nvim alpha-nvim mcphub.nvim \
           blink-cmp-avante mini.nvim neotest-dart fzf project.nvim nvim-lsp-file-operations; do
    jq -e --arg k "$k" 'has($k)' lazy-lock.json >/dev/null && fail "lazy-lock.json still has $k"
  done
  pass "lock has no removed plugins"
fi
if after D; then
  jq -e '."nvim-treesitter".branch == "main"' lazy-lock.json >/dev/null || fail "nvim-treesitter not on main"
  pass "treesitter on main"
fi

# --- tracked files -----------------------------------------------------------
git ls-files --error-unmatch lazy-lock.json >/dev/null 2>&1 || fail "lazy-lock.json not tracked"
git ls-files | grep -q '\.DS_Store' && fail ".DS_Store tracked"
if after F; then
  for f in stylua.toml scripts/check.sh lsp/lua_ls.lua lua/ianmcukier/core/diagnostics.lua; do
    git ls-files --error-unmatch "$f" >/dev/null 2>&1 || fail "$f not tracked"
  done
fi
pass "tracked files"

# --- stylua -----------------------------------------------------------------
if after F; then
  "$STYLUA" --check . || fail "stylua --check"
  pass "stylua"
fi

# --- headless startup must be silent ---------------------------------------------------
# (Lazy commands print progress even with '!', so they run in the phase steps, not here.)
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
if vim.env.PROBE_SIGNS == "1" then
  local s = vim.diagnostic.config().signs.text
  if s[vim.diagnostic.severity.INFO] ~= "󰠠" then table.insert(out, "SIGN INFO wrong") end
  if s[vim.diagnostic.severity.HINT] ~= "" then table.insert(out, "SIGN HINT wrong") end
end
if vim.env.PROBE_BORDERS == "1" then
  if vim.o.winborder ~= "rounded" then table.insert(out, "winborder=" .. tostring(vim.o.winborder)) end
  if vim.o.pumborder ~= "rounded" then table.insert(out, "pumborder=" .. tostring(vim.o.pumborder)) end
end
if vim.env.PROBE_LUALS == "1" then
  -- settings live in lsp/lua_ls.lua and are merged by Neovim; assert the merge, not the file
  local globals = vim.tbl_get(vim.lsp.config["lua_ls"] or {}, "settings", "Lua", "diagnostics", "globals")
  if type(globals) ~= "table" or not vim.tbl_contains(globals, "vim") then
    table.insert(out, "lua_ls globals not merged: " .. vim.inspect(globals))
  end
end
if vim.env.PROBE_BUFMAPS == "1" then
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
  if vim.env.PROBE_PARSERS == "1" then
    local buf = vim.api.nvim_get_current_buf()
    if not vim.treesitter.highlighter.active[buf] then
      table.insert(out, "NOHIGHLIGHT " .. ft)
    elseif vim.bo[buf].indentexpr == "" then
      table.insert(out, "NOINDENTEXPR " .. ft)
    end
  end
end
if vim.env.PROBE_PARSERS == "1" then
  -- the remaining 3 parsers are injected into other languages and have no filetype of their own.
  -- "parsers" is required: a bare get_installed() unions in the queries dir, which outlives the .so
  local installed = {}
  for _, lang in ipairs(require("nvim-treesitter").get_installed("parsers")) do installed[lang] = true end
  for _, lang in ipairs({ "markdown_inline", "luadoc", "regex" }) do
    if not installed[lang] then table.insert(out, "NOPARSER " .. lang) end
  end
end
if vim.env.PROBE_DEPRECATED == "1" then
  vim.cmd("checkhealth vim.deprecated")
  local health = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
  if not health:find("No deprecated functions detected", 1, true) then table.insert(out, "DEPRECATED:\n" .. health) end
end
vim.fn.writefile(out, vim.env.PROBE_OUT)
vim.cmd("qa!")
EOF
signs=0; after B && signs=1              # sign swap and vim.highlight are fixed in B
deprecated=0; after D && deprecated=1    # nvim-treesitter master calls the deprecated vim.validate until D
parsers=0; after D && parsers=1          # parsers are installed by the treesitter main migration in D
bufmaps=0; after B && bufmaps=1          # the buffer-local vs global keymap conflicts are resolved in B
borders=0; after D && borders=1          # winborder/pumborder are set in D
luals=0; after F && luals=1              # lsp/lua_ls.lua lands in F
PROBE_SIGNS="$signs" PROBE_DEPRECATED="$deprecated" PROBE_PARSERS="$parsers" \
  PROBE_BUFMAPS="$bufmaps" PROBE_BORDERS="$borders" PROBE_LUALS="$luals" PROBE_OUT="$TMP/probe.out" \
  PROBE_FILE="$TMP/probe.lua" PROBE_NOTES="$TMP/probe.notes" \
  nvim --headless -c "lua vim.schedule(function() dofile(vim.env.PROBE_FILE) end)" >/dev/null 2>&1 || true
[ -f "$TMP/probe.out" ] || fail "probe did not run"
[ ! -s "$TMP/probe.out" ] || fail "probe: $(cat "$TMP/probe.out")"
[ ! -s "$TMP/probe.notes" ] || while IFS= read -r n; do echo "note: $n"; done < "$TMP/probe.notes"
pass "keymaps unique (global + buffer-local), signs correct, parsers active, borders set, no deprecations"

echo "ALL CHECKS PASSED (PHASE=$PHASE)"
