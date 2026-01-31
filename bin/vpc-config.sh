#!/usr/bin/env bash

set -euo pipefail

#-----------------------------------------------------------------------------------------------------
# helper functions
#-----------------------------------------------------------------------------------------------------

cat_pubkey() {
  cat <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAABIwAABAEA0v+L/SmZlajz5+sfC5yjtuy8jssu5UpXT/gHZoD43S6m9zN+iSPalz9XHaozGpyqzBYfRe97NMDYfe6O/qTZpAc7VAMrPgu5m55eXOIY2Rpv3eMBePoEmaXvNXxFpFGRdTZSxhMgZ2QQt2ARFRjz/YHaU7g8JLIE2LfGq+QtcbMZC4eJQMqLb2q8w0k0m6YOwZ/yXT8QOb0XpKBZlZuEmWrXFhX7DZQtSw7r+ct1XR7oISevO5kjWaiuKL3ZSom6JpavKCd0+cgG/Bmi/zKF3/bI0nqmzgxEVkBgnoR/0zs+9KzNhIQe0icxRv/80p3384IneBwbD2eiWvn2Q8+YZDtBmrbItsG/4v1vmRQ27c3V86/TiefQjnLyOU0WW8XPzk0xWJYi7Ib9Ie1pyCbyiZMEWbEE6Q5nGF/N4I8ii54BJkb3URUht4AnWQWTcwT86+I1LGgEryTb7dWudHGbNXIdTCJKMfr1soqVjej7jwRoS/7IH2MZrdbRufty63EPYO1kUC29e2kKvBezFNXR+MRgLgQNVgM3L617S64CKqR18mxapBzoqE88LnU9EYGPPt/o6pj5O1JFiW63Tohw5XnasSyGNENbL36jxvfrWCHsf9d0W2VnuvR+2UbeE+ASE+h8g/UkIxQEU+GuErhbSggFheWAXe10BBhQK9jzYq9KEEDEAWlf5dNjqiB2SRIoTAcana3YJXjF/ogdCrJaBbxRCMVaa62FcjP+xSJ3Cv5H6HHn85AJbff7A2WQsL8cd0CFfu7WshNQq0EXorAZUJzOYQb7hYaCQYH8GxzZmnMt6WskoHT84h1wzgOh0ZtMaKCWwYQD8F3FJhBtmi/5s+5b/OUagp8ZDUtK543T/g36eBvvJjFkjvaeWqO/OCWzkScC/cZEiElE5IjpFPtsI66lwcCv3jL5OKUpXI1e7SDZVkXbjlQs+WIRzu+23Lmu+CdjpF1rTxvqSaefHlTbHG5hW87a+UC3U07geoKza/RT1+IBf3U3hPzeERZCm6ZZY8/Wd//CrY/6vSw0TmzImjxaGB8IYmVIHh+mHzSlodgnevtgElL3/2l9muphNhZ6tsIIbv28n9muKuiYslEcsE64AQPeRYL0tXgqv15K3GCbF1lDyA4u/hJYfQTcHxw5c94cg/DoD7g4iR1HS+2d8b6VNubD5TjT0zL9LmRcMXbFtSTAM0qThrV4bVaJtiGjUBBueGwtgI9DAnc+IfYNNhUkAjogLBs/5erTA0a9LRYJqzyaXCvphjhhO0jrjm3oTY7IDwxSa041QN+MPFrzAW9ls270edKuQLeHmsT/JAJrFmDOnJdA1GLFcpPrY1wJBZUzgt6bv5gU1uOPY+gjUQ== countskm@digicat.org-2014
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJrijv0iU9aoqJTwxdTuMWcXAeNm4UsHCCuHz5MhZi3z beattyga@Hawksey
EOF
}

cat_bashrc() {
  cat <<EOF
if [[ \$- != *i* ]]; then return; fi

export EDITOR=vim
export HISTCONTROL=ignoreboth
export HISTFILESIZE=-1
export HISTSIZE=-1
export PS1='\\n[\$(pwd)]$ '

shopt -s checkwinsize

source /etc/bash_completion
EOF
}

#-----------------------------------------------------------------------------------------------------
# commands
#-----------------------------------------------------------------------------------------------------

upos() {
  export DEBIAN_FRONTEND=noninteractive

  apt update

  apt-get -o "Dpkg::Options::=--force-confold" dist-upgrade -q -y --force-yes

  apt install -y ${OS_PACKAGES}

  cat <<EOF > /etc/ssh/sshd_config.d/50-cloud-init.conf
PasswordAuthentication yes
EOF

  service ssh restart
}

mkuser() {
  local user=$1; shift

  useradd -m -s /bin/bash ${user}

  if [[ $# -gt 0 ]]; then # set passwd
    echo "${user}:${1}" | chpasswd
  fi

  cat_bashrc > /home/${user}/.bashrc

  mkdir -p /home/${user}/.ssh

  chmod -R u=rX,go=-rwx /home/${user}/.ssh

  cat_pubkey > /home/${user}/.ssh/authorized_keys

  chmod 0600 /home/${user}/.ssh/authorized_keys

  chown -R ${user}:${user} /home/${user}
}

#-----------------------------------------------------------------------------------------------------
# global vars
#-----------------------------------------------------------------------------------------------------

OS_PACKAGES="
  curl
  git
  rsync
  tmux
  tree
  wget
  ipython3
"

#-----------------------------------------------------------------------------------------------------
# main
#-----------------------------------------------------------------------------------------------------

usage() {
  echo "Usage: $0 < upos | mkuser <username> [password]>" 1>&2
  exit 1
}

if [[ $# -lt 1 ]]; then
  usage
fi

"$@"
