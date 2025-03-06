NVIM_VERSION=0.9.4

get() {
    version=${version:-$NVIM_VERSION}
    case $ostype in
        linux)
            get_linux
            return
            ;;
        darwin)
            get_macos
            return
            ;;
        *)
            return $ERR_SUPPORT
            ;;
    esac
}

remove() {
    cd $BIN
    rm -r nvim*
}

exists() {
    has_command nvim
}

get_linux() {
    wget -O nvim.appimage https://github.com/neovim/neovim-releases/releases/download/v$version/nvim-linux-x86_64.appimage || return $ERR_NETWORK
    chmod +x nvim.appimage
    mv nvim.appimage $BIN/nvim.appimage
    ln -sf $BIN/nvim.appimage $BIN/nvim
}

get_macos() {
    archive_name="nvim-macos"
    [[ "$version" == 0.10.* ]] && archive_name="nvim-macos-$arch"
    wget -O nvim-macos.tar.gz  https://github.com/neovim/neovim/releases/download/v${version}/${archive_name}.tar.gz || return $ERR_NETWORK

    xattr -c ./nvim-macos.tar.gz
    tar xzf nvim-macos.tar.gz
    nvim_folder=$(ls -d nvim-* 2>/dev/null | head -n 1)
    nvim_target="nvim-macos"
    [[ -d $BIN/$nvim_target ]] && mv $BIN/$nvim_target $BUILD/nvim-bak 2>/dev/null
    mv $nvim_folder $BIN/$nvim_target
    add_path "$BIN/$nvim_target/bin"
}
