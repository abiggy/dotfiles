# ~/.bashrc: executed by bash(1) for non-login shells.
source ./term/term_common.sh
source ./term/acl_common.sh

# If not running interactively, don't do anything
if [ -n "$PS1" ] ; then

export HISTCONTROL=ignoreboth # ignoredups and ignorespace
shopt -s histappend

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

function __ruby_version {
  ver=$(ruby -v 2> /dev/null | cut -d' ' -f 2)
  if [[ -n $ver ]]; then
    echo "[$ver]"
  fi
}

function __hg_branch {
  hg branch 2> /dev/null | awk '{print " (" $1 ")"}'
}

function __virtualenv {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo " (venv)"
  fi
}

set_prompt () {
  if [ $? -ne 0 ]; then
    ERR='($?) '
  else
    ERR=""
  fi

  local NONE="\[\033[0m\]"    # unsets color to term's fg color

  # regular colors
  local K="\[\033[0;30m\]"    # black
  local R="\[\033[0;31m\]"    # red
  local G="\[\033[0;32m\]"    # green
  local Y="\[\033[0;33m\]"    # yellow
  local B="\[\033[0;34m\]"    # blue
  local M="\[\033[0;35m\]"    # magenta
  local C="\[\033[0;36m\]"    # cyan
  local W="\[\033[0;37m\]"    # white

  # emphasized (bolded) colors
  local EMK="\[\033[1;30m\]"
  local EMR="\[\033[1;31m\]"
  local EMG="\[\033[1;32m\]"
  local EMY="\[\033[1;33m\]"
  local EMB="\[\033[1;34m\]"
  local EMM="\[\033[1;35m\]"
  local EMC="\[\033[1;36m\]"
  local EMW="\[\033[1;37m\]"

  # background colors
  local BGK="\[\033[40m\]"
  local BGR="\[\033[41m\]"
  local BGG="\[\033[42m\]"
  local BGY="\[\033[43m\]"
  local BGB="\[\033[44m\]"
  local BGM="\[\033[45m\]"
  local BGC="\[\033[46m\]"
  local BGW="\[\033[47m\]"

  GIT_PS1_SHOWDIRTYSTATE=1

  # Set the tab title in iTerm2 to the PWD.
  echo -ne "\033]0;${PWD/#$HOME/~}\007"

  # Removed Ruby part $EMR$(__ruby_version)
  PS1="
$EMB\u@\h:$EMG\w ${R}$ERR$EMM\$(__git_ps1)\$(__hg_branch)$EMY\$(__virtualenv)$NONE
$EMC`date +%D` \t $EMY\$$NONE "
}

PROMPT_COMMAND=set_prompt

# enable color support of ls
if [ "$TERM" != "dumb" ]; then
  if [[ "$OSTYPE" =~ "darwin" ]]; then
    alias ls='ls -G'
    # LSCOLORS='gxfxcxdxbxegedabagacad'
    LSCOLORS='ExFxBxDxCxegedabagacad'
  else
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
  fi
fi

# some more ls aliases
alias ll='ls -lh'
alias la='ls -A'
alias lal='ls -Al'
alias lla='ls -Al'
alias l='ls -AlhF'

# Git
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gcamsg='git commit -am'
alias gcmsg='git commit -m'
alias gd='git_diff'
alias gfo='git fetch origin'
alias gh='git hist'
alias gph='git push heroku'
alias gr='git rebase'
alias grm='git rebase master'
alias grom='git rebase origin/master'
alias gst='git status'
alias gb='git branch'
alias gd2='git d'
alias gco='git checkout'
alias ggl="git pull origin"
alias gp="git push origin"

alias hdj='heroku run python manage.py'
alias hr='heroku run'
type hub &> /dev/null && alias git='hub'
alias mvimcp='open -a Macvim .'
alias npm-exec='PATH=$(npm bin):$PATH'
alias ppjson='python -mjson.tool'
alias rm='rm -i'
alias rs='rake spec'
alias rspec='rspec --color --backtrace --format=documentation'
alias t='column -t'
alias tmux='tmux -2'
alias tunnel='ssh -C2qTnN -D 8080 brandonkliu@brandonkliu.com'
alias v='source venv/bin/activate'

if [[ -e ~/.bashrc.local ]]; then
  source ~/.bashrc.local
fi

source $HOME/.bash/completion.bash

if [[ -e /usr/local/etc/bash_completion ]]; then
  source /usr/local/etc/bash_completion
fi

function git_diff() {
  git diff --no-ext-diff -w "$@" | vim -R -
}

function gsl() {
  git log --oneline --color $* | head
}

function dj() {
  python `find-up manage.py` "$@"
}

# Stuff
set -o vi
alias refresh='source "$HOME/.bashrc"'

# Colour?!
source "`brew --prefix`/etc/grc.bashrc"
source `brew --prefix git`/etc/bash_completion.d/git-completion.bash
. `brew --prefix`/etc/profile.d/z.sh

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
