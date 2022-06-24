exists() {
  has_command rg
}

get() {
    case $os in
        ubuntu)
            get_debian
            ;;
        debian)
            get_debian
            ;;
        macos)
            get_macos
            ;;
        *)
            return $ERR_SUPPORT
            ;;
    esac
}

get_debian() {
  curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
  sudo dpkg -i ripgrep_13.0.0_amd64.deb
}

get_macos() {
  brew install ripgrep
}
