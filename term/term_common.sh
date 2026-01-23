#!/bin/zsh

# --- Environment Variables ---
## CHANGE THIS to 'nvim' later if you install Neovim!
export MYVIM='vim' 

export EDITOR="$MYVIM"
export VISUAL="$MYVIM"
export GREP_COLORS='auto' # Turn on colors for grep
export PYTHONSTARTUP=~/.pystartup
export DOTFILES="$HOME/dotfiles"


# --- PATH Configuration ---

# 1. Start with system paths
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin

# 2. Add User and Dotfile binaries
export PATH=~/bin:~/opt/bin:$DOTFILES/bin:$PATH

# 3. Add Third-party tools
export PATH=/usr/local/heroku/bin:$PATH
export PATH=/usr/local/opt/python/libexec/bin:$PATH

# 4. Add Android Tools (only if the folder exists)
if [ -d "$HOME/adb-fastboot/platform-tools" ]; then
    export PATH="$HOME/adb-fastboot/platform-tools:$PATH"
fi

# 5. Local Node Modules 
# (Added to the END so standard system commands aren't accidentally hijacked by a local folder)
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

# Utils
alias lx=' LC_ALL=en_US.UTF-8 LANG=en ls++ '
alias l='ls -lah'

# Config editing
alias vimrc="$MYVIM ~/.vimrc"
alias vimbash="$MYVIM ~/.bashrc"
alias vimzsh="$MYVIM ~/.zshrc"
alias vimz="$MYVIM ~/.zshrc"
alias vimbashp="$MYVIM ~/.bash_profile"
alias vimdot="$MYVIM $DOTFILES"
alias vimvim="$MYVIM $DOTFILES/.vim"
alias vimvimrc="$MYVIM $DOTFILES/.vim/vimrc"
alias reload!='exec "$SHELL" -l'


alias dot="cd $DOTFILES"

#Spelling mistakes
alias vi="$MYVIM"
alias vim="$MYVIM"
alias ivim="$MYVIM"
alias ivm="$MYVIM"

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'

# Git
alias gco.='gco .'
alias ga.='ga .'

# Grep fixes
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias rg='rg -S --hidden --colors path:fg:cyan --colors path:style:nobold --colors line:style:bold --colors line:fg:black'

# Network
alias ifconfig2="/sbin/ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"
alias ifconfigip="ifconfig2 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"


# --- Functions ---

function mkcd() {
    mkdir -p "$1" && cd "$1"
}

# cd then ls
function cdl {
    builtin cd "$@" && l
}

# google command (Zsh optimized)
function google() {
    open "http://www.google.com/search?q=${(j:+:)@}"
}

function ituneskiller () {
    ruby ~/Documents/overkill/overkill.rb &
}
