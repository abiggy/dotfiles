#!/bin/zsh
## --- Source External Configs ---
# Load common and work-specific configurations first
if [ -f "$HOME/dotfiles/term/term_common.sh" ]; then
    source "$HOME/dotfiles/term/term_common.sh"
fi

if [ -f "$HOME/dotfiles/term/fb_common.sh" ]; then
    source "$HOME/dotfiles/term/fb_common.sh"
fi

# --- Path Configuration ---
export BREW_HOME=/opt/homebrew
export PATH=$BREW_HOME/bin:$PATH

# --- Oh-My-Zsh Configuration ---
export ZSH=$HOME/.oh-my-zsh

# Colors
export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true

# Theme
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

# Display red dots whilst waiting for completion
COMPLETION_WAITING_DOTS="true"

# Plugins
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git vi-mode npm z)

source $ZSH/oh-my-zsh.sh

# --- Antigen (Syntax Highlighting) ---
if [ -f "$BREW_HOME/share/antigen/antigen.zsh" ]; then
    source $BREW_HOME/share/antigen/antigen.zsh
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen apply
fi

# --- SSH & User Settings ---
# Make sure this is name of computer to hide the name@computer in the PS
[[ -n "$SSH_CLIENT" ]] || export DEFAULT_USER="adambiglow"

# --- Functions & Aliases ---

function gpr {
    git push && open-pr "integration"
}

__reload_dotfiles() {
    # Resets PATH to system default to clear cruft before reloading
    PATH="$(command -p getconf PATH):/usr/local/bin"
    source ~/.zshrc
    cd . || return 1
}
alias refresh='__reload_dotfiles'


# --- Hooks (Tab Titles) ---
precmd() {
    # Sets the tab title to current dir name
    echo -ne "\e]1;${PWD##*/}\a"
}

# --- Final Integrations ---

# iTerm2 Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# FZF (Fuzzy Finder)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# AVN (Automatic Version Switching for Node)
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh"
