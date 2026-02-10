#!/bin/zsh

# --- Environment Variables ---
# Smart Editor Detection: Prefer nvim, fallback to vim
if command -v nvim > /dev/null; then
    export MYVIM='nvim'
else
    export MYVIM='vim'
fi

export EDITOR="$MYVIM"
export VISUAL="$MYVIM"
export DOTFILES="$HOME/dotfiles"
export PYTHONSTARTUP=~/.pystartup

# --- PATH Configuration ---

# 1. Start with system paths
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

# 2. Add User and Dotfile binaries
export PATH=~/bin:~/opt/bin:$DOTFILES/bin:$PATH

# 3. Add Android Tools (only if the folder exists)
if [ -d "$HOME/adb-fastboot/platform-tools" ]; then
    export PATH="$HOME/adb-fastboot/platform-tools:$PATH"
fi

# 4. Local Node Modules 
export PATH=$PATH:./node_modules/.bin

# --- NVM Lazy Loading (Zsh Optimized) ---
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ] && [ -z "$+functions[__init_nvm]" ]; then
    declare -a __node_commands=(nvm node npm npx yarn) 
    function __init_nvm() {
        for i in "${__node_commands[@]}"; do unalias $i; done
        . "$NVM_DIR"/nvm.sh
        [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
        unset __node_commands
        unset -f __init_nvm
    }
    for i in "${__node_commands[@]}"; do alias $i='__init_nvm && '$i; done
fi

# --- Initializations ---
if command -v jenv > /dev/null; then eval "$(jenv init -)"; fi
if command -v rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# --- Aliases ---
# Ruby / Rails
alias b='bundle'
alias be='bundle exec'
alias bi='bundle install'
alias bir='bundle exec rake'
alias befs='bundle exec foreman start'

# Safety
alias cp='cp -i'
alias rm='rm -i'

# Utils - Smart Eza/Ls Switch
if command -v eza > /dev/null; then
    alias lx='eza -labF --git --icons --header --group-directories-first --hyperlink'
    alias l='eza -lah --icons'
    alias lt='eza --tree --level=2 --icons'
else
    alias l='ls -lah --color=auto'
    alias lx='ls -lF --color=auto'
    alias lt='tree -L 2'
fi

# Config editing
alias vimrc="$MYVIM ~/.vimrc"
alias vimbash="$MYVIM ~/.bashrc"
alias vimz="$MYVIM ~/.zshrc"
alias vimdot="$MYVIM $DOTFILES"
alias vimvim="$MYVIM $DOTFILES/.vim"
alias reload!='exec "$SHELL" -l'
alias dot="cd $DOTFILES"

# Spelling mistakes
alias vi="$MYVIM"
alias vim="$MYVIM"

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd..='cd ..'

# Git
alias gco.='gco .'
alias ga.='ga .'

# Grep fixes
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
# Only alias rg if installed
if command -v rg > /dev/null; then
    alias rg='rg -S --hidden --colors path:fg:cyan --colors path:style:nobold --colors line:style:bold --colors line:fg:black'
fi

# Network (Linux Friendly)
alias myip="hostname -I | cut -d' ' -f1"

# --- Functions ---

function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# cd then ls
function cdl {
    builtin cd "$@" && l
}
