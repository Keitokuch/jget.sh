exists() {
  [[ -d ~/.config/nvim/lua/core ]]
}

get() {
  mv ~/.config/nvim ~/.config/nvim.bak
  git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
  # nvim  --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}
