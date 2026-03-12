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
#        devai kill <name>         # kill a specific session
#        devai kill-all            # kill all sessions (confirm first)
#        devai rename <old> <new>  # rename a session
function devai() {
    if [[ "$1" == "new" ]]; then
        tab "🤖 new OD" green
        shift
        dev ai new "$@"
        local rc=$?
        if [[ $rc -ne 0 ]]; then
            echo "\n❌ dev ai new failed (exit code $rc)"
            echo "Try: dev ai new $@ 2>&1 | cat   # to see full error output"
            tab reset
        fi
    elif [[ "$1" == "ls" || "$1" == "list" ]]; then
        dev ai list
    elif [[ "$1" == "kill" ]]; then
        shift
        dev ai kill "$@"
    elif [[ "$1" == "kill-all" || "$1" == "cleanup" || "$1" == "clean" ]]; then
        dev ai kill --all --force
    elif [[ "$1" == "rename" || "$1" == "mv" ]]; then
        shift
        dev ai rename "$@"
    elif [[ -n "$1" ]]; then
        tab "🤖 $1" green
        dev ai connect "$@"
    else
        dev ai list
    fi
}

# PARA workspace — auto-labels tab blue
# Uses CLAUDE_PARA_DIR from .zshrc (handles Mac vs OD paths)
export PARA_MODE="local"
alias cdpara='cd "$CLAUDE_PARA_DIR"'
function para() {
    tab "📋 PARA" blue
    cd "$CLAUDE_PARA_DIR" && claude
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

# Quick connect to static devserver with native iTerm tmux tabs
# Change MY_DEVSERVER if you get a new permanent devserver
MY_DEVSERVER="devvm39256.prn0.facebook.com"
function devserver() {
    devcc "$MY_DEVSERVER"
}
