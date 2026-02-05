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

# Add Server-Specific Plugins (if installed via git clone)
if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    plugins+=(zsh-syntax-highlighting)
fi
if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    plugins+=(zsh-autosuggestions)
fi

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


# --- 5. Mac Loader ---
# If we are on a Mac (Darwin), load the heavy extras
if [[ "$(uname)" == "Darwin" ]] && [ -f "$HOME/dotfiles/term/mac_specific.zsh" ]; then
    source "$HOME/dotfiles/term/mac_specific.zsh"
fi

# Force clean exit code
true
