VERSION=0.38.0

exists() {
  has_command lazygit
}


get() {
    version=${version:-$NVIM_VERSION}
    case $ostype in
        linux)
            _get_linux
            return
            ;;
        *)
            return $ERR_SUPPORT
            ;;
    esac
}

_get_linux() {
    local version=${version:-$VERSION}
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${version}/lazygit_${version}_Linux_x86_64.tar.gz" || return $ERR_NETWORK
    tar xf lazygit.tar.gz -C $BIN lazygit
}
