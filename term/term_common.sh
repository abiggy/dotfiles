#!/bin/sh

export EDITOR=vim
export GREP_COLORS=auto # Turn on colors for grep
export PYTHONSTARTUP=~/.pystartup
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:~/bin:~/opt/bin:~/dotfiles/bin:$PATH
### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export DOTFILES="$HOME/dotfiles"

alias ..='cd ..'
alias b='bundle'
alias be='bundle exec'
alias bi='bundle install'
alias bir='bundle exec rake'
alias cp='cp -i'

alias rm='rm -i'
alias vi='vim'

alias lx=' LC_ALL=en_US.UTF-8 LANG=en ls++ '

alias vimrc='vim ~/.vimrc'
alias vimbash='vim ~/.bashrc'
alias vimzsh='vim ~/.zshrc'
alias vimbashp='vim ~/.bash_profile'

alias dot="cd $DOTFILES"

#Spelling mistakes
alias ivim='vim'
alias ivm='vim'
alias cd..='cd ..'

alias ..='cd ..'
alias ...='cd ../..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'

alias grep='egrep'
alias egrep='egrep --color'

# ifconfig only active!
alias ifconfig2="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"

function mkcd() {
  dir="$1"
  mkdir -p $dir && cd $dir
}

# cd then ls
function cdl {
    builtin cd "$@" && l
}

# google command
google () {
  search=""
  for term in $@; do
      search="$search%20$term"
  done
  open "http://www.google.com/search?q=$search"
}
