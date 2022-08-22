VERSION=1.3.2.95rc1

get() {
    local version=${version:-$VERSION}
    local pkg=mosh-${version}
    local zfile=${pkg}.tar.gz
    wget https://github.com/mobile-shell/mosh/releases/download/${pkg}/${zfile} || return $ERR_NETWORK
    tar -xzf $zfile
    cd $pkg
    ./configure --prefix=$prefix  || return
    make -j $nr_worker          || return
    make install                || return
}

remove() {
    local version=${version:-$VERSION}
    local pkg=mosh-${version}
    local zfile=${pkg}.tar.gz
    wget https://github.com/mobile-shell/mosh/releases/download/${pkg}/${zfile} || return $ERR_NETWORK
    tar -xzf $zfile
    cd $pkg
    ./configure --prefix=$prefix
    make uninstall
}

exists() {
    has_command mosh
}
