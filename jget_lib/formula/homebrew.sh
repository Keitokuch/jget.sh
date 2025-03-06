exists() {
  has_command brew
}

get() {
  [ ! is_macos ] && return $ERR_SUPPORT
  echo "Installing homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  if is_arm64 ; then
    profile_add 'eval "$(/opt/homebrew/bin/brew shellenv)"'
  fi
}
