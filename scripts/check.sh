#!/usr/bin/env bash
# Acceptance checks for this Neovim config. Run from anywhere; exits non-zero on the first failure.
# PHASE gates checks that only hold after a given phase: A < B < C < D < F (default F = everything).
set -euo pipefail
cd "$(dirname "$0")/.."

PHASE="${PHASE:-F}"
STARTUP_BUDGET_MS="${STARTUP_BUDGET_MS:-150}"   # warm baseline on 2026-09-05: 85-90 ms; cold: 148 ms
STYLUA="${STYLUA:-$HOME/.local/share/nvim/mason/bin/stylua}"

phase_idx() { case "$1" in A) echo 0;; B) echo 1;; C) echo 2;; D) echo 3;; F) echo 4;; *) echo "bad PHASE $1" >&2; exit 2;; esac; }
after() { [ "$(phase_idx "$PHASE")" -ge "$(phase_idx "$1")" ]; }
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
ms="$(grep 'NVIM STARTED' "$TMP/st.log" | awk '{print int($1)}')"
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
vim.cmd("normal! yy")
for _, ft in ipairs({ "go", "lua", "typescript", "sql", "markdown", "help" }) do
  vim.cmd("enew")
  vim.bo.filetype = ft
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
PROBE_SIGNS="$signs" PROBE_DEPRECATED="$deprecated" PROBE_OUT="$TMP/probe.out" \
  nvim --headless -c "lua vim.schedule(function() dofile('$TMP/probe.lua') end)" >/dev/null 2>&1 || true
[ -f "$TMP/probe.out" ] || fail "probe did not run"
[ ! -s "$TMP/probe.out" ] || fail "probe: $(cat "$TMP/probe.out")"
pass "keymaps unique, signs correct, no deprecations"

echo "ALL CHECKS PASSED (PHASE=$PHASE)"
