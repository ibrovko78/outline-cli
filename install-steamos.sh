#!/bin/sh

error() {
  echo "${0}: ${1}" >& 2
  return 1
}

is_root() {
  [ "$(id -u)" -eq 0 ]
}

is_steamos() {
  [ -f "/etc/os-release" ] &&
  . "/etc/os-release" &&
  [ "${ID}" = "steamos" ]
}

is_installed() {
  [ -f "/usr/local/bin/__vpn_connect" ] && [ -x "/usr/local/bin/__vpn_connect" ] &&
  [ -f "/usr/local/bin/__vpn_manager" ] && [ -x "/usr/local/bin/__vpn_manager" ] &&
  [ -f "/usr/share/polkit-1/actions/vpn-manager.policy" ]
}

install_local() {
  "${@}"
}

install_remote() {
  curl -Ls "https://github.com/Kira-NT/outline-cli/blob/master/install.sh?raw=true" | sh -s -- "${@}"
}

install() {
  local install_filename="$(dirname "$(realpath -m "${0}")")/install.sh"
  local expected_header="#!/bin/sh Install the Outline Client CLI."
  local header="$(sed -n '1,3N;N;s/\n#//g;1,3p;q' "${install_filename}" 2> /dev/null)"
  if [ -x "${install_filename}" ] && [ "${header}" = "${expected_header}" ]; then
    install_local "${install_filename}" "${@}" <& 1
  else
    install_remote "${@}" <& 1
  fi
}

install_steamos_packages() {
  steamos-readonly disable 2> /dev/null
  pacman-key --init 2> /dev/null
  pacman-key --populate holo 2> /dev/null
  pacman -S --noconfirm git base-devel linux-neptune-headers glibc linux-api-headers 2> /dev/null
}

main() {
  is_installed && return
  is_steamos || error "cannot perform the installation: ${ID:-"unknown"}: Distribution is not supported" || return
  is_root || error "cannot perform the installation: Permission denied" || return

  install_steamos_packages
  install "${@}"
}

main "${@}"
