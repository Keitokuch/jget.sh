VERSION=1.4.19

get() {
    local version=${version:-$VERSION}
    local m4=m4-${version}
    local zfile=${m4}.tar.gz
    wget ftp://ftp.gnu.org/gnu/m4/${zfile} || return
    tar -xzf $zfile
    cd $m4
    ./configure --prefix=$prefix  || return
    make -j $nr_worker          || return
    make install                || return
}

remove() {
    local version=${version:-$VERSION}
    local m4=m4-${version}
    local zfile=${m4}.tar.gz
    wget ftp://ftp.gnu.org/gnu/m4/${zfile} || return
    tar -xzf $zfile
    cd $m4
    ./configure --prefix=$prefix
    make uninstall
}

exists() {
    has_command m4
}
