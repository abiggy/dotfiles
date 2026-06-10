#!/bin/zsh


# --- 2. Source Common Configs ---
if [ -f "$HOME/dotfiles/term/term_common.sh" ]; then
    source "$HOME/dotfiles/term/term_common.sh"
fi

if [ -f "$HOME/dotfiles/term/fb_common.sh" ]; then
    source "$HOME/dotfiles/term/fb_common.sh"
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
#   🖥  devserver     → 44  electric-teal
#   ☁️ OnDemand      → 208 orange
#   💻 other remote  → 99  purple
# Tweak: change a color code / icon below. To HIDE on Mac instead of coloring it,
# set the Darwin branch to:  _show=0; export DEFAULT_USER="adambiglow"
_host="${HOST:-$(hostname)}"; _show=1
if [[ "$(uname)" == "Darwin" ]]; then
  _bg=205; _fg=black; _icon='🍎'                              # Mac (local)
elif [[ -f /etc/ondemand-whoami ]]; then
  _bg=208; _fg=black; _icon='☁️'                             # OnDemand (marker file)
else
  case "$_host" in
    *.od|*.od.*|*.ondemand*) _bg=208; _fg=black; _icon='☁️' ;;  # OnDemand
    devvm*|*.facebook.com)   _bg=34;  _fg=black; _icon='🖥' ;;  # devserver — green (ramp: 46>40>34>28>22)
    *)                       _bg=99;  _fg=white; _icon='💻' ;;  # other remote
  esac
fi
# Bake the resolved color/icon into prompt_context at definition time (so the temp
# vars can be unset without breaking later prompt renders).
# Two spaces after the icon: wide emoji glyphs visually swallow a single space.
[[ "$_show" == 1 ]] && eval "prompt_context() { prompt_segment $_bg $_fg '${_icon}  %m' }"
unset _host _show _bg _fg _icon

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

# Animal tab coloring (dispatch protocol): defines `animal <name>` to color the
# iTerm2 tab. Sourced before the launcher so `para golden-hawk` can use it.
for _atab in "$CLAUDE_PARA_DIR/02_areas/ai_workflows/animal-tab.sh" \
             "$HOME/gdrive/claude/02_areas/ai_workflows/animal-tab.sh" \
             "$HOME/Library/CloudStorage/GoogleDrive-adambiglow@meta.com/My Drive/claude/02_areas/ai_workflows/animal-tab.sh"; do
  [ -f "$_atab" ] && { source "$_atab"; break; }
done; unset _atab

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
  case "$_lc1" in
    fire-tiger|blue-elephant|golden-hawk|shadow-wolf|jade-dragon|red-fox|steel-shark|stone-crab|copper-otter|cedar-beaver|ivory-swan|teal-owl|zookeeper|orc|zoo)
      animal "$_lc1"
      local _an="$_lc1"; shift
      local _label; _label="$(animal_label "$_an")"
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
      if [ "$#" -eq 0 ] && [ -n "$_root" ]; then
        # No explicit prompt + a dispatch file exists → auto-kickoff.
        local _kick="You are ${_label}, a dispatch worker. Badge this terminal first: bash \"$_root/02_areas/ai_workflows/animal-badge.sh\" $_an  — then read your dispatch file at $_df and execute it, keeping its Status updated at START / CHECKPOINT / END. If that file's Status shows the work is already finished (DONE / AWAITING REVIEW) or it has been archived, STOP and ask Adam instead of re-running."
        set -- --settings '{"ultracode": true}' -n "$_title" "$_kick"
      else
        set -- --settings '{"ultracode": true}' -n "$_title" "$@"
      fi
      ;;
  esac
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
