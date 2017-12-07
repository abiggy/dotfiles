#!/bin/sh

eval "$(rbenv init -)"
export BOXEN_SOCKET_DIR=/usr/local/var/project-sockets

# Added so rbenv loads every time you open a terminal
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# NVM required setup.
export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"

code_root="$HOME/src"                                   # ~/src

viz_root="$code_root/visualizer"                        # ~/src/visualizer
viz2_root="$code_root/visualizer2"                      # ~/src/visualizer2
res_root="$code_root/acl-exception"                     # ~/src/acl-exception
acc_root="$code_root/accounts"                          # ~/src/accounts
risk_root="$code_root/aclrisk"                          # ~/src/aclrisk
proj_root="$code_root/workpapers"                       # ~/src/workpapers
vizui_root="$code_root/viz-ui"                          # ~/src/viz-ui
aclui_root="$code_root/acl-ui"                          # ~/src/acl-ui
grc_root="$code_root/grc-development-environment"       # ~/src/grc-development-environment

viz_dist="$viz_root/dist"                               # ~/src/visualizer/dist
viz_vizui_root="$viz_root/bower_components/viz-ui"      # ~/src/visualizer/bower_components/viz-ui
viz_vizui_dist="$viz_vizui_root/dist"                   # ~/src/visualizer/bower_components/viz-ui/dist
res_viz_root="$res_root/public/visualizer"              # ~/src/acl-exception/public/visualizer
res_viz_dist="$res_viz_root/dist"                       # ~/src/acl-exception/public/visualizer/dist
vizui_dist="$vizui_root/dist"                           # ~/src/viz-ui/dist
res_log="$res_root/log/development.log"                 # ~/src/acl-exception/log/development.log

alias res_viz="cd $res_viz_dist"                        # cd ~/src/acl-exception/public/visualizer/dist

alias viz="cd $viz_root"                                # cd ~/src/visualizer
alias viz2="cd $viz2_root"                              # cd ~/src/visualizer2
alias res="cd $res_root"                                # cd ~/src/acl-exception
alias acc="cd $acc_root"                                # cd ~/src/accounts
alias vizui="cd $vizui_root"                            # cd ~/src/viz-ui
alias vizu="cd $vizui_root"                             # cd ~/src/viz-ui
alias vu="cd $vizui_root"                               # cd ~/src/viz-ui
alias code="cd $code_root"                              # cd ~/src
alias src="cd $code_root"                               # cd ~/src
alias aclu="cd $aclui_root"                             # cd ~/src/acl-ui
alias grcdev="cd $grc_root"                             # cd ~/src/grc-development-environment

alias reslog="tail -f $res_log"                         # tail -f ~/src/acl-exception/log/development.log

function res_viz_rm() {
    echo "rm -rf $res_viz_dist"
    rm -rf $res_viz_dist                                # rm -rf ~/src/acl-exception/public/visualizer/dist
}

function res_viz_cp() {
    res_viz_rm && cp -a $viz_dist $res_viz_root         # cp -a ~/src/visualizer/dist ~/src/acl-exception/public/visualizer
    echo "cp -a $viz_dist $res_viz_root"
}

function res_viz_ln() {
    res_viz_rm && ln -nsf $viz_dist $res_viz_dist       # ln -nsf ~/src/visualizer/dist ~/src/acl-exception/public/visualizer/dist
    echo "ln -nsf $viz_dist $res_viz_dist"
}

function viz_vizui_rm() {
    echo "rm -rf $viz_vizui_root"
    rm -rf $viz_vizui_root                              # rm -rf ~/src/visualizer/bower_components/viz-ui
}

function viz_vizui_cp() {
    viz_vizui_rm && cp -a $vizui_root $viz_vizui_root   # cp -a ~/src/viz-ui ~/src/visualizer/bower_components/viz-ui
    echo "cp -a $vizui_root $viz_vizui_root"
}

function viz_vizui_ln() {
    viz_vizui_rm
    echo "ln -nsf $vizui_root $viz_vizui_root"
    ln -nsf $vizui_root $viz_vizui_root # ln -nsf ~/src/viz-ui ~/src/visualizer/bower_components/viz-ui
}

function res_build() {
    ggl && rm -rf node_modules && npm install && bundle i && be foreman start
}

function viz_vu_build() {
    ggl && rm -rf node_modules bower_components && npm install && bower install && viz_vizui_ln && grunt && res_viz_cp
}

function viz_build() {
    ggl && rm -rf node_modules bower_components && npm install && bower install && viz_vizui_ln && grunt && res_viz_cp
}

function viz_res_build() {
    grunt dist && res_viz_cp
}

