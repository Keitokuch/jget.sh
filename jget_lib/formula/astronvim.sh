exists() {
  [[ -d ~/.config/nvim/lua/core ]]
}

get() {
  mv ~/.local/share/nvim ~/.local/share/nvim.bak
  mv ~/.local/state/nvim ~/.local/state/nvim.bak
  mv ~/.cache/nvim ~/.cache/nvim.bak
  mv ~/.config/nvim ~/.config/nvim.bak
  git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
  rm -rf ~/.config/nvim/.git
  # nvim  --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}

remove() {
  rm -rf ~/.config/nvim
}
