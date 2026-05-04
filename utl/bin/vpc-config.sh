#!/usr/bin/env bash

set -euo pipefail

#-----------------------------------------------------------------------------------------------------
# helper functions
#-----------------------------------------------------------------------------------------------------

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

  /bin/mkdir -p /opt/jj/bin /opt/nvim

  curl -sSL https://github.com/jj-vcs/jj/releases/download/v0.39.0/jj-v0.39.0-x86_64-unknown-linux-musl.tar.gz \
    | tar --extract --gunzip --directory=/opt/jj/bin --file=- ./jj

  curl -sSL https://github.com/neovim/neovim/releases/download/v0.11.6/nvim-linux-x86_64.tar.gz \
    | tar --extract --gunzip --directory=/opt/nvim/ --file=- --strip-components=1
}

mkuser() {
  local user=$1; shift

  useradd -m -s /bin/bash ${user}

  if [[ $# -gt 0 ]]; then # set passwd
    echo "${user}:${1}" | chpasswd
  fi

  mkdir -p /home/${user}/.ssh

  chmod -R u=rX,go=-rwx /home/${user}/.ssh

  # this will be overwritten when copying the config but necessary to bootstrap since we remote copy
  # as non-privleged user
  echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICHLtgP5Gb33c9xprXADHX7bS6TpCy2GNKQUUY29gcaI countskm-gen-2603" \
    > /home/${user}/.ssh/authorized_keys

  chmod 0600 /home/${user}/.ssh/authorized_keys

  chown -R ${user}:${user} /home/${user}

  echo "${user} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/90-cloud-init-users
}

#-----------------------------------------------------------------------------------------------------
# global vars
#-----------------------------------------------------------------------------------------------------

OS_PACKAGES="
  curl
  fzf
  git
  htop
  ipython3
  rsync
  tmux
  tree
  wget
  xterm
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
