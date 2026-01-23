# --- Work / Internal Configuration ---

# 1. Variables
export FBANDROID_DIR="$HOME/fbsource/fbandroid"
export ANDROID_SDK="/opt/android_sdk"
export ANDROID_NDK_REPOSITORY="/opt/android_ndk"
export ANDROID_HOME="$ANDROID_SDK"

# 2. Work Paths
# Combining internal tool paths
export PATH="$PATH:$ANDROID_SDK/tools:$ANDROID_SDK/tools/bin:$ANDROID_SDK/platform-tools"
export PATH=${PATH}:/opt/bin/facebook
export PATH=${PATH}:/opt/facebook/hg/bin
export PATH=${PATH}:/opt/facebook/bin/
export PATH=${PATH}:/var/www/scripts/bin/

# 3. Aliases
alias quicklog_update="$FBANDROID_DIR/scripts/quicklog/quicklog_update.sh"
alias qlu='quicklog_update'

# Emulator Shortcuts
alias sandroid='(cd ~/fbsource && js1 device boot -p android)'
alias siphone='(cd ~/fbsource && js1 device boot -p ios)'

alias sandroid2='(cd "$FBANDROID_DIR" && ./scripts/start_emulator)'

# Dev Server
# Note: Hostnames like 'devvm050' often change. Check if this is still your active VM.
alias sandbox='ssh -6 -o GSSAPIAuthentication=no -o PubkeyAuthentication=no adambiglow.devvm050.vll0.facebook.com'

# Arc Pull
# Uses PYENV_VERSION so it doesn't get your terminal stuck on Python 3.6.8 permanently
alias arcpull='PYENV_VERSION=3.6.8 arc pull'
