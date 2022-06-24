
exists() {
    [[ -x $(command -v fzf) ]]
}

get() {
    git clone --depth 1 https://github.com/junegunn/fzf.git $LIB/fzf
    XDG_CONFIG_HOME=$prefix $LIB/fzf/install --xdg --all --no-update-rc
    profile_add "[ -f $prefix/fzf/fzf.zsh ] && source $prefix/fzf/fzf.zsh"
}

remove() {
    cd $LIB/fzf
    XDG_CONFIG_HOME=$prefix ./uninstall --xdg
    profile_remove "fzf/fzf.zsh"
}
