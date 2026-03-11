# --- Heavy / Mac-Only Configuration ---

# Path Configuration (Brew)
export BREW_HOME=/opt/homebrew
export PATH=$BREW_HOME/bin:$PATH

# Colors (BSD/Mac Style)
export LSCOLORS='exfxcxdxbxegedabagacad'

# Antigen (Syntax Highlighting for Mac)
# Note: On the server, we handled this via the plugins list in .zshrc
if [ -f "$BREW_HOME/share/antigen/antigen.zsh" ]; then
    source $BREW_HOME/share/antigen/antigen.zsh
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen apply
fi

# Functions & Aliases (Mac Only)
function gpr {
    git push && open-pr "integration"
}

# iTerm2 Integration
if [ -e "${HOME}/.iterm2_shell_integration.zsh" ]; then
    source "${HOME}/.iterm2_shell_integration.zsh"
fi

# AVN (Automatic Version Switching for Node)
if [[ -s "$HOME/.avn/bin/avn.sh" ]]; then
    source "$HOME/.avn/bin/avn.sh"
fi


# Mac Specific Paths
export PATH=/usr/local/heroku/bin:$PATH
export PATH=/usr/local/opt/python/libexec/bin:$PATH
export PATH="$HOME/Library/Python/3.14/bin:$PATH"

# Google (Uses 'open', which is Mac only)
function google() {
    open "http://www.google.com/search?q=${(j:+:)@}"
}

# iTunes Script
function ituneskiller () {
    ruby ~/Documents/overkill/overkill.rb &
}

# Complex Network Alias (Mac Style)
alias ifconfig2="/sbin/ifconfig | pcre2grep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"
alias ifconfigip="ifconfig2 | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"


# --- iTerm2 Tab Helpers ---
# Label and color-code iTerm tabs from the command line.
# Usage:
#   tab "OD 236207 - Threads" green    # set title + color
#   tab "Local PARA" blue              # set title + color
#   tab reset                          # back to dynamic (current dir)
#   tab-color red                      # change color only
#
# Colors: red green blue purple orange yellow reset

__ITERM_STICKY_TITLE=""

function tab() {
    if [[ "$1" == "reset" ]]; then
        __ITERM_STICKY_TITLE=""
        echo "Tab title: dynamic (current directory)"
        return
    fi
    local name="$1"
    local color="${2}"
    if [[ -n "$name" ]]; then
        __ITERM_STICKY_TITLE="$name"
        echo -ne "\e]1;${name}\a\e]2;${name}\a"
    fi
    if [[ -n "$color" ]]; then
        tab-color "$color"
    fi
}

function tab-color() {
    case "$1" in
        red)    echo -ne "\033]6;1;bg;red;brightness;200\a\033]6;1;bg;green;brightness;60\a\033]6;1;bg;blue;brightness;60\a" ;;
        green)  echo -ne "\033]6;1;bg;red;brightness;60\a\033]6;1;bg;green;brightness;180\a\033]6;1;bg;blue;brightness;60\a" ;;
        blue)   echo -ne "\033]6;1;bg;red;brightness;60\a\033]6;1;bg;green;brightness;100\a\033]6;1;bg;blue;brightness;220\a" ;;
        purple) echo -ne "\033]6;1;bg;red;brightness;160\a\033]6;1;bg;green;brightness;60\a\033]6;1;bg;blue;brightness;200\a" ;;
        orange) echo -ne "\033]6;1;bg;red;brightness;230\a\033]6;1;bg;green;brightness;140\a\033]6;1;bg;blue;brightness;40\a" ;;
        yellow) echo -ne "\033]6;1;bg;red;brightness;220\a\033]6;1;bg;green;brightness;200\a\033]6;1;bg;blue;brightness;40\a" ;;
        reset)  echo -ne "\033]6;1;bg;*;default\a" ;;
        *)      echo "Colors: red green blue purple orange yellow reset" ;;
    esac
}

# --- Workflow Launchers (auto-label iTerm tabs) ---

# dev ai connect with auto-labeled tab
# Usage: devai agile-tiger       # connect by session name
#        devai 236207.od          # connect by OD name
#        devai new                # reserve new OD + start session
#        devai new -t www         # new session on specific OD type
#        devai ls                 # list sessions (no tab change)
function devai() {
    if [[ "$1" == "new" ]]; then
        tab "🤖 new OD" green
        shift
        dev ai new "$@"
    elif [[ "$1" == "ls" || "$1" == "list" ]]; then
        dev ai list
    elif [[ -n "$1" ]]; then
        tab "🤖 $1" green
        dev ai connect "$@"
    else
        dev ai list
    fi
}

# PARA workspace — auto-labels tab blue
export PARA_MODE="local"
export PARA_ROOT="/Users/adambiglow/Library/CloudStorage/GoogleDrive-adambiglow@meta.com/My Drive/claude"
alias cdpara='cd "$PARA_ROOT"'
function para() {
    tab "📋 PARA" blue
    cd "$PARA_ROOT" && claude
}

# Override cc on Mac to add tab label (cc alias exists in fb_common.sh for ODs)
function cc() {
    tab "🧠 claude" purple
    claude "$@"
}

# Shell + native tmux tabs on OD — browse files, vim, run cc when ready
# OD tmux windows become real iTerm tabs via -CC
# Usage: devcc 236207.od           # connect with native tabs
#        devcc devvm39256           # works with devservers too
# Requires: iTerm2 Settings > General > tmux > "Use tmux integration" enabled
function devcc() {
    if [[ -z "$1" ]]; then
        echo "Usage: devcc <hostname>"
        echo "  e.g. devcc 236207.od"
        echo "  e.g. devcc devvm39256.prn0.facebook.com"
        return 1
    fi
    tab "🖥️ $1" green
    dev connect -n "$1" --et -- tmux -CC new-session -A -s main
}
