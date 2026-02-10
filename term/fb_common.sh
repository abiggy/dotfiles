# --- Work / Internal Configuration ---

# 1. Proxy / Network Helpers (Critical)
# Must be at the top so git/curl work for subsequent commands
if command -v fwdproxy-config > /dev/null; then
  alias git="git $(fwdproxy-config git)"
  alias curl="curl $(fwdproxy-config curl)"
fi

# 1. Variables
export FBANDROID_DIR="$HOME/fbsource/fbandroid"

# Android Configuration
# These are standard internal paths; they generally exist on OnDemands.
export ANDROID_HOME="/opt/android_sdk"
export ANDROID_SDK="$ANDROID_HOME"
export ANDROID_SDK_ROOT="$ANDROID_HOME"

# NDK Configuration
export ANDROID_NDK="/opt/android_ndk"
export ANDROID_NDK_REPOSITORY="$ANDROID_NDK" 

# 2. Work Paths

# Add Android Tools
export PATH="$PATH:$ANDROID_SDK/emulator:$ANDROID_SDK/tools:$ANDROID_SDK/tools/bin:$ANDROID_SDK/platform-tools"

# Fix pip user installs (required for Neovim/YCM on Linux)
if [ -d "$HOME/.local/bin" ]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# --- CHECK: Only add if paths exist ---
if [ -d "/opt/facebook" ]; then
    export PATH=${PATH}:/opt/bin/facebook
    export PATH=${PATH}:/opt/facebook/hg/bin
    export PATH=${PATH}:/opt/facebook/bin/
    export PATH=${PATH}:/var/www/scripts/bin/

fi

# --- Arcanist (arc) Completion ---
# Enables tab-completion for arc commands (like 'arc focus-android')
if [ -f "$HOME/fbsource/tools/arcanist/completions/arc-completion.zsh" ]; then
    source "$HOME/fbsource/tools/arcanist/completions/arc-completion.zsh"
fi

# 3. Aliases
alias quicklog_update="$FBANDROID_DIR/scripts/quicklog/quicklog_update.sh"
alias qlu='quicklog_update'

# Emulator Shortcuts
# Prevents errors if you accidentally type this on Linux
if [[ "$(uname)" == "Darwin" ]]; then
    alias siphone='(cd ~/fbsource && js1 device boot -p ios)'
    alias sandroid='(cd ~/fbsource && js1 device boot -p android)'
    alias sandroid2='(cd "$FBANDROID_DIR" && ./scripts/start_emulator)'
else
    alias siphone='echo "Error: Simulator cannot run on OnDemand instances."'
    alias sandroid='echo "Error: Simulator cannot run on OnDemand instances."'
    alias sandroid2='echo "Error: Simulator cannot run on OnDemand instances."'

fi

# Arc Pull
# Retaining your Python version lock. 
# Note: If arc fails on the server, try removing 'PYENV_VERSION=3.6.8'
alias arcpull='PYENV_VERSION=3.6.8 arc pull'

alias python=python3

