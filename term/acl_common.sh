#!/bin/sh

eval "$(rbenv init -)"
export BOXEN_SOCKET_DIR=/usr/local/var/project-sockets

# Added so rbenv loads every time you open a terminal
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# NVM required setup.
export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"

code_root="$HOME/src"

viz_root="$code_root/visualizer"
viz2_root="$code_root/visualizer2"
res_root="$code_root/acl-exception"
acc_root="$code_root/accounts"
risk_root="$code_root/aclrisk"
proj_root="$code_root/workpapers"
vizui_root="$code_root/viz-ui"
aclui_root="$code_root/acl-ui"

viz_dist="$viz_root/dist"
viz_vizui_root="$viz_root/bower_components/viz-ui"
viz_vizui_dist="$viz_vizui_root/dist"
res_viz_root_old="$res_root/vendor/assets/bower_components/visualizer"
res_viz_root="$res_root/public/visualizer"
res_viz_dist_old="$res_viz_root_old/dist"
res_viz_dist="$res_viz_root/dist"
vizui_dist="$vizui_root/dist"

alias res_viz="cd $res_viz_dist"

alias viz="cd $viz_root"
alias viz2="cd $viz2_root"
alias res="cd $res_root"
alias acc="cd $acc_root"
alias vizui="cd $vizui_root"
alias vizu="cd $vizui_root"
alias vu="cd $vizui_root"
alias code="cd $code_root"
alias aclu="cd $aclui_root"

function res_viz_rm_old() {
    rm -rf $res_viz_dist_old
}

function res_viz_rm() {
    rm -rf $res_viz_dist
}

function res_viz_cp_old() {
    res_viz_rm_old && cp -a $viz_dist $res_viz_root_old
}

function res_viz_cp() {
    res_viz_rm && cp -a $viz_dist $res_viz_root
}

function res_viz_ln_old() {
    res_viz_rm_old && ln -nsf $viz_dist $res_viz_dist_old
}

function res_viz_ln() {
    res_viz_rm && ln -nsf $viz_dist $res_viz_dist
}

function viz_vizui_rm() {
    rm -rf $viz_vizui_dist
}

function viz_vizui_cp() {
    viz_vizui_rm && cp -a $vizui_dist $viz_vizui_root
}

function viz_vizui_ln() {
    viz_vizui_rm && ln -nsf $vizui_dist $viz_vizui_root
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

