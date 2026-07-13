#!/bin/zsh


# --- 2. Source Common Configs ---
if [ -f "$HOME/dotfiles/term/term_common.sh" ]; then
    source "$HOME/dotfiles/term/term_common.sh"
fi

if [ -f "$HOME/dotfiles/term/fb_common.sh" ]; then
    source "$HOME/dotfiles/term/fb_common.sh"
fi

# --- 2.5. tmux: refresh the forwarded SSH agent socket -------------------------
# Inside tmux, SSH_AUTH_SOCK is captured when the tmux SERVER first starts and
# goes stale on every reconnect — new panes/windows then inherit a dead socket.
# Pull the freshest value from the tmux session env (refreshed on each attach via
# update-environment) so agent-backed auth keeps working in long-lived sessions.
# NB: github pushes authenticate via the x509 WALLET cert (fbwallet_fetch + its
# renewal timer), NOT this socket — so this is general SSH-agent hygiene, not by
# itself the github 403 fix. See coding/references/git-troubleshooting.md §1.
if [ -n "$TMUX" ]; then
  eval "$(command tmux show-environment -s SSH_AUTH_SOCK 2>/dev/null)"
fi

# --- 3. Oh-My-Zsh Configuration ---
export ZSH=$HOME/.oh-my-zsh

# Colors
# Linux uses LS_COLORS, Mac uses LSCOLORS (defined in mac_specific)
if command -v dircolors > /dev/null; then
    eval "$(dircolors -b)"
fi
export CLICOLOR=true

# Force "Strict" sorting (Put dotfiles first, like Mac)
export LC_COLLATE=C

# Theme
ZSH_THEME="agnoster"

# Plugins
# Start with the basics safe for everywhere
plugins=(
  git
  vi-mode
  z
)

# Fallback: Force Vi mode even if plugins fail
bindkey -v

# Display red dots whilst waiting for completion
COMPLETION_WAITING_DOTS="true"

# Load OMZ
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    source $ZSH/oh-my-zsh.sh
fi

# --- 4. Universal Integrations ---

# FZF (Checks standard Linux/Mac paths)
if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    source /usr/share/doc/fzf/examples/completion.zsh
fi

# --- Prompt host segment: color-coded BY ENVIRONMENT (tmux-safe) ---
# agnoster hides user@host based on $SSH_CLIENT, which is UNSET inside tmux → the
# host wrongly vanishes on remote boxes worked via tmux (the original bug). Detect
# the environment with tmux-safe signals (uname / OnDemand marker / hostname) and
# give each a vivid color + icon, so a glance at the prompt tells you what kind of
# box a pane is on. Colors are xterm-256 codes — preview them with `spectrum_ls`.
#   🍎 Mac (local)   → 205 hot-pink
#   🖥  devserver     → 37  teal
#   ☁️ OnDemand      → 208 orange
#   💻 other remote  → 99  purple
# Tweak: change a color code / icon below. To HIDE on Mac instead of coloring it,
# set the Darwin branch to:  _show=0; export DEFAULT_USER="adambiglow"
_host="${HOST:-$(hostname)}"; _show=1; _sep=' '
if [[ "$(uname)" == "Darwin" ]]; then
  _bg=205; _fg=232;   _icon='🍎'                              # Mac (local)
elif [[ -f /etc/ondemand-whoami ]]; then
  _bg=208; _fg=black; _icon='☁️'                             # OnDemand (marker file)
else
  case "$_host" in
    *.od|*.od.*|*.ondemand*) _bg=208; _fg=black; _icon='☁️' ;;  # OnDemand
    devvm*|*.facebook.com)   _bg=37;  _fg=black; _icon='🖥'; _sep='  ' ;;  # devserver — teal (ramp: 44>38>37>30>23); 2 spaces — 🖥 renders narrow
    *)                       _bg=99;  _fg=white; _icon='💻' ;;  # other remote
  esac
fi
# Bake the resolved color/icon into prompt_context at definition time (so the temp
# vars can be unset without breaking later prompt renders).
# $_sep = gap between icon and host. Default 1 space (full-width 🍎/☁️ fill it); the
# narrow 🖥 desktop glyph gets 2 (set in the devserver branch above).
[[ "$_show" == 1 ]] && eval "prompt_context() { prompt_segment $_bg $_fg '${_icon}${_sep}%m' }"
unset _host _show _bg _fg _icon _sep

# --- Prompt path segment (Mac only): this iTerm's palette repaints ANSI 'blue'
# as pink, which melts into the pink host. Pin the dir segment to a fixed 256
# violet so it complements the pink instead. OD/devserver keep agnoster's default
# blue — their palettes render true-blue, which already looks great.
if [[ "$(uname)" == "Darwin" ]]; then
  AGNOSTER_DIR_BG=99    # violet #875fff (256-code → not subject to ANSI remap)
  AGNOSTER_DIR_FG=231   # bright white text for contrast on the violet
fi

# Tab Titles (Precmd hook)
precmd() {
    echo -ne "\e]1;${PWD##*/}\a"
}

# Reload Helper
__reload_dotfiles() {
    # Resets PATH to system default to clear cruft before reloading
    PATH="$(command -p getconf PATH):/usr/local/bin"
    source ~/.zshrc
    cd . || return 1
    echo "Config reloaded."
}
alias refresh='__reload_dotfiles'


# --- 4.5. Google Drive Auto-Mount (OD only) ---
if [[ "$(uname)" != "Darwin" ]]; then
  [[ -f "$HOME/.claude/gdrive-mount-scripts/auto-mount.sh" ]] && source "$HOME/.claude/gdrive-mount-scripts/auto-mount.sh"
  [[ -f "$HOME/.claude/gdrive-mount-scripts/vscode-workspace.sh" ]] && source "$HOME/.claude/gdrive-mount-scripts/vscode-workspace.sh"
fi

# --- 4.6. Node for Claude Code browser MCP (OD only) ---
# /usr/local/bin/node on devservers is v16; the browser MCP tool needs >= 20.
# Point NODE at fbsource's v24 wrapper (auto-picks linux-x64 / darwin-arm64 / etc).
# Mac has its own node via brew, no fbsource path — skip there.
if [[ "$(uname)" != "Darwin" ]]; then
  [[ -x "$HOME/fbsource/xplat/third-party/node/bin/node" ]] && \
    export NODE="$HOME/fbsource/xplat/third-party/node/bin/node"
fi

# --- 5. Claude Mode Commands ---
# - claude (from fbsource): Lean coding mode (default)
# - para: Strategy mode (full PARA context)
# - ccoding: Coding conventions context (for planning implementations)
#
# Gdrive path differs by platform:
#   OD:  ~/gdrive/claude  (mount is at GDrive root for team brain access)
#   Mac: ~/Library/CloudStorage/GoogleDrive-adambiglow@meta.com/My Drive/claude/
if [[ "$(uname)" == "Darwin" ]]; then
  CLAUDE_PARA_DIR="$HOME/Library/CloudStorage/GoogleDrive-adambiglow@meta.com/My Drive/claude"
else
  CLAUDE_PARA_DIR="$HOME/gdrive/claude"
fi
CLAUDE_CODING_DIR="$CLAUDE_PARA_DIR/03_resources/coding"

# Ensure Claude PARA symlinks exist
_ensure_para_symlinks() {
  # Skip if symlinks already exist (avoids hitting FUSE mount on every shell)
  [[ -L "$HOME/.claude/CLAUDE.md" && -L "$HOME/.claude/plans" ]] && return 0
  if [ -d "$CLAUDE_CODING_DIR" ]; then
    [[ -L "$HOME/.claude/CLAUDE.md" ]] || ln -sfn "$CLAUDE_CODING_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md" 2>/dev/null
    [[ -L "$HOME/.claude/plans" ]]    || ln -sfn "$CLAUDE_CODING_DIR/plans" "$HOME/.claude/plans" 2>/dev/null
  fi
}

# Try symlinks eagerly but only if needed (skips FUSE stat if symlinks exist)
_ensure_para_symlinks

# Mount helper for Linux ODs. Attempts mount once, no wait loop.
_ensure_gdrive_mount() {
  [[ "$(uname)" == "Darwin" ]] && return 0  # Mac uses Google Drive for Desktop
  if ! grep -qF " ${HOME}/gdrive fuse" /proc/mounts 2>/dev/null; then
    echo "Mounting Google Drive..."
    if [[ -f "$HOME/bin/gdrive-mount.sh" ]]; then
      bash "$HOME/bin/gdrive-mount.sh" 2>&1
    else
      echo "Error: ~/bin/gdrive-mount.sh not found."
      echo "Fix: run /gdrive-setup inside a plain 'claude' session."
      return 1
    fi
  fi
}

alias cdpara='cd "$CLAUDE_PARA_DIR"'
alias vimpara='vim "$CLAUDE_PARA_DIR"'

# zoo-status: one-glance state of the whole menagerie (🚦 Beacons + 📛 .URGENT sentinels),
# urgency-bucketed. Read-only. See 02_areas/ai_workflows/zoo-status.sh + zoo_protocol.md.
zoo-status() {
  local _z
  for _z in "${CLAUDE_PARA_DIR:-/nonexistent}/02_areas/ai_workflows/zoo-status.sh" \
            "$HOME/gdrive/claude/02_areas/ai_workflows/zoo-status.sh" \
            "$HOME/Library/CloudStorage/GoogleDrive-adambiglow@meta.com/My Drive/claude/02_areas/ai_workflows/zoo-status.sh"; do
    [ -f "$_z" ] && { bash "$_z" "$@"; return $?; }
  done
  echo "zoo-status: script not found"; return 1
}

# zoo-watch [seconds]: LIVE self-refreshing dashboard in this tab — re-renders every N
# seconds and rings the bell + flashes 🆕 when an animal newly needs you. Leave it up.
zoo-watch() {
  local _w
  for _w in "${CLAUDE_PARA_DIR:-/nonexistent}/02_areas/ai_workflows/zoo-watch.sh" \
            "$HOME/gdrive/claude/02_areas/ai_workflows/zoo-watch.sh" \
            "$HOME/Library/CloudStorage/GoogleDrive-adambiglow@meta.com/My Drive/claude/02_areas/ai_workflows/zoo-watch.sh"; do
    [ -f "$_w" ] && { bash "$_w" "$@"; return $?; }
  done
  echo "zoo-watch: script not found"; return 1
}

# Animal tab coloring (dispatch protocol): defines `animal`/`animal_label` to
# color+label the iTerm2 tab / tmux window. These live on gdrive, so if a shell
# starts BEFORE gdrive finishes mounting (first tab after PTO/reboot/token lapse),
# this init-time source silently no-ops → the functions stay undefined for the
# whole shell → `para <animal>` later launches with a BLANK title (no color/👑/
# name). Wrap it in a function so the launcher can RE-source on demand after the
# mount guard has already run. We deliberately do NOT touch/await the mount here —
# that's the gdrive-mount rabbit hole (see coding gdrive-mount-issue notes).
_source_animal_tab() {
  local _atab
  for _atab in "$CLAUDE_PARA_DIR/02_areas/ai_workflows/animal-tab.sh" \
               "$HOME/gdrive/claude/02_areas/ai_workflows/animal-tab.sh" \
               "$HOME/Library/CloudStorage/GoogleDrive-adambiglow@meta.com/My Drive/claude/02_areas/ai_workflows/animal-tab.sh"; do
    [ -f "$_atab" ] && { source "$_atab"; return 0; }
  done
  return 1
}
_source_animal_tab   # best-effort at shell init (no-op if gdrive not mounted yet)

# VSCode Remote window-title injector (dispatch protocol). Mirrors the animal name +
# color into the OD's window title bar so a `ccoding <animal>` session is identifiable
# at a glance — the VSCode analogue of the iTerm tab color. VSCode has no env-var/OSC
# title hook, so we merge into the Remote *Machine* settings.json, which VSCode watches
# and applies live. Machine scope = OD-wide → perfect for the one-animal-per-OD
# convention (no repo/workspace pollution). Reuses the single-source color map via
# animal_hex (in animal-tab.sh), so iTerm + VSCode never drift.
#   _vscode_animal_title inject "<title>" "<#hex>" "<#fg>" "<#fgdim>"
#   _vscode_animal_title reset
# Hard no-op unless inside a VSCode integrated terminal (clean on Mac native iTerm).
# Never crashes the launcher: missing python3 / absent or malformed JSON all fall
# through silently. The merge preserves every other settings key and snapshots a
# pristine baseline (settings.json.animalbak) on first inject so reset restores the
# exact Meta-managed defaults; reset is a true no-op when nothing was ever injected.
_vscode_animal_title() {
  [ -n "$VSCODE_IPC_HOOK_CLI" ] || [ "$TERM_PROGRAM" = "vscode" ] || return 0
  command -v python3 >/dev/null 2>&1 || return 0

  # Locate the Remote Machine settings.json. Meta's vscodefb uses ~/.vscode-remote;
  # vanilla Remote-SSH uses ~/.vscode-server; Cursor/insiders variants handled too.
  local _sf="" _d
  for _d in "$HOME/.vscode-remote/data/Machine" \
            "$HOME/.vscode-server/data/Machine" \
            "$HOME/.vscode-server-insiders/data/Machine" \
            "$HOME/.cursor-server/data/Machine"; do
    [ -d "$_d" ] || continue
    _sf="$_d/settings.json"; break
  done
  [ -n "$_sf" ] || return 0

  python3 - "$_sf" "${1:-reset}" "${2:-}" "${3:-}" "${4:-}" "${5:-}" <<'PYEOF' 2>/dev/null
import json, os, sys
sf, mode, label, hexc, fg, fgdim = (sys.argv[1:7] + [""] * 6)[:6]
BAK  = sf + ".animalbak"   # pristine (pre-animal) baseline, captured once
MARK = "_animalInjected"   # sentinel: file currently holds animal overrides

def load(path):
    try:
        with open(path) as f:
            return json.load(f)
    except Exception:
        return None

data = load(sf)
if not isinstance(data, dict):
    data = {}

if mode == "reset":
    base = load(BAK)
    if isinstance(base, dict):
        out = base
        try:
            os.remove(BAK)
        except Exception:
            pass
    elif MARK in data:
        out = {k: v for k, v in data.items() if k != MARK}
    else:
        sys.exit(0)  # already clean / never injected → leave the file untouched
else:
    # Pristine (pre-animal) config to derive from — captured once, so re-runs and
    # animal switches never stack prefixes or accumulate stale colors.
    pristine = data if MARK not in data else load(BAK)
    if not isinstance(pristine, dict):
        pristine = {}
    if MARK not in data and not os.path.exists(BAK):
        try:
            with open(BAK, "w") as f:
                json.dump(data, f, indent=2)
        except Exception:
            pass
    out = dict(data)  # preserve any keys Meta/devmate added since the snapshot
    # PREPEND the animal prefix to the PRISTINE title so the existing context
    # (${devmate:status}, OD/workspace, ${remoteName}) is preserved after it. Deriving
    # from pristine (not the current, possibly-prefixed title) keeps re-runs idempotent.
    base_title = pristine.get("window.title") or "${rootName}${separator}${remoteName}"
    out["window.title"] = label + "${separator}" + base_title
    out["window.titleSeparator"] = " · "  # so the whole title reads consistently
    cc = dict(pristine.get("workbench.colorCustomizations") or {})
    cc.update({
        "titleBar.activeBackground":      hexc,
        "titleBar.inactiveBackground":    hexc,
        "titleBar.activeForeground":      fg,
        "titleBar.inactiveForeground":    fgdim,
        "activityBar.background":         hexc,
        "activityBar.foreground":         fg,
        "activityBar.inactiveForeground": fgdim,
    })
    out["workbench.colorCustomizations"] = cc
    out[MARK] = label

try:
    tmp = sf + ".tmp"
    with open(tmp, "w") as f:
        json.dump(out, f, indent=2)
    os.replace(tmp, sf)
except Exception:
    pass
PYEOF
}

# Shared Claude launcher used by para/ccoding/teampara/claude48 so every entry
# point is identical: Opus 4.8 (1M ctx), latest build, effort uncapped so ultracode
# can engage (persisted default is xhigh + workflows via ~/.claude/settings.json),
# and permissions bypassed. Do NOT set --effort / CLAUDE_CODE_EFFORT_LEVEL here —
# pinning a tier blocks ultracode. Edit flags in ONE place: this function.
# Animals launch with --settings '{"ultracode": true}' (set in the animal branch
# below) so the auto-kickoff runs in ultracode = xhigh + dynamic workflow
# orchestration → a worker can fan out research subprocesses on turn 1, no manual
# /effort step. Bare `para`/`ccoding` (no animal) stay default; /effort in-session
# if you want ultracode there. (`--effort <tier>` is NOT used — it would block ultracode.)
_claude_launch() {
  # Optional leading animal name (dispatch protocol). When present it:
  #   1. colors the iTerm tab + sets a persistent title, AND
  #   2. if a dispatch file 00_inbox/dispatch/<name>.md exists AND no explicit
  #      prompt was given, AUTO-FEEDS a kickoff prompt so ONE command fully
  #      launches a worker (read your dispatch file + execute) — no manual paste.
  # Unaffected: bare `para`/`ccoding` (no animal), and `<mode> <animal> "prompt"`
  # (an explicit prompt always wins over the auto-kickoff).
  # Codename match is CASE-INSENSITIVE: lowercase the leading arg before matching
  # so `ccoding Ivory-Swan` works the same as `ccoding ivory-swan`. We only read
  # $1 (never rewrite $@), so bare `para`/`ccoding` and prompt-first calls are untouched.
  local _lc1=""; [ "$#" -gt 0 ] && _lc1="${1:l}"
  local _animal_matched=0
  case "$_lc1" in
    fire-tiger|blue-elephant|golden-hawk|shadow-wolf|jade-dragon|red-fox|steel-shark|stone-crab|copper-otter|cedar-beaver|ivory-swan|teal-owl|slate-badger|zookeeper|orc|zoo)
      _animal_matched=1
      # Self-heal the gdrive-mount startup race: if this shell started before
      # gdrive mounted, animal_label is undefined. Re-source now — para/ccoding
      # already waited for the mount, so the file is reachable by this point.
      command -v animal_label >/dev/null 2>&1 || _source_animal_tab || \
        echo "⚠️  ~/gdrive not mounted — animal tab color/title unavailable this session (reopen the tab once gdrive is up)." >&2
      command -v animal >/dev/null 2>&1 && animal "$_lc1"
      local _an="$_lc1"; shift
      local _label; _label="$(command -v animal_label >/dev/null 2>&1 && animal_label "$_an")"
      [ -z "$_label" ] && _label="$_an"   # never blank — fall back to the codename
      local _df _root=""
      for _df in "$HOME/gdrive/claude/00_inbox/dispatch/$_an.md" \
                 "${CLAUDE_PARA_DIR:-/nonexistent}/00_inbox/dispatch/$_an.md" \
                 "$HOME/Library/CloudStorage/GoogleDrive-adambiglow@meta.com/My Drive/claude/00_inbox/dispatch/$_an.md"; do
        [ -f "$_df" ] && { _root="${_df%/00_inbox/dispatch/*}"; break; }
      done
      # Session name = codename + a 1-2 word task tag from the dispatch file's
      # **Tab:** field, so the prompt box / tab title show WHAT the animal is on
      # (e.g. "🦅 Golden-Hawk · adampriorities"). Falls back to just the codename.
      local _title="$_label"
      if [ -n "$_root" ]; then
        local _tab; _tab="$(grep -m1 '^\*\*Tab:\*\*' "$_df" 2>/dev/null | sed -E 's/^\*\*Tab:\*\*[[:space:]]*//; s/[[:space:]]*$//')"
        [ -n "$_tab" ] && _title="$_label · $_tab"
      fi
      # Under tmux (e.g. iTerm -CC), the iTerm tab shows the tmux WINDOW name, not
      # the OSC title that `animal`/claude emit: tmux here runs with allow-rename
      # off (escape-sequence renames ignored) + automatic-rename on (every window
      # gets named after the running command → "claude"). A tmux *command* still
      # works, so force the window name to the animal title and pin it. No-op
      # outside tmux (Mac native iTerm tabs already get the title from `claude -n`).
      if [ -n "$TMUX" ]; then
        # Target THIS pane's window ($TMUX_PANE) — a bare rename-window hits the
        # client's *active* window, which may be a different tab and mislabels it.
        command tmux rename-window -t "$TMUX_PANE" "$_title" 2>/dev/null
        command tmux set-window-option -t "$TMUX_PANE" automatic-rename off 2>/dev/null
      fi
      # VSCode Remote: mirror the animal name + color into the OD window title bar
      # (no-op outside a VSCode integrated terminal / on Mac native iTerm). Reuses
      # the single-source color map via animal_hex so iTerm + VSCode never drift.
      if command -v _vscode_animal_title >/dev/null 2>&1 && command -v animal_hex >/dev/null 2>&1; then
        local _vhex _vfg _vfgdim
        read -r _vhex _vfg _vfgdim <<< "$(animal_hex "$_an")"
        [ -n "$_vhex" ] && _vscode_animal_title inject "$_title" "$_vhex" "$_vfg" "$_vfgdim"
      fi
      if [ "$#" -eq 0 ] && [ -n "$_root" ]; then
        # No explicit prompt + a dispatch file exists → auto-kickoff.
        local _kick="You are ${_label}, a dispatch worker. Badge this terminal first: bash \"$_root/02_areas/ai_workflows/animal-badge.sh\" $_an  — then read your dispatch file at $_df and execute it, keeping its Status updated at START / CHECKPOINT / END. If that file's Status shows the work is already finished (DONE / AWAITING REVIEW) or it has been archived, STOP and ask Adam instead of re-running."
        set -- --settings '{"ultracode": true}' -n "$_title" "$_kick"
      else
        set -- --settings '{"ultracode": true}' -n "$_title" "$@"
      fi
      ;;
  esac
  # Bare para/ccoding (no animal) in a VSCode terminal → clear any stale animal
  # title/color so a non-animal window isn't left themed from a prior session.
  [ "$_animal_matched" -eq 0 ] && command -v _vscode_animal_title >/dev/null 2>&1 && _vscode_animal_title reset
  unset CLAUDE_CODE_EFFORT_LEVEL CLAUDE_EFFORT
  CLAUDE_CODE_VERSION_OVERRIDE=latest \
  META_CLAUDE_CODE_RELEASE=latest \
  command claude --model 'claude-opus-4-8[1m]' --dangerously-skip-permissions "$@"
}

para() {
  _ensure_gdrive_mount || return 1

  if [[ ! -d "$CLAUDE_PARA_DIR" ]] || ! timeout 3 ls "$CLAUDE_PARA_DIR" >/dev/null 2>&1; then
    echo "Error: Google Drive not mounted or not responding at $CLAUDE_PARA_DIR"
    echo "Try: fusermount -uz ~/gdrive && bash ~/bin/gdrive-mount.sh"
    return 1
  fi
  _ensure_para_symlinks
  cd "$CLAUDE_PARA_DIR" && _claude_launch "$@"
}

ccoding() {
  # Ensure gdrive is mounted and ~/.claude/CLAUDE.md symlink resolves
  # BEFORE launching claude. Fails hard — never launches without context.
  local claude_md="$HOME/.claude/CLAUDE.md"

  _ensure_gdrive_mount || return 1
  _ensure_para_symlinks

  # Gate: symlink must resolve to a real file.
  if [[ ! -f "$claude_md" ]]; then
    echo ""
    echo "Error: $claude_md does not resolve."
    echo ""
    echo "Diagnostics:"
    ls -la "$claude_md" 2>&1 | sed 's/^/  /'
    if [[ "$(uname)" != "Darwin" ]]; then
      echo "  mount: $(grep -cF " ${HOME}/gdrive fuse" /proc/mounts 2>/dev/null || echo 0) fuse entries"
      timeout 3 ls "$HOME/gdrive/" >/dev/null 2>&1 && echo "  ls ~/gdrive/: OK" || echo "  ls ~/gdrive/: FAILED (mount may be stale)"
    fi
    echo ""
    echo "Try:"
    echo "  1. fusermount -uz ~/gdrive && bash ~/bin/gdrive-mount.sh"
    echo "  2. If token expired: mclone config reconnect gdrive"
    echo "  3. Or run 'claude' without context and use /gdrive-repair"
    return 1
  fi

  _claude_launch "$@"
}

# Team PARA — shared team context for Claude Code (Shared Drive)
if [[ "$(uname)" == "Darwin" ]]; then
  TEAM_PARA_DIR="$HOME/Library/CloudStorage/GoogleDrive-adambiglow@meta.com/Shared drives/🧠 Nonprofit Fundraising - Team Brain"
else
  TEAM_PARA_DIR="$HOME/gdrive-team"
fi

teampara() {
  if [ ! -d "$TEAM_PARA_DIR" ]; then
    echo "Error: Team PARA not found at $TEAM_PARA_DIR"
    echo "Add the shared Google Drive folder to your Drive first."
    return 1
  fi
  cd "$TEAM_PARA_DIR" && _claude_launch "$@"
}

# Bare entry point to the shared launcher (no PARA cd / mount guard).
# para/ccoding/teampara already route through _claude_launch too.
claude48() { _claude_launch "$@"; }

# --- 6. Mac Loader ---
# If we are on a Mac (Darwin), load the heavy extras
# Loads AFTER Claude commands so mac_specific.zsh can override (e.g. add tab labeling)
if [[ "$(uname)" == "Darwin" ]] && [ -f "$HOME/dotfiles/term/mac_specific.zsh" ]; then
    source "$HOME/dotfiles/term/mac_specific.zsh"
fi

# --- Finalize ---
# Load these LAST (Must be after FZF and all other plugins)

# 1. Auto Suggestions (Grey text completions)
if [ -f "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# 2. Syntax Highlighting (Must be the absolute final thing)
if [ -f "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
    source "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Force clean exit code
true
