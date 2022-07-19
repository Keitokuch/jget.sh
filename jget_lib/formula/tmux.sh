TMUX_VERSION=3.3a

get() {
    if ( is_macos && is_arm ); then 
        get_apple_m 
    else
        get_general
    fi
}

get_apple_m() {
    brew install tmux
}

get_general() {
    version=${version:-$TMUX_VERSION}
    get_libevent
    get_ncurses
    wget https://github.com/tmux/tmux/releases/download/$version/tmux-$version.tar.gz || return
    tar -xzf tmux-$version.tar.gz
    cd tmux-$version
    CPPFLAGS="-I$JGET/include -I$JGET/include/ncurses" LDFLAGS="-L$JGET/lib" ./configure --prefix=$prefix
    make -j $nr_worker
    make install
}

exists() {
    [[ -x $(command -v tmux) ]]
}
