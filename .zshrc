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

# SSH Settings
# Hides user@hostname in the prompt if you are logged in via SSH
[[ -n "$SSH_CLIENT" ]] || export DEFAULT_USER="adambiglow"

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

# --- 5. Claude Mode Commands ---
# - claude (from fbsource): Lean coding mode (default)
# - para: Strategy mode (full PARA context)
# - ccoding: Coding conventions context (for planning implementations)
#
# Gdrive path differs by platform:
#   OD:  ~/gdrive/
#   Mac: ~/Library/CloudStorage/GoogleDrive-adambiglow@meta.com/My Drive/claude/
if [[ "$(uname)" == "Darwin" ]]; then
  CLAUDE_PARA_DIR="$HOME/Library/CloudStorage/GoogleDrive-adambiglow@meta.com/My Drive/claude"
else
  CLAUDE_PARA_DIR="$HOME/gdrive"
fi
CLAUDE_CODING_DIR="$CLAUDE_PARA_DIR/03_resources/coding"

# Ensure Claude PARA symlinks exist (called lazily, not at load time)
_ensure_para_symlinks() {
  if [ -d "$CLAUDE_CODING_DIR" ]; then
    [[ -L "$HOME/.claude/CLAUDE.md" ]] || ln -sfn "$CLAUDE_CODING_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md" 2>/dev/null
    [[ -L "$HOME/.claude/plans" ]]    || ln -sfn "$CLAUDE_CODING_DIR/plans" "$HOME/.claude/plans" 2>/dev/null
  fi
}

# Try symlinks eagerly (instant, no-op if mount isn't ready yet)
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

para() {
  _ensure_gdrive_mount || return 1

  if [[ ! -d "$CLAUDE_PARA_DIR" ]] || ! timeout 3 ls "$CLAUDE_PARA_DIR" >/dev/null 2>&1; then
    echo "Error: Google Drive not mounted or not responding at $CLAUDE_PARA_DIR"
    echo "Try: fusermount -uz ~/gdrive && bash ~/bin/gdrive-mount.sh"
    return 1
  fi
  _ensure_para_symlinks
  cd "$CLAUDE_PARA_DIR" && claude "$@"
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

  claude "$@"
}

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
