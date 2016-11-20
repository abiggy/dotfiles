eval "$(rbenv init -)"
export BOXEN_SOCKET_DIR=/usr/local/var/project-sockets

# Added so rbenv loads every time you open a terminal
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# NVM required setup.
export NVM_DIR="$HOME/.nvm"
  . "$(brew --prefix nvm)/nvm.sh"

code_root="$HOME/code/src"

viz_root="$code_root/visualizer"
res_root="$code_root/results"
acc_root="$code_root/accounts"
risk_root="$code_root/risks"
proj_root="$code_root/projects"

viz_dist="$viz_root/dist"
res_viz_root="$res_root/vendor/assets/bower_components/visualizer"
res_viz_dist="$res_root/vendor/assets/bower_components/visualizer/dist"

alias viz="cd $viz_root"
alias res="cd $res_root"
alias acc="cd $acc_root"

function res_viz_rm() {
    rm -rf $res_viz_dist
}

function res_viz_cp() {
    res_viz_rm && cp -a $viz_dist $res_viz_root
}

function res_viz_ln() {
    res_viz_rm && ln -nsf $viz_dist $res_viz_dist
}
