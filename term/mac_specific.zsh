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
