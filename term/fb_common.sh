export FBANDROID_DIR=/Users/adambiglow/fbsource/fbandroid
alias quicklog_update=/Users/adambiglow/fbsource/fbandroid/scripts/quicklog/quicklog_update.sh
alias qlu=quicklog_update

# added by setup_fb4a.sh
export ANDROID_SDK=/opt/android_sdk
export ANDROID_NDK_REPOSITORY=/opt/android_ndk
export ANDROID_HOME=${ANDROID_SDK}
export PATH=${PATH}:${ANDROID_SDK}/tools:${ANDROID_SDK}/tools/bin:${ANDROID_SDK}/platform-tools

export PATH=${PATH}:/opt/bin/facebook
export PATH=${PATH}:/opt/facebook/hg/bin
export PATH=${PATH}:/opt/facebook/bin/
export PATH=${PATH}:/var/www/scripts/bin/

# quick start for android or iphone emulator:
alias sandroid='cd ~/fbsource && js1 device boot -p android'
alias sandroid2='cd ~/fbsource/fbandroid && ./scripts/start_emulator'
alias sandroidtwo='cd ~/fbsource/fbandroid && ./scripts/start_emulator'
alias siphone='cd ~/fbsource && js1 device boot -p ios'

alias sandbox='ssh -6 -o GSSAPIAuthentication=no -o PubkeyAuthentication=no adambiglow.devvm050.vll0.facebook.com'
alias arcpull='pyenv shell 3.6.8 && arc pull'
