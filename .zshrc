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
# Respects sticky titles set via `tab` command; falls back to current dir
precmd() {
    if [[ -n "$__ITERM_STICKY_TITLE" ]]; then
        echo -ne "\e]1;${__ITERM_STICKY_TITLE}\a"
    else
        echo -ne "\e]1;${PWD##*/}\a"
    fi
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


# --- 5. Mac Loader ---
# If we are on a Mac (Darwin), load the heavy extras
if [[ "$(uname)" == "Darwin" ]] && [ -f "$HOME/dotfiles/term/mac_specific.zsh" ]; then
    source "$HOME/dotfiles/term/mac_specific.zsh"
fi

# --- 6. Claude Mode Commands ---
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

# Ensure Claude PARA symlinks exist (dotsync2 can't sync folder symlinks)
# Only runs if gdrive is mounted and targets exist
if [ -d "$CLAUDE_CODING_DIR" ]; then
  [[ -L "$HOME/.claude/CLAUDE.md" ]] || ln -sfn "$CLAUDE_CODING_DIR/CLAUDE.md" "$HOME/.claude/CLAUDE.md" 2>/dev/null
  [[ -L "$HOME/.claude/plans" ]]    || ln -sfn "$CLAUDE_CODING_DIR/plans" "$HOME/.claude/plans" 2>/dev/null
fi

para() {
  if [ ! -d "$CLAUDE_PARA_DIR" ]; then
    echo "Error: Google Drive not mounted at $CLAUDE_PARA_DIR"
    echo "Run: /gdrive-setup or mount manually"
    return 1
  fi
  cd "$CLAUDE_PARA_DIR" && claude "$@"
}

ccoding() {
  if [ ! -d "$CLAUDE_CODING_DIR" ]; then
    echo "Error: Coding context not found at $CLAUDE_CODING_DIR"
    echo "Is Google Drive mounted?"
    return 1
  fi
  cd "$CLAUDE_CODING_DIR" && claude "$@"
}

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
