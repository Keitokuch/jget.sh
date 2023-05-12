VERSION=0.9.97

exists() {
  [ -d /Applications/Hammerspoon.app ]
}

get() {
  [ ! is_macos ] && return $ERR_SUPPORT
  local version=${version:-$VERSION}
  wget https://github.com/Hammerspoon/hammerspoon/releases/download/${version}/Hammerspoon-${version}.zip || return $ERR_NETWORK
  unzip Hammerspoon-${version}.zip
  mv Hammerspoon.app /Applications
}
