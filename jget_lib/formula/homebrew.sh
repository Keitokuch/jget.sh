exists() {
  has_command brew
}

get() {
  [[ ~is_macos ]] && return $ERR_SUPPORT
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}
