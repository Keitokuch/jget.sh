VERSION=3.2.1

get() {
    local version=${version:-$VERSION}
    wget https://github.com/htop-dev/htop/releases/download/${version}/htop-${version}.tar.xz || return $ERR_NETWORK
    tar -xzf htop-${version}.tar.xz
    cd htop-${version}
    ./configure --prefix=$prefix
    make -j$nr_worker && make install
}


exists() {
    has_command htop
}

remove() {
    local version=${version:-$VERSION}
    wget https://github.com/htop-dev/htop/releases/download/${version}/htop-${version}.tar.xz || return $ERR_NETWORK
    tar -xzf htop-${version}.tar.xz
    cd htop-${version}
    ./configure --prefix=$prefix
    make uninstall
}
