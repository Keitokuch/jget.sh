VERSION=0.35

exists() {
  has_command lazygit
}

get() {
    local version=${version:-$VERSION}
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${version}_Linux_x86_64.tar.gz"
    tar xzf lazygit.tar.gz -C $BIN lazygit
}
