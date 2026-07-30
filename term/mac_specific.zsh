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
# cdpara and vimpara defined in .zshrc (shared across Mac + OD)
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
# SSH into any remote box (OD or devserver) with native iTerm tmux tabs
# Usage: devssh 236207.od           # connect to OD
#        devssh devvm5292            # connect to devserver
# Requires: iTerm2 Settings > General > tmux > "Use tmux integration" enabled
function devssh() {
    if [[ -z "$1" ]]; then
        echo "Usage: devssh <hostname>"
        echo "  e.g. devssh 236207.od"
        echo "  e.g. devssh devvm5292.scu0.facebook.com"
        return 1
    fi
    tab "🖥️ $1" green
    dev connect -n "$1" --et -- tmux -CC new-session -A -s main
}

# Quick SSH to permanent devserver
# Change MY_DEVSERVER if you get a new permanent devserver
MY_DEVSERVER="devvm5292.scu0.facebook.com"
function devserver() {
    devssh "$MY_DEVSERVER"
}
alias devcc='devssh'  # backward compat

uie-it-all() {
  local od="${1:?Usage: uie-it-all <od-number>}"
  pkill uie-companion-local 2>/dev/null
  uie-companion cleanup 2>/dev/null
  # Clear stale Flipper ports from all booted simulators
  for udid in $(xcrun simctl list devices booted -j | python3 -c "import sys,json; [print(d['udid']) for ds in json.load(sys.stdin)['devices'].values() for d in ds if d['state']=='Booted']" 2>/dev/null); do
    xcrun simctl spawn "$udid" defaults delete "Apple Global Domain" "com.facebook.flipper.ports" 2>/dev/null
  done
  uie-companion auth "${od}.fbinfra.net"
  # Connect sim + set up Flipper + restart app to pick up new ports
  echo "Connecting simulator..."
  if uie-companion ios sim-connect "${od}.fbinfra.net" 2>/dev/null; then
    echo "Setting up Flipper..."
    uie-companion ios flipper-connect "${od}.fbinfra.net" 2>/dev/null
    # Restart app so it reads the new Flipper port config
    local app_udid=$(uie-companion ios list-targets 2>/dev/null | grep "Booted" | head -1 | grep -oE '[A-F0-9-]{36}')
    if [[ -n "$app_udid" ]]; then
      xcrun simctl terminate "$app_udid" com.burbn.barcelona.localDevelopment 2>/dev/null
      xcrun simctl launch "$app_udid" com.burbn.barcelona.localDevelopment 2>/dev/null
      echo "Flipper ready — app restarted with fresh ports."
    fi
  else
    echo "No booted simulator found. Run again after sim is booted, or use: uie-flipper ${od}"
  fi
}

# Run standalone after sim is connected (if uie-it-all didn't catch it)
uie-flipper() {
  local od="${1:?Usage: uie-flipper <od-number>}"
  uie-companion ios flipper-connect "${od}.fbinfra.net"
  local app_udid=$(uie-companion ios list-targets 2>/dev/null | grep "Booted" | head -1 | grep -oE '[A-F0-9-]{36}')
  if [[ -n "$app_udid" ]]; then
    xcrun simctl terminate "$app_udid" com.burbn.barcelona.localDevelopment 2>/dev/null
    xcrun simctl launch "$app_udid" com.burbn.barcelona.localDevelopment 2>/dev/null
    echo "Flipper ready — app restarted with fresh ports."
  fi
}

# --- Browser Remote-Debug Tunnel (Claude Code www/Nest before-after screenshots) ---
# Drives your *Mac's* Chrome — which already has your SSO cookies + mTLS client cert
# in the keychain — from ccoding running on an OD, so Claude can take real
# before/after screenshots itself. This is the BACKUP path: the OD's own
# remote-headless browser (browser_launch on the OD) is the primary, fully-autonomous
# route for www. Reach for this tunnel when that can't reach the target — i.e. Nest
# apps on internalmeta.com (mTLS wall) or when you need YOUR real logged-in cookies.
# Full playbook: ~/gdrive/claude/03_resources/coding/references/www-browser-e2e-dogfood.md
#
# Usage: browser-it-all 158953.od     # launch debug Chrome (if needed) + open the tunnel
#        browser-tunnel 158953.od     # re-open just the tunnel (Chrome already running)
# The command HANGS after the Duo prompt — that means the tunnel is live. Ctrl-C to stop.
# Chrome persists across Ctrl-C (SSO stays logged in); kill it with:  pkill -f claude_browser
# Persistent variant that survives laptop sleep / network blips (if x2ssh is installed):
#   x2ssh -et -et_reverse_tunnel 9222:9222 158953.od.fbinfra.net

# Normalize an OD/host arg (158953 | 158953.od | full hostname) -> <host>.fbinfra.net
__browser_od_host() {
  case "$1" in
    *.fbinfra.net) print -r -- "$1" ;;            # already a full fbinfra host
    *.od)          print -r -- "${1}.fbinfra.net" ;;  # 158953.od -> 158953.od.fbinfra.net
    *.*)           print -r -- "$1" ;;            # some other full host (e.g. devvm...)
    *)             print -r -- "${1}.od.fbinfra.net" ;;  # bare 158953 -> 158953.od.fbinfra.net
  esac
}

browser-it-all() {
  local od="${1:?Usage: browser-it-all <od>   (e.g. browser-it-all 158953.od)}"
  local chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

  # Reuse an already-running debug Chrome so re-runs keep your SSO login; else launch.
  if curl -s -o /dev/null --max-time 2 http://127.0.0.1:9222/json/version; then
    echo "✅ Debug Chrome already listening on :9222 — reusing it (SSO preserved)."
  elif [[ ! -x "$chrome" ]]; then
    echo "❌ Google Chrome not found at: $chrome"
    return 1
  else
    echo "🌐 Launching throwaway-profile Chrome with remote debugging on :9222 ..."
    nohup "$chrome" \
      --remote-debugging-port=9222 \
      --user-data-dir=/tmp/claude_browser \
      --no-first-run --no-default-browser-check --disable-extensions \
      https://www.internalfb.com/ >/dev/null 2>&1 &
    disown
    echo "   → In the Chrome window that just opened, log into SSO (internalfb.com)."
    sleep 2
  fi

  browser-tunnel "$od"
}

# Convenience wrapper: my devserver hostname never changes, so hardcode it.
# Usage: browser-it-all-devserver     # = browser-it-all devvm5292.scu0.facebook.com
browser-it-all-devserver() {
  browser-it-all devvm5292.scu0.facebook.com
}

# Re-open just the reverse tunnel (Chrome already up). Mirrors uie-flipper.
browser-tunnel() {
  local od="${1:?Usage: browser-tunnel <od>   (e.g. browser-tunnel 158953.od)}"
  local host; host="$(__browser_od_host "$od")"

  # Drop any stale local tunnel so we don't stack duplicate forwards.
  pkill -f "ssh -N -R 9222:localhost:9222" 2>/dev/null

  echo "🔌 Reverse tunnel:  Mac localhost:9222  →  ${host}:9222"
  echo "   Hangs after Duo = working. Ctrl-C to stop."
  echo "   On the OD, verify:   curl -s http://127.0.0.1:9222/json/version"
  echo "   Then tell Claude:    \"My Mac Chrome is on port 9222 via the tunnel — use it for screenshots.\""
  ssh -N -R 9222:localhost:9222 \
    -o ExitOnForwardFailure=yes \
    -o ServerAliveInterval=30 -o ServerAliveCountMax=3 \
    "$host"
  local rc=$?
  if [[ $rc -eq 255 ]]; then
    echo "\n❌ Tunnel failed (ssh 255) — usually port 9222 is already bound on the OD."
    echo "   On the OD:  ss -tlnp | grep :9222   → kill the holder, then re-run browser-tunnel ${od}."
  fi
}
