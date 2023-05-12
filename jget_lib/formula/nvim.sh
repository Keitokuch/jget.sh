NVIM_VERSION=0.8.0

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
    wget -O nvim.appimage https://github.com/neovim/neovim/releases/download/v$version/nvim.appimage || return $ERR_NETWORK
    chmod +x nvim.appimage
    mv nvim.appimage $BIN/nvim.appimage
    ln -sf $BIN/nvim.appimage $BIN/nvim
}

get_macos() {
    wget https://github.com/neovim/neovim/releases/download/v$version/nvim-macos.tar.gz || return $ERR_NETWORK
    xattr -c ./nvim-macos.tar.gz
    tar xzf nvim-macos.tar.gz
    nvim_folder=nvim-osx64
    [[ -d nvim-macos ]] && nvim_folder=nvim-macos
    [[ -d $BIN/nvim-osx64 ]] && mv $BIN/nvim-osx64 $BUILD/nvim-bak 2>/dev/null
    [[ -d $BIN/nvim-macos ]] && mv $BIN/nvim-macos $BUILD/nvim-bak 2>/dev/null
    mv $nvim_folder $BIN/
    add_path "$BIN/$nvim_folder/bin"
}
