#!/bin/zsh
source $HOME/dotfiles/term/term_common.sh
source $HOME/dotfiles/term/acl_common.sh

# Path to your oh-my-zsh configuration.
export ZSH=$HOME/.oh-my-zsh

export LSCOLORS='exfxcxdxbxegedabagacad'
export CLICOLOR=true

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="af-magic"
#ZSH_THEME="sorin"
#ZSH_THEME="fishy"
#ZSH_THEME="syl20bnr"
#ZSH_THEME="edvardm"
ZSH_THEME="agnoster"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions vi-mode npm bower z)

source $ZSH/oh-my-zsh.sh

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[[ -n "$SSH_CLIENT" ]] || export DEFAULT_USER="adam_biglow"

# From http://dotfiles.org/~_why/.zshrc
# Sets the window title nicely no matter where you are
title() {
  # escape '%' chars in $1, make nonprintables visible
  a=${(V)1//\%/\%\%}

  # Truncate command, and join lines.
  a=$(print -Pn "%40>...>$a" | tr -d "\n")

  case $TERM in
  screen)
    print -Pn "\ek$a:$3\e\\" # screen title (in ^A")
    ;;
  xterm*|rxvt)
    print -Pn "\e]2;$2\a" # plain xterm title ($3 for pwd)
    ;;
  esac
}

gpr() {
    git push && open-pr "integration"
}

__reload_dotfiles() {
  PATH="$(command -p getconf PATH):/usr/local/bin"
  # shellcheck disable=SC1090
  . ~/.zshrc
  cd . || return 1
}
alias refresh='__reload_dotfiles'

source <(antibody init)
antibody bundle caarlos0/open-pr
