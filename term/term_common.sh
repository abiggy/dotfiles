#!/bin/sh
export EDITOR=vim
export GREP_COLORS=auto # Turn on colors for grep
export PYTHONSTARTUP=~/.pystartup
export PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin:~/bin:~/opt/bin:~/dotfiles/bin:$PATH
### Added by the Heroku Toolbelt
export PATH=/usr/local/heroku/bin:$PATH
export PATH=./node_modules/.bin:$PATH

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi
[[ -s "$HOME/.avn/bin/avn.sh" ]] && source "$HOME/.avn/bin/avn.sh" # load avn

# android stuff
if [ -d "$HOME/adb-fastboot/platform-tools" ] ; then
 export PATH="$HOME/adb-fastboot/platform-tools:$PATH"
fi

export DOTFILES="$HOME/dotfiles"

export VISUAL=/usr/local/bin/vim

alias b='bundle'
alias be='bundle exec'
alias bi='bundle install'
alias bir='bundle exec rake'

alias cp='cp -i'
alias rm='rm -i'

alias lx=' LC_ALL=en_US.UTF-8 LANG=en ls++ '

alias vimrc='vim ~/.vimrc'
alias vimbash='vim ~/.bashrc'
alias vimzsh='vim ~/.zshrc'
alias vimbashp='vim ~/.bash_profile'
alias vimdot='vim $DOTFILES'
alias vimvim='vim $DOTFILES/.vim'
alias vimvimrc='vim $DOTFILES/.vim/vimrc'

alias dot="cd $DOTFILES"

#Spelling mistakes
alias defaultvim='nvim'
alias vi='defaultvim'
alias ivim='defaultvim'
alias ivm='defaultvim'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'

alias gco.='gco .'
alias ga.='ga .'

alias grep='egrep'
alias egrep='egrep --color'

alias rg='rg -S --hidden --colors path:fg:cyan --colors path:style:nobold --colors line:style:bold --colors line:fg:black'

# ifconfig only active!
alias ifconfig2="/sbin/ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"
alias ifconfigip="ifconfig2 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"

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

function ituneskiller () {
    ruby ~/Documents/overkill/overkill.rb &
}
