#!/bin/sh
ssh-add ~/.ssh/id_rsa_work

eval "$(rbenv init -)"
export BOXEN_SOCKET_DIR=/usr/local/var/project-sockets

export PATH="/usr/local/opt/postgresql@9.6/bin:$PATH"

# Added so rbenv loads every time you open a terminal
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

code_root="$HOME/src"                                   # ~/src

viz_root="$code_root/visualizer"                        # ~/src/visualizer
viz2_root="$code_root/visualizer2"                      # ~/src/visualizer2
res_root="$code_root/acl-exception"                     # ~/src/acl-exception
acc_root="$code_root/accounts"                          # ~/src/accounts
risk_root="$code_root/aclrisk"                          # ~/src/aclrisk
proj_root="$code_root/workpapers"                       # ~/src/workpapers
vizui_root="$code_root/viz-ui"                          # ~/src/viz-ui
aclui_root="$code_root/acl-ui"                          # ~/src/acl-ui
sriracha_root="$code_root/sriracha"                     # ~/src/sriracha
grc_root="$code_root/grc-development-environment"       # ~/src/grc-development-environment
bot_root="$code_root/skynet-server"                     # ~/src/skynet-server
bot2_root="$code_root/skynet-server2"                   # ~/src/skynet-server2
paprika_root="$code_root/paprika"                       # ~/src/paprika

viz_dist="$viz_root/dist"                               # ~/src/visualizer/dist
viz_vizui_root="$viz_root/bower_components/viz-ui"      # ~/src/visualizer/bower_components/viz-ui
viz_vizui_dist="$viz_vizui_root/dist"                   # ~/src/visualizer/bower_components/viz-ui/dist
res_viz_root="$res_root/public/visualizer"              # ~/src/acl-exception/public/visualizer
res_viz_dist="$res_viz_root/dist"                       # ~/src/acl-exception/public/visualizer/dist
vizui_dist="$vizui_root/dist"                           # ~/src/viz-ui/dist
vizui_nodemodules="$vizui_root/node_modules"            # ~/src/viz-ui/node_modules
vizui_aclui_root="$vizui_nodemodules/acl-ui"            # ~/src/viz-ui/node_modules/acl-ui
aclui_dist="$aclui_root/acl-ui-dist"                    # ~/src/acl-ui/acl-ui-dist
botjs_root="$bot_root/app/javascript/robots"            # ~/src/skynet-server/app/javascript/robots
botjs2_root="$bot2_root/app/javascript/robots"          # ~/src/skynet-server2/app/javascript/robots

res_log="$res_root/log/development.log"                 # ~/src/acl-exception/log/development.log

alias res_viz="cd $res_viz_dist"                        # cd ~/src/acl-exception/public/visualizer/dist

alias viz="cd $viz_root"                                # cd ~/src/visualizer
alias viz2="cd $viz2_root"                              # cd ~/src/visualizer2
alias res="cd $res_root"                                # cd ~/src/acl-exception
alias acc="cd $acc_root"                                # cd ~/src/accounts
alias vu="cd $vizui_root"                               # cd ~/src/viz-ui
alias vizu="cd $vizui_root"                             # cd ~/src/viz-ui
alias vizui="cd $vizui_root"                            # cd ~/src/viz-ui
alias code="cd $code_root"                              # cd ~/src
alias src="cd $code_root"                               # cd ~/src
alias aclu="cd $aclui_root"                             # cd ~/src/acl-ui
alias aclui="cd $aclui_root"                            # cd ~/src/acl-ui
alias sri="cd $sriracha_root"                           # cd ~/src/sriracha
alias sriracha="cd $sriracha_root"                      # cd ~/src/sriracha
alias pap="cd $paprika_root"                            # cd ~/src/paprika
alias paprika="cd $paprika_root"                        # cd ~/src/paprika
alias grcdev="cd $grc_root"                             # cd ~/src/grc-development-environment
alias bot="cd $bot_root"                                # cd ~/src/skynet-server
alias bot2="cd $bot2_root"                              # cd ~/src/skynet-server2
alias botjs="cd $botjs_root"                            # cd ~/src/skynet-server/app/javascript/robots
alias botjs2="cd $botjs2_root"                          # cd ~/src/skynet-server2/app/javascript/robots
alias bj="cd $botjs_root"                               # cd ~/src/skynet-server/app/javascript/robots
alias bj2="cd $botjs2_root"                             # cd ~/src/skynet-server2/app/javascript/robots

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

function viz_vizui_mk() {
    echo "mkdir $viz_vizui_root"
    mkdir $viz_vizui_root                               # mkdir ~/src/visualizer/bower_components/viz-ui
}

function viz_vizui_cp() {
    viz_vizui_rm
    viz_vizui_mk
    echo "cp -a $vizui_dist $viz_vizui_root"
    cp -a $vizui_dist $viz_vizui_root                   # cp -a ~/src/viz-ui/dist ~/src/visualizer/bower_components/viz-ui
}

function viz_vizui_ln() {
    viz_vizui_rm
    viz_vizui_mk
    echo "ln -nsf $vizui_dist $viz_vizui_dist"
    ln -nsf $vizui_dist $viz_vizui_dist                 # ln -nsf ~/src/viz-ui/dist ~/src/visualizer/bower_components/viz-ui/dist
}

function vizui_aclui_ln() {
    vizui_aclui_rm
    echo "ln -nsf $aclui_dist $vizui_aclui_root"
    ln -nsf $aclui_dist $vizui_aclui_root               # ln -nsf ~/src/acl-ui-dist ~/src/viz-ui/node_modules/acl-ui
}

function vizui_aclui_cp() {
    vizui_aclui_rm
    vizui_aclui_mk
    echo "cp -a $aclui_dist/. $vizui_aclui_root"
    cp -a $aclui_dist/. $vizui_aclui_root               # cp -a ~/src/acl-ui-dist/. ~/src/viz-ui/node_modules/acl-ui
}

function vizui_aclui_rm() {
    echo "rm -rf $vizui_aclui_root"
    rm -rf $vizui_aclui_root                            # rm -rf ~/src/viz-ui/node_modules/acl-ui
}

function vizui_aclui_mk() {
    echo "mkdir $vizui_aclui_root"
    mkdir $vizui_aclui_root                             # mkdir ~/src/viz-ui/node_modules/acl-ui
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

